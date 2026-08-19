package org.dromara.web.domain.vo;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * 登录成功后的令牌信息返回对象。
 *
 * @author Michelle.Chung
 */
@Data
public class LoginVo {

    /**
     * 授权令牌
     */
    @JsonProperty("access_token")
    private String accessToken;

    /**
     * 刷新令牌
     */
    @JsonProperty("refresh_token")
    private String refreshToken;

    /**
     * 授权令牌 access_token 的有效期
     */
    @JsonProperty("expire_in")
    private Long expireIn;

    /**
     * 刷新令牌 refresh_token 的有效期
     */
    @JsonProperty("refresh_expire_in")
    private Long refreshExpireIn;

    /**
     * 应用id
     */
    @JsonProperty("client_id")
    private String clientId;

    /**
     * 令牌权限
     */
    private String scope;

    /**
     * 用户 openid
     */
    private String openid;

    /**
     * 是否需要 TOTP 两步验证（为 true 时本次响应不包含 token）
     */
    private Boolean totpRequired;

    /**
     * 是否需要首次绑定认证器（为 true 时下发密钥与二维码内容）
     */
    private Boolean totpBind;

    /**
     * 两步验证会话票据（提交动态口令时回传）
     */
    private String totpStepToken;

    /**
     * 待绑定的 TOTP 密钥（仅首次绑定时下发，供手动录入）
     */
    private String totpSecret;

    /**
     * 待绑定的 otpauth 二维码内容（仅首次绑定时下发）
     */
    private String totpQrUrl;

}
