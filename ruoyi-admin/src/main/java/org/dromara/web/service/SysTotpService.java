package org.dromara.web.service;

import cn.dev33.satoken.stp.StpUtil;
import cn.dev33.satoken.stp.parameter.SaLoginParameter;
import cn.hutool.core.codec.Base32;
import cn.hutool.core.net.URLEncodeUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.crypto.digest.otp.HOTP;
import cn.hutool.crypto.digest.otp.TOTP;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.dromara.common.core.constant.Constants;
import org.dromara.common.core.constant.GlobalConstants;
import org.dromara.common.core.constant.SystemConstants;
import org.dromara.common.core.exception.ServiceException;
import org.dromara.common.core.utils.MessageUtils;
import org.dromara.common.core.utils.StringUtils;
import org.dromara.common.mybatis.helper.DataPermissionHelper;
import org.dromara.common.redis.utils.RedisUtils;
import org.dromara.common.satoken.utils.LoginHelper;
import org.dromara.system.api.model.LoginUser;
import org.dromara.system.api.model.TotpLoginBody;
import org.dromara.system.domain.SysUser;
import org.dromara.system.domain.vo.SysClientVo;
import org.dromara.system.mapper.SysUserMapper;
import org.dromara.system.service.ISysClientService;
import org.dromara.web.config.properties.TotpProperties;
import org.dromara.web.domain.TotpStepInfo;
import org.dromara.web.domain.vo.LoginVo;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;

/**
 * TOTP 两步验证服务（密码校验通过后下发验证会话，动态口令校验通过后签发 token）
 *
 * @author caoguangpei
 */
@Slf4j
@RequiredArgsConstructor
@Service
public class SysTotpService {

    /**
     * TOTP 密钥随机字节数（Base32 编码后 32 位字符）
     */
    private static final int SECRET_BYTES = 20;

    private final TotpProperties totpProperties;
    private final SysLoginService loginService;
    private final SysUserMapper userMapper;
    private final ISysClientService clientService;

    /**
     * 是否开启 TOTP 两步验证
     */
    public boolean isEnabled() {
        return Boolean.TRUE.equals(totpProperties.getEnabled());
    }

    /**
     * 密码校验通过后构建两步验证中间态并暂存 Redis
     *
     * @param loginUser 已通过密码校验的登录用户
     * @param client    授权客户端
     * @return 携带两步验证信息的登录结果（不包含 token）
     */
    public LoginVo buildTotpStep(LoginUser loginUser, SysClientVo client) {
        String secret = selectTotpSecretById(loginUser.getUserId());
        boolean bind = StringUtils.isBlank(secret);
        if (bind) {
            secret = HOTP.generateSecretKey(SECRET_BYTES);
        }
        TotpStepInfo stepInfo = new TotpStepInfo();
        stepInfo.setLoginUser(loginUser);
        stepInfo.setClientId(client.getClientId());
        stepInfo.setSecret(secret);
        stepInfo.setBind(bind);
        String stepToken = IdUtil.fastSimpleUUID();
        RedisUtils.setCacheObject(GlobalConstants.TOTP_STEP_KEY + stepToken, stepInfo,
            Duration.ofMinutes(totpProperties.getStepTimeout()));

        LoginVo loginVo = new LoginVo();
        loginVo.setClientId(client.getClientId());
        loginVo.setTotpRequired(true);
        loginVo.setTotpBind(bind);
        loginVo.setTotpStepToken(stepToken);
        if (bind) {
            loginVo.setTotpSecret(secret);
            loginVo.setTotpQrUrl(buildQrUrl(loginUser.getUsername(), secret));
        }
        return loginVo;
    }

