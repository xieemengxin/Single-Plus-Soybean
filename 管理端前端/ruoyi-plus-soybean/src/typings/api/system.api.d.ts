/**
 * Namespace Api
 *
 * All backend api type
 */
declare namespace Api {
  /**
   * namespace System
   *
   * backend api module: "system"
   */
  namespace System {
    /** data scope */
    type DataScope = '1' | '2' | '3' | '4' | '5' | '6';

    /** role */
    type Role = Common.CommonRecord<{
      /** 数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限） */
      dataScope: DataScope;
      /** 部门树选择项是否关联显示 */
      deptCheckStrictly: boolean;
      /** 用户是否存在此角色标识 默认不存在 */
      flag: boolean;
      /** 菜单树选择项是否关联显示 */
      menuCheckStrictly: boolean;
      /** 备注 */
      remark?: string;
      /** 角色ID */
      roleId: CommonType.IdType;
      /** 角色权限字符串 */
      roleKey: string;
      /** 角色名称 */
      roleName: string;
      /** 显示顺序 */
      roleSort: number;
      /** 角色状态（0正常 1停用） */
      status: Common.EnableStatus;
      /** 是否管理员 */
      superAdmin: boolean;
    }>;

    /** role search params */
    type RoleSearchParams = CommonType.RecordNullable<
      Pick<Api.System.Role, 'roleName' | 'roleKey' | 'status'> & Api.Common.CommonSearchParams
    >;

    /** role operate params */
    type RoleOperateParams = CommonType.RecordNullable<
      Pick<
        Api.System.Role,
        | 'roleId'
        | 'roleName'
        | 'roleKey'
        | 'roleSort'
        | 'menuCheckStrictly'
        | 'deptCheckStrictly'
        | 'dataScope'
        | 'status'
        | 'remark'
      > & { menuIds: CommonType.IdType[]; deptIds: CommonType.IdType[] }
    >;

    /** role list */
    type RoleList = Common.PaginatingQueryRecord<Role>;

    /** role menu tree select（menus 为 hutool Tree 结构） */
    type RoleMenuTreeSelect = {
      checkedKeys: CommonType.IdType[];
      menus: Common.CommonTreeRecord;
    };
    /** role dept tree select（depts 为 hutool Tree 结构） */
    type RoleDeptTreeSelect = {
      checkedKeys: CommonType.IdType[];
      depts: Common.CommonTreeRecord;
    };

    /** all role */
    type AllRole = Pick<Role, 'roleId' | 'roleName' | 'roleKey'>;

    /**
     * user gender
     *
     * - "1": "male"
     * - "2": "female"
     */
    type UserGender = '1' | '2';

    /** user */
    type User = Common.CommonRecord<{
      /** 用户ID */
      userId: CommonType.IdType;
      /** 部门ID */
      deptId: CommonType.IdType;
      /** 部门名称 */
      deptName: string;
      /** 用户账号 */
      userName: string;
      /** 用户昵称 */
      nickName: string;
      /** 用户类型（sys_user系统用户） */
      userType: string;
      /** 用户邮箱 */
      email: string;
      /** 手机号码 */
      phoneNumber: string;
      /** 用户性别（0男 1女 2未知） */
      gender: string;
      /** 头像 OSS ID */
      avatar?: CommonType.IdType;
      /** 头像地址 */
      avatarUrl?: string;
      /** 密码 */
      password: string;
      /** 帐号状态（0正常 1停用） */
      status: Common.EnableStatus;
      /** 最后登录IP */
      loginIp: string;
      /** 最后登录时间 */
      loginDate: string;
      /** 备注 */
      remark?: string;
      /** 所属角色列表 */
      roles?: Role[];
      /** 角色 ID 列表 */
      roleIds?: CommonType.IdType[];
      /** 岗位 ID 列表 */
      postIds?: CommonType.IdType[];
      /** 角色 ID */
      roleId?: CommonType.IdType;
    }>;

    /** user search params */
    type UserSearchParams = CommonType.RecordNullable<
      Pick<User, 'deptId' | 'userName' | 'nickName' | 'phoneNumber' | 'status'> & {
        roleId: CommonType.IdType;
      } & Common.CommonSearchParams
    >;

