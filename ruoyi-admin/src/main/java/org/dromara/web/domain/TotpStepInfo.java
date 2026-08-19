package org.dromara.web.domain;

import lombok.Data;
import org.dromara.system.api.model.LoginUser;

import java.io.Serial;
import java.io.Serializable;

/**
 * TOTP 两步验证登录中间态（密码校验通过后暂存 Redis，动态口令校验通过后完成登录）
 *
 * @author caoguangpei
 */
@Data
public class TotpStepInfo implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 已通过密码校验的登录用户信息
     */
    private LoginUser loginUser;

    /**
     * 客户端id
     */
    private String clientId;

    /**
     * 本次校验使用的 TOTP 密钥（未绑定用户为新生成的待绑定密钥）
     */
    private String secret;

    /**
     * 是否为首次绑定（校验通过后需要落库保存密钥）
     */
    private Boolean bind;

    /**
     * 已失败次数
     */
    private Integer errorCount = 0;

}
