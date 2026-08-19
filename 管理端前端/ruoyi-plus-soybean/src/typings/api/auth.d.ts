declare namespace Api {
  /**
   * namespace Auth
   *
   * backend api module: "auth"
   */
  namespace Auth {
    /** base login form */
    interface LoginForm {
      /** 客户端 ID */
      clientId?: string;
      /** 授权类型 */
      grantType?: string;
      /** 验证码 */
      code?: string;
      /** 唯一标识 */
      uuid?: string;
    }

    /** password login form */
    interface PwdLoginForm extends LoginForm {
      /** 用户名 */
      username?: string;
      /** 密码 */
      password?: string;
    }

    /** social login form */
    interface SocialLoginForm extends LoginForm {
      /** 授权码 */
      socialCode?: string;
      /** 授权状态 */
      socialState?: string;
      /** 来源 */
      source?: string;
    }

    /** register form */
    interface RegisterForm extends LoginForm {
      /** 用户名 */
      username?: string;
      /** 密码 */
      password?: string;
      /** 确认密码 */
      confirmPassword?: string;
      /** 用户类型 */
      userType?: string;
    }

    /** totp login form */
    interface TotpLoginForm {
      /** 两步验证会话票据 */
      stepToken: string;
      /** 6 位动态口令 */
      code: string;
    }

    /** totp verify state (frontend) */
    interface TotpInfo {
      /** 两步验证会话票据 */
      stepToken: string;
      /** 是否需要首次绑定 */
      bind: boolean;
      /** 待绑定密钥（仅首次绑定） */
      secret?: string;
      /** 待绑定二维码内容（仅首次绑定） */
      qrUrl?: string;
    }

    /** login token data */
    interface LoginToken {
      /** 授权令牌 */
      access_token?: string;
      /** 应用id */
      client_id?: string;
      /** 授权令牌 access_token 的有效期 */
      expire_in?: number;
      /** 用户 openid */
      openid?: string;
      /** 刷新令牌 refresh_token 的有效期 */
      refresh_expire_in?: number;
      /** 刷新令牌 */
      refresh_token?: string;
      /** 令牌权限 */
      scope?: string;
      /** 是否需要 TOTP 两步验证（为 true 时本次响应不含 token） */
      totpRequired?: boolean;
      /** 是否需要首次绑定认证器 */
      totpBind?: boolean;
      /** 两步验证会话票据 */
      totpStepToken?: string;
      /** 待绑定的 TOTP 密钥（仅首次绑定时下发） */
      totpSecret?: string;
      /** 待绑定的 otpauth 二维码内容（仅首次绑定时下发） */
      totpQrUrl?: string;
    }

    /** userinfo */
    interface UserInfo {
      /** 用户信息 */
      user?: Api.System.User & {
        /** 所属角色 */
        roles: Api.System.Role[];
      };
      /** 角色列表 */
      roles: string[];
      /** 菜单权限 */
      permissions: string[];
    }

    interface CaptchaCode {
      /** 是否开启验证码 */
      captchaEnabled: boolean;
      /** 唯一标识 */
      uuid?: string;
      /** 验证码图片 */
      img?: string;
    }
  }
}