    /** user operate params */
    type UserOperateParams = CommonType.RecordNullable<
      Pick<
        User,
        | 'userId'
        | 'deptId'
        | 'userName'
        | 'nickName'
        | 'email'
        | 'phoneNumber'
        | 'gender'
        | 'password'
        | 'status'
        | 'remark'
      > & { roleIds: CommonType.IdType[]; postIds: CommonType.IdType[] }
    >;

    /** user profile operate params */
    type UserProfileOperateParams = CommonType.RecordNullable<Pick<User, 'nickName' | 'email' | 'phoneNumber' | 'gender'>>;

    /** user password operate params */
    type UserPasswordOperateParams = CommonType.RecordNullable<{
      oldPassword: string;
      newPassword: string;
    }>;

    /** user info（GET /system/user/ 与 /system/user/{userId} 返回） */
    type UserInfo = {
      /** user */
      user?: User;
      /** user post ids */
      postIds: CommonType.IdType[];
      /** user role ids */
      roleIds: CommonType.IdType[];
      /** roles */
      roles: Role[];
      /** posts */
      posts?: Post[];
    };

    /** user list */
    type UserList = Common.PaginatingQueryRecord<User>;

    /** auth role */
    type AuthRole = {
      user: User;
      roles: Role[];
    };

    /** social */
    type Social = Common.CommonRecord<{
      /** 主键 */
      id: CommonType.IdType;
      /** 用户ID */
      userId: CommonType.IdType;
      /** 认证的唯一ID */
      authId: string;
      /** 用户来源 */
      source: string;
      /** 用户的授权令牌 */
      accessToken: string;
      /** 用户的授权令牌的有效期，部分平台可能没有 */
      expireIn: number;
      /** 刷新令牌，部分平台可能没有 */
      refreshToken: string;
      /** 用户的 open id */
      openId: string;
      /** 授权的第三方账号 */
      userName: string;
      /** 授权的第三方昵称 */
      nickName: string;
      /** 授权的第三方邮箱 */
      email: string;
      /** 授权的第三方头像地址 */
      avatar: string;
      /** 平台的授权信息，部分平台可能没有 */
      accessCode: string;
      /** 用户的 unionid */
      unionId: string;
      /** 授予的权限，部分平台可能没有 */
      scope: string;
      /** 个别平台的授权信息，部分平台可能没有 */
      tokenType: string;
      /** id token，部分平台可能没有 */
      idToken: string;
      /** 小米平台用户的附带属性，部分平台可能没有 */
      macAlgorithm: string;
      /** 小米平台用户的附带属性，部分平台可能没有 */
      macKey: string;
      /** 用户的授权code，部分平台可能没有 */
      code: string;
      /** Twitter平台用户的附带属性，部分平台可能没有 */
      oauthToken: string;
      /** Twitter平台用户的附带属性，部分平台可能没有 */
      oauthTokenSecret: string;
    }>;

    /**
     * icon type
     *
     * - "1": iconify icon
     * - "2": local icon
     */
    type IconType = '1' | '2';

    /**
     * menu layout
     *
     * - "0": "默认布局"
     * - "1": "空白布局"
     */
    type MenuLayout = '0' | '1';

    /**
     * menu type
     *
     * - "M": "目录"
     * - "C": "菜单"
     * - "F": "按钮"
     */
    type MenuType = 'M' | 'C' | 'F';

    /**
     * 是否外链（后端字段）
     *
     * - "Y": "是"
     * - "N": "否"
     */
    type IsMenuFrame = 'Y' | 'N';

    /**
     * 表单用外链三态，提交时映射为 isFrame + component
     *
     * - internal: 内部路由（isFrame=N）
     * - external: 外链（isFrame=Y）
     * - iframe: 内嵌 iframe（isFrame=N + component=FrameView + queryParam 存 url）
     */
    type MenuFrameType = 'internal' | 'external' | 'iframe';

    type Menu = Common.CommonRecord<{
      /** 菜单 ID */
      menuId: CommonType.IdType;
      /** 父菜单 ID */
      parentId: CommonType.IdType;
      /** 菜单名称 */
      menuName: string;
      /** 显示顺序 */
      orderNum: number;
      /** 路由地址 */
      path: string;
      /** 组件路径 */
      component: string;
      /** 路由参数 */
      queryParam: string;
      /** 是否为外链（Y是 N否） */
      isFrame: IsMenuFrame;
      /** 是否缓存（Y缓存 N不缓存） */
      isCache: Common.YesOrNoStatus;
      /** 菜单类型（M目录 C菜单 F按钮） */
      menuType: MenuType;
      /** 显示状态（0显示 1隐藏） */
      visible: Common.VisibleStatus;
      /** 菜单状态（0正常 1停用） */
      status: Common.EnableStatus;
      /** 权限标识 */
      perms: string;
      /** 菜单图标 */
      icon: string;
      /** 备注 */
      remark?: string;
      /** 父菜单名称 */
      parentName: string;
      /** 子菜单 */
      children: MenuList;
      id?: CommonType.IdType;
      label?: string;
    }>;

