package org.dromara.web.config.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * TOTP 两步验证配置
 *
 * @author caoguangpei
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "security.totp")
public class TotpProperties {

    /**
     * 是否开启 TOTP 两步验证
     */
    private Boolean enabled = false;

    /**
     * 令牌签发者（展示在 Google Authenticator 等认证器中）
     */
    private String issuer = "RuoYi-Vue-Plus";

    /**
     * 验证会话有效期（分钟）
     */
    private Integer stepTimeout = 5;

    /**
     * 允许的最大验证失败次数，超出后需重新登录
     */
    private Integer maxRetryCount = 5;

}
