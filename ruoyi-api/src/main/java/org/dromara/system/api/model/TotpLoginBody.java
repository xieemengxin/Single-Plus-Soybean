package org.dromara.system.api.model;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * TOTP 两步验证登录对象
 *
 * @author caoguangpei
 */
@Data
public class TotpLoginBody {

    /**
     * 两步验证会话票据（密码校验通过后由登录接口下发）
     */
    @NotBlank(message = "{auth.totp.step.token.not.blank}")
    private String stepToken;

    /**
     * 认证器生成的 6 位动态口令
     */
    @NotBlank(message = "{auth.totp.code.not.blank}")
    private String code;

}