    /** menu list */
    type MenuList = Menu[];

    /** menu search params */
    type MenuSearchParams = CommonType.RecordNullable<Pick<Menu, 'menuName' | 'status' | 'menuType' | 'parentId'>>;

    /** menu operate params */
    type MenuOperateParams = CommonType.RecordNullable<
      Pick<
        Menu,
        | 'menuId'
        | 'menuName'
        | 'parentId'
        | 'orderNum'
        | 'path'
        | 'component'
        | 'queryParam'
        | 'isFrame'
        | 'isCache'
        | 'menuType'
        | 'visible'
        | 'status'
        | 'perms'
        | 'icon'
        | 'remark'
      >
    >;

    /** 字典类型 */
    type DictType = Common.CommonRecord<{
      /** 字典主键 */
      dictId: CommonType.IdType;
      /** 字典名称 */
      dictName: string;
      /** 字典类型 */
      dictType: string;
      /** 备注 */
      remark: string;
    }>;

    /** dict type search params */
    type DictTypeSearchParams = CommonType.RecordNullable<
      Pick<Api.System.DictType, 'dictName' | 'dictType'> & Api.Common.CommonSearchParams
    >;

    /** dict type operate params */
    type DictTypeOperateParams = CommonType.RecordNullable<
      Pick<Api.System.DictType, 'dictId' | 'dictName' | 'dictType' | 'remark'>
    >;

    /** dict type list */
    type DictTypeList = Api.Common.PaginatingQueryRecord<DictType>;

    /** 字典数据 */
    type DictData = Common.CommonRecord<{
      /** 样式属性（其他样式扩展） */
      cssClass: string;
      /** 字典编码 */
      dictCode: CommonType.IdType;
      /** 字典标签 */
      dictLabel: string;
      /** 字典排序 */
      dictSort: number;
      /** 字典类型 */
      dictType: string;
      /** 字典键值 */
      dictValue: string;
      /** 是否默认（Y是 N否） */
      isDefault: Common.YesOrNoStatus;
      /** 表格回显样式 */
      listClass: NaiveUI.ThemeColor;
      /** 备注 */
      remark: string;
      /** 是否多语言 */
      isI18n?: boolean;
      /** 多语言标识 */
      i18nKey: App.I18n.I18nKey;
    }>;

    /** dict data search params */
    type DictDataSearchParams = CommonType.RecordNullable<
      Pick<Api.System.DictData, 'dictLabel' | 'dictType'> & Api.Common.CommonSearchParams
    >;

    /** dict data operate params */
    type DictDataOperateParams = CommonType.RecordNullable<
      Pick<
        Api.System.DictData,
        | 'dictCode'
        | 'dictSort'
        | 'dictLabel'
        | 'dictValue'
        | 'dictType'
        | 'cssClass'
        | 'listClass'
        | 'isDefault'
        | 'remark'
      >
    >;

    /** dict data list */
    type DictDataList = Api.Common.PaginatingQueryRecord<DictData>;

    /** dept */
    type Dept = Api.Common.CommonRecord<{
      /** 部门id */
      deptId: CommonType.IdType;
      /** 父部门id */
      parentId: CommonType.IdType;
      /** 祖级列表 */
      ancestors: string;
      /** 部门名称 */
      deptName: string;
      /** 部门类别编码 */
      deptCategory: string;
      /** 显示顺序 */
      orderNum: number;
      /** 负责人（用户 ID） */
      leader: number;
      /** 负责人名称 */
      leaderName?: string;
      /** 联系电话 */
      phone: string;
      /** 邮箱 */
      email: string;
      /** 部门状态（0正常 1停用） */
      status: Common.EnableStatus;
      /** 子部门 */
      children: Dept[];
    }>;

    /** dept search params */
    type DeptSearchParams = CommonType.RecordNullable<
      Pick<Api.System.Dept, 'deptName' | 'status'> & Api.Common.CommonSearchParams
    >;