    /**
     * 校验动态口令并完成登录（首次绑定时校验通过后落库保存密钥）
     *
     * @param body 两步验证登录对象
     * @return 登录验证信息
     */
    public LoginVo totpLogin(TotpLoginBody body) {
        String stepKey = GlobalConstants.TOTP_STEP_KEY + body.getStepToken();
        TotpStepInfo stepInfo = RedisUtils.getCacheObject(stepKey);
        if (ObjectUtil.isNull(stepInfo)) {
            throw new ServiceException("两步验证会话已过期，请重新登录");
        }
        LoginUser loginUser = stepInfo.getLoginUser();
        if (!validateCode(stepInfo.getSecret(), body.getCode())) {
            int errorCount = stepInfo.getErrorCount() + 1;
            if (errorCount >= totpProperties.getMaxRetryCount()) {
                RedisUtils.deleteObject(stepKey);
                loginService.recordLoginInfo(loginUser.getUsername(), Constants.LOGIN_FAIL, "动态口令错误次数超限");
                throw new ServiceException("动态口令错误次数超限，请重新登录");
            }
            stepInfo.setErrorCount(errorCount);
            // 保留原有效期，避免失败重试无限续期
            RedisUtils.setCacheObject(stepKey, stepInfo, true);
            loginService.recordLoginInfo(loginUser.getUsername(), Constants.LOGIN_FAIL, "动态口令错误");
            throw new ServiceException("动态口令错误");
        }
        // 校验会话一次性使用
        RedisUtils.deleteObject(stepKey);
        // 首次绑定校验通过后落库保存密钥
        if (Boolean.TRUE.equals(stepInfo.getBind())) {
            updateTotpSecret(loginUser.getUserId(), stepInfo.getSecret());
        }
        SysClientVo client = clientService.queryByClientId(stepInfo.getClientId());
        if (ObjectUtil.isNull(client) || !SystemConstants.NORMAL.equals(client.getStatus())) {
            throw new ServiceException(MessageUtils.message("auth.grant.type.blocked"));
        }
        loginUser.setClientKey(client.getClientKey());
        loginUser.setDeviceType(client.getDeviceType());
        SaLoginParameter model = IAuthStrategy.buildLoginParameter(client);
        // 生成token
        LoginHelper.login(loginUser, model);

        LoginVo loginVo = new LoginVo();
        loginVo.setAccessToken(StpUtil.getTokenValue());
        loginVo.setExpireIn(StpUtil.getTokenTimeout());
        loginVo.setClientId(client.getClientId());
        return loginVo;
    }

    /**
     * 通过用户ID查询 TOTP 密钥
     *
     * @param userId 用户ID
     * @return Base32 编码的 TOTP 密钥，未绑定时返回 null
     */
    private String selectTotpSecretById(Long userId) {
        SysUser user = DataPermissionHelper.ignore(() -> userMapper.lambda()
            .select(SysUser::getUserId, SysUser::getTotpSecret)
            .eq(SysUser::getUserId, userId)
            .one());
        return ObjectUtil.isNull(user) ? null : user.getTotpSecret();
    }

    /**
     * 保存用户 TOTP 密钥（首次绑定落库）
     *
     * @param userId     用户ID
     * @param totpSecret Base32 编码的 TOTP 密钥
     */
    private void updateTotpSecret(Long userId, String totpSecret) {
        DataPermissionHelper.ignore(() -> userMapper.lambda()
            .set(SysUser::getTotpSecret, totpSecret)
            .eq(SysUser::getUserId, userId)
            .updateCount());
    }

    /**
     * 校验动态口令（允许前后一个时间窗的时钟偏差）
     *
     * @param secret Base32 编码的 TOTP 密钥
     * @param code   6 位动态口令
     * @return 是否通过
     */
    private boolean validateCode(String secret, String code) {
        if (!StringUtils.isNumeric(code)) {
            return false;
        }
        TOTP totp = new TOTP(Base32.decode(secret));
        return totp.validate(Instant.now(), 1, Integer.parseInt(code));
    }

    /**
     * 构建认证器扫码绑定用的 otpauth 二维码内容
     *
     * @param username 用户账号
     * @param secret   Base32 编码的 TOTP 密钥
     * @return otpauth 协议地址
     */
    private String buildQrUrl(String username, String secret) {
        String issuer = URLEncodeUtil.encode(totpProperties.getIssuer());
        return StringUtils.format("otpauth://totp/{}:{}?secret={}&issuer={}",
            issuer, URLEncodeUtil.encode(username), secret, issuer);
    }

}