    /** dept operate params */
    type DeptOperateParams = CommonType.RecordNullable<
      Pick<
        Api.System.Dept,
        'deptId' | 'parentId' | 'deptName' | 'deptCategory' | 'orderNum' | 'leader' | 'phone' | 'email' | 'status'
      >
    >;

    /** dept list */
    type DeptList = Api.Common.PaginatingQueryRecord<Dept>;

    /** post */
    type Post = Common.CommonRecord<{
      /** 岗位ID */
      postId: CommonType.IdType;
      /** 部门id */
      deptId: CommonType.IdType;
      /** 岗位编码 */
      postCode: string;
      /** 类别编码 */
      postCategory: string;
      /** 岗位名称 */
      postName: string;
      /** 显示顺序 */
      postSort: number;
      /** 状态（0正常 1停用） */
      status: Common.EnableStatus;
      /** 备注 */
      remark: string;
    }>;

    /** post search params */
    type PostSearchParams = CommonType.RecordNullable<
      Pick<Api.System.Post, 'deptId' | 'postCode' | 'postName' | 'status'> & {
        belongDeptId: CommonType.IdType;
      } & Api.Common.CommonSearchParams
    >;

    /** post operate params */
    type PostOperateParams = CommonType.RecordNullable<
      Pick<
        Api.System.Post,
        'postId' | 'deptId' | 'postCode' | 'postCategory' | 'postName' | 'postSort' | 'status' | 'remark'
      >
    >;

    /** post list */
    type PostList = Api.Common.PaginatingQueryRecord<Post>;

    /** config */
    type Config = Common.CommonRecord<{
      /** 参数主键 */
      configId: CommonType.IdType;
      /** 参数名称 */
      configName: string;
      /** 参数键名 */
      configKey: string;
      /** 参数键值 */
      configValue: string;
      /** 是否内置 */
      configType: Common.YesOrNoStatus;
      /** 备注 */
      remark: string;
    }>;

    /** config search params */
    type ConfigSearchParams = CommonType.RecordNullable<
      Pick<Api.System.Config, 'configName' | 'configKey' | 'configType' | 'createTime'> & Api.Common.CommonSearchParams
    >;

    /** config operate params */
    type ConfigOperateParams = CommonType.RecordNullable<
      Pick<Api.System.Config, 'configId' | 'configName' | 'configKey' | 'configValue' | 'configType' | 'remark'>
    >;

    /** config list */
    type ConfigList = Api.Common.PaginatingQueryRecord<Config>;

    /** 通知公告类型 */
    type NoticeType = '1' | '2';

    /** notice */
    type Notice = Common.CommonRecord<{
      /** 公告ID */
      noticeId: CommonType.IdType;
      /** 公告标题 */
      noticeTitle: string;
      /** 公告类型 */
      noticeType: System.NoticeType;
      /** 公告内容 */
      noticeContent: string;
      /** 公告状态 */
      status: Common.EnableStatus;
      /** 创建者 */
      createByName: string;
      /** 备注 */
      remark: string;
    }>;

    /** notice search params */
    type NoticeSearchParams = CommonType.RecordNullable<
      Pick<Api.System.Notice, 'noticeTitle' | 'noticeType'> & Api.Common.CommonSearchParams
    >;

    /** notice operate params */
    type NoticeOperateParams = CommonType.RecordNullable<
      Pick<Api.System.Notice, 'noticeId' | 'noticeTitle' | 'noticeType' | 'noticeContent' | 'status'>
    >;

    /** notice list */
    type NoticeList = Api.Common.PaginatingQueryRecord<Notice>;

    /** 授权类型 */
    type GrantType = 'password' | 'sms' | 'password' | 'email' | 'xcx' | 'social';

    /** 设备类型 */
    type DeviceType = 'pc' | 'android' | 'ios' | 'xcx';

    /** client */
    type Client = Common.CommonRecord<{
      /** id */
      id: CommonType.IdType;
      /** 客户端id */
      clientId: string;
      /** 客户端key */
      clientKey: string;
      /** 客户端秘钥 */
      clientSecret: string;
      /** 授权类型 */
      grantType: System.GrantType;
      /** 授权类型列表 */
      grantTypeList: System.GrantType[];
      /** 设备类型 */
      deviceType: System.DeviceType;
      /** token活跃超时时间 */
      activeTimeout: number;
      /** token固定超时 */
      timeout: number;
      /** 状态 */
      status: Common.EnableStatus;
      /** 允许访问的接口路径（多个逗号分隔） */
      accessPath?: string;
      /** 允许访问的接口路径列表 */
      accessPathList?: string[];
      /** IP 白名单（多个逗号分隔） */
      ipWhitelist?: string;
      /** IP 白名单列表 */
      ipWhitelistList?: string[];
    }>;

    /** client search params */
    type ClientSearchParams = CommonType.RecordNullable<
      Pick<Api.System.Client, 'clientKey' | 'clientSecret' | 'status'> & Api.Common.CommonSearchParams
    >;

    /** client operate params */
    type ClientOperateParams = CommonType.RecordNullable<
      Pick<
        Api.System.Client,
        | 'id'
        | 'clientId'
        | 'clientKey'
        | 'clientSecret'
        | 'grantTypeList'
        | 'deviceType'
        | 'activeTimeout'
        | 'timeout'
        | 'status'
      >
    >;

    /** client list */
    type ClientList = Api.Common.PaginatingQueryRecord<Client>;

    /** social source */
    type SocialSource =
      | 'maxkey'
      | 'topiam'
      | 'qq'
      | 'weibo'
      | 'gitee'
      | 'dingtalk'
      | 'baidu'
      | 'csdn'
      | 'coding'
      | 'oschina'
      | 'alipay_wallet'
      | 'wechat_open'
      | 'wechat_mp'
      | 'wechat_enterprise'
      | 'gitlab'
      | 'github';

    /** oss */
    type Oss = Common.CommonRecord<{
      /** 对象存储主键 */
      ossId: CommonType.IdType;
      /** 文件名 */
      fileName: string;
      /** 原名 */
      originalName: string;
      /** 文件后缀名 */
      fileSuffix: string;
      /** URL地址 */
      url: string;
      /** 扩展属性 */
      ext1: string;
      /** 服务商 */
      service: string;
      /** 创建者名称 */
      createByName: string;
    }>;

    /** oss upload result（POST /resource/oss/upload 返回，注意 ossId 为字符串） */
    type OssUpload = {
      /** URL 地址 */
      url: string;
      /** 文件名 */
      fileName: string;
      /** 对象存储主键 */
      ossId: string;
    };

    /** oss search params */
    type OssSearchParams = CommonType.RecordNullable<
      Pick<Api.System.Oss, 'fileName' | 'originalName' | 'fileSuffix' | 'service'> & Api.Common.CommonSearchParams
    >;

    /** oss list */
    type OssList = Api.Common.PaginatingQueryRecord<Oss>;

    /** oss access policy */
    type OssAccessPolicy = '0' | '1' | '2';

    /** oss config */
    type OssConfig = Common.CommonRecord<{
      /** 主键 */
      ossConfigId: CommonType.IdType;
      /** 配置名称 */
      configKey: string;
      /** accessKey */
      accessKey: string;
      /** 秘钥secretKey */
      secretKey: string;
      /** 桶名称 */
      bucketName: string;
      /** 前缀 */
      prefix: string;
      /** 访问站点 */
      endpoint: string;
      /** 自定义域名 */
      domainUrl: string;
      /** 是否https（Y=是,N=否） */
      isHttps: Common.YesOrNoStatus;
      /** 域 */
      region: string;
      /** 桶权限类型 */
      accessPolicy: System.OssAccessPolicy;
      /** 是否默认（Y=是,N=否） */
      status: Common.YesOrNoStatus;
      /** 扩展字段 */
      ext1: string;
      /** 备注 */
      remark: string;
    }>;

    /** oss config search params */
    type OssConfigSearchParams = CommonType.RecordNullable<
      Pick<Api.System.OssConfig, 'configKey' | 'bucketName' | 'region' | 'status'> & Api.Common.CommonSearchParams
    >;

    /** oss config operate params */
    type OssConfigOperateParams = CommonType.RecordNullable<
      Pick<
        Api.System.OssConfig,
        | 'ossConfigId'
        | 'configKey'
        | 'accessKey'
        | 'secretKey'
        | 'bucketName'
        | 'prefix'
        | 'endpoint'
        | 'domainUrl'
        | 'isHttps'
        | 'region'
        | 'accessPolicy'
        | 'status'
        | 'remark'
      >
    >;

    /** oss config list */
    type OssConfigList = Api.Common.PaginatingQueryRecord<OssConfig>;
  }
}
