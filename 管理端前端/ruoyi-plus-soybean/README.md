<div align="center">
  <img src="https://docs.ruoyi.xlsea.cn/logo.svg" width="160">
  <h1>RuoYi-Plus-Soybean</h1>
</div>

<div style="height: 10px; clear: both;"></div>

<div align="center">
  <p>一个基于 <a href="https://gitee.com/dromara/RuoYi-Vue-Plus" target="_blank">RuoYi-Vue-Plus</a> 的单体后端能力和 <a href="https://github.com/soybeanjs/soybean-admin" target="_blank">Soybean Admin</a> 前端特性的现代化管理系统</p>
  <p>
    <a href="https://gitcode.com/xlsea/ruoyi-plus-soybean" target="_blank"><img src="https://gitcode.com/xlsea/ruoyi-plus-soybean/star/badge.svg" alt="GitCode"></a>
    <a href="https://github.com/m-xlsea/ruoyi-plus-soybean" target="_blank"><img src="https://img.shields.io/github/stars/m-xlsea/ruoyi-plus-soybean" alt="Github"></a>
    <a href="https://gitee.com/xlsea/ruoyi-plus-soybean" target="_blank"><img src="https://gitee.com/xlsea/ruoyi-plus-soybean/badge/star.svg" alt="Gitee"></a>
    <a href="https://vuejs.org" target="_blank"><img src="https://img.shields.io/badge/Vue-3.5-brightgreen" alt="vue"></a>
    <a href="https://www.typescriptlang.org" target="_blank"><img src="https://img.shields.io/badge/TypeScript-5.8-blue" alt="typescript"></a>
    <a href="https://vite.dev" target="_blank"><img src="https://img.shields.io/badge/Vite-6.2-orange" alt="vite"></a>
    <a href="https://www.naiveui.com" target="_blank"><img src="https://img.shields.io/badge/NaiveUI-2.41-purple" alt="naive-ui"></a>
    <a href="./LICENSE" target="_blank"><img src="https://img.shields.io/badge/License-MIT-yellow" alt="license"></a>
    <a href="https://qm.qq.com/q/jNMKfdCL8Q" target="_blank"><img src="https://img.shields.io/badge/QQ%E7%BE%A4-451067199-EB1923?logo=qq&logoColor=white" alt="license"></a>
  </p>
</div>

# 📢 重要通知

2.2.0 版本已经正式发布（工作流版本请切换 [flow](https://gitee.com/xlsea/ruoyi-plus-soybean/tree/flow/) 分支查看），但仍然建议：

- 在生产环境使用前进行充分测试
- 关注项目更新，及时获取最新版本
- 积极反馈问题，帮助我们快速迭代

**后续规划**

- 多语言国际化完善
- 性能优化和稳定性提升

> 如果对该项目感兴趣，可以给一个 Star 支持一下，谢谢！
> 请大家踊跃提交 PR 和 Issue，一起完善这个项目

# ❗开发前必看

<p style="font-weight: bold; font-size: 24px;">本项目强制使用 pnpm 构建，详细请看 <a href="#安装步骤及说明">安装步骤及说明</a></p>

<p style="font-weight: bold; font-size: 24px;">本前端已随本仓库后端（RuoYi-Vue-Plus 单体版）适配：代码生成模板内置于 ruoyi-gen 模块，菜单/字典 SQL 需在初始化后执行，详细请看 <a href="#代码生成与菜单更新">代码生成与菜单更新</a></p>

# 💎 友情链接

- [Snail Job Pro](https://pro.snailjob.opensnail.com/home) - 灵活，可靠和快速的分布式任务重试和分布式任务调度平台
- [AiZuDa - 爱组搭（飞龙工作流企业版）](https://naiveui.aizuda.com) - 像搭积木一样进行低代码甚至零代码快速构建应用

## 📋 项目概述

RuoYi-Plus-Soybean 是一个现代化的企业级管理系统前端，本仓库内的版本已适配 RuoYi-Vue-Plus 6.X 单体后端（已移除多租户能力），结合 Soybean Admin 的现代化前端特性，为开发者提供了完整的企业管理解决方案。

### 🌟 项目特点

- **单体后端**：对接 RuoYi-Vue-Plus 6.X（Spring Boot 单体应用），前后端接口路径与 Cloud 版保持一致
- **现代前端技术栈**：基于Vue 3、TypeScript、Vite和Naive UI构建
- **Monorepo工程管理**：使用pnpm workspaces管理多包结构
- **丰富的组件库**：内置大量业务组件和布局选项
- **主题定制**：支持多种布局模式和主题配色
- **国际化**：内置多语言支持
- **权限管理**：精细的基于角色的权限控制

## 🛠️ 技术栈

### 前端

- **核心框架**：Vue 3.5.x
- **开发语言**：TypeScript 5.8.x
- **构建工具**：Vite 6.2.x
- **UI组件库**：Naive UI 2.41.x
- **状态管理**：Pinia 3.0.x
- **路由**：Vue Router 4.5.x
- **HTTP客户端**：Axios/Alova
- **CSS**：UnoCSS
- **包管理器**：pnpm 8.x+

### 后端（本仓库 RuoYi-Vue-Plus 单体版）

- **核心框架**：Spring Boot（单体应用，默认 8080 端口）
- **权限认证**：Sa-Token
- **数据操作**：MyBatis-Plus
- **数据库**：MySQL 等多数据库

## 🏗️ 项目结构

```
root
├── build                    # 构建配置和插件
│   ├── config               # 构建配置文件
│   └── plugins              # Vite 插件
├── docs                     # 文档和模板
│   ├── java                 # 代码生成工具类
│   └── template             # 代码生成模板
├── packages                 # Monorepo包
│   ├── alova                # 使用Alova的HTTP客户端实现
│   ├── axios                # 使用Axios的HTTP客户端实现
│   ├── color                # 颜色管理工具
│   ├── hooks                # 可复用的Vue组合函数
│   ├── materials            # UI组件和材料
│   ├── ofetch               # 使用ofetch的HTTP客户端实现
│   ├── scripts              # 构建和开发脚本
│   ├── uno-preset           # UnoCSS预设配置
│   └── utils                # 通用工具函数
├── public                   # 静态资源
├── src                      # 主应用源代码
│   ├── assets               # 静态资源(图片、图标)
│   ├── components           # 可复用的 Vue 组件
│   ├── constants            # 应用常量
│   ├── enum                 # TypeScript 枚举
│   ├── hooks                # Vue 组合函数
│   ├── layouts              # 页面布局
│   ├── locales              # 国际化
│   ├── plugins              # Vue 插件
│   ├── router               # Vue Router 配置
│   ├── service              # API 服务
│   ├── store                # Pinia 存储模块
│   ├── styles               # 全局样式
│   ├── theme                # 主题配置
│   ├── typings              # TypeScript 类型定义
│   ├── utils                # 工具函数
│   └── views                # 页面组件
└── vite.config.ts           # Vite 配置
```

## 🚀 环境要求与安装

### 环境要求

- Node.js >= 20.19.0
- pnpm >= 10.5.0
- Git

### 安装步骤及说明

1. 克隆仓库

```bash
git clone https://gitee.com/xlsea/ruoyi-plus-soybean.git
cd ruoyi-plus-soybean
```

2. 安装 pnpm (如果未安装)

```bash
npm install pnpm -g
```

设置淘宝镜像

```bash
pnpm config set registry https://registry.npmmirror.com
```

3. 安装依赖

```bash
pnpm install
```

4. 运行开发服务器

```bash
pnpm dev
```

5. 构建生产版本

```bash
pnpm build
```

### 代码生成与菜单更新

本前端已随本仓库后端（RuoYi-Vue-Plus 单体版）完成适配，无需再做任何文件替换：

- **代码生成**
  - soybean 前端模板已内置于后端代码生成器：`ruoyi-modules/ruoyi-gen/src/main/resources/fm/soybean/`（FreeMarker 格式）
  - 在「系统工具 → 代码生成」编辑界面把 **前端模板类型** 选择为 `soybean` 即可生成本前端风格的 api / typings / views 代码
  - 旧版 `VelocityUtils.java` 替换与 `resource/vm/soy` 拷贝流程已废弃

- **菜单/字典 SQL 更新**
  - 适配 SQL 位于本目录 `docs/sql`，按数据库类型二选一执行：
    - MySQL：先执行 `script/sql/ry_vue.sql` 初始化，再依次执行 `docs/sql/sys_menu.sql` 与 `docs/sql/sys_dict_data.sql`
    - PostgreSQL：先执行 `script/sql/postgres/postgres_ry_vue.sql` 初始化，再依次执行 `docs/sql/postgres/sys_menu.sql` 与 `docs/sql/postgres/sys_dict_data.sql`
  - workflow 菜单/字典的停用与适配语句对应可选脚本 `ry_workflow.sql` / `postgres_ry_workflow.sql`，未执行该脚本时相关 UPDATE 命中 0 行，无副作用
  - 执行后请清理字典 Redis 缓存或重启后端服务

## 📝 开发指南

### 可用的脚本命令

```bash
# 开发环境
pnpm dev

# 测试环境
pnpm dev:test

# 生产环境
pnpm dev:prod

# 构建生产版本
pnpm build

# 构建开发版本
pnpm build:dev

# 构建测试版本
pnpm build:test

# 预览构建
pnpm preview

# 类型检查
pnpm typecheck

# 代码规范检查并修复
pnpm lint

# 路由生成
pnpm gen-route

# 提交代码
pnpm commit

# 中文提交信息
pnpm commit:zh

# 依赖包更新
pnpm update-pkg

# 清理项目
pnpm cleanup

# 发布新版本
pnpm release
```

### 代码规范与风格

项目使用ESLint进行代码检查，遵循以下规范：

- **命名规范**：
  - Vue组件: PascalCase (如 UserProfile.vue)
  - TypeScript文件: camelCase (如 userService.ts)
  - CSS/SCSS: kebab-case (如 user-profile.scss)

- **代码风格**：
  - 使用Vue 3 Composition API
  - 使用TypeScript类型系统
  - 遵循单一职责原则

### 核心开发模式

#### 状态管理

使用Pinia进行状态管理，模块位于`src/store/modules`目录：

- **app**: 应用全局状态
- **theme**: 主题配置
- **route**: 路由信息
- **tab**: 标签页管理
- **auth**: 认证信息
- **dict**: 字典管理
- **notice**: 通知管理

#### API交互

项目支持多种HTTP客户端实现：

- **Axios**:

```typescript
import { useRequest } from '@/hooks/common/request';

const { data, loading, error } = useRequest(() => api.getData(params));
```

- **Hooks使用**:

```typescript
// 布尔值管理
import { useBoolean } from '@sa/hooks';
const { bool, setTrue, setFalse } = useBoolean();

// 加载状态管理
import { useLoading } from '@sa/hooks';
const { loading, startLoading, endLoading } = useLoading();

// 表格管理
import { useTable } from '@/hooks/common/table';
const { tableData, loading, getPaginationData } = useTable(fetchTableData);
```

#### 组件使用

项目包含多种业务组件：

- **表格组件**：支持列设置、搜索区域和高级操作
- **表单组件**：集成验证和表单布局
- **字典组件**：字典选择、标签和单选
- **布局组件**：支持多种布局模式和主题

### UnoCSS使用指南

项目优先使用 UnoCSS 来实现样式：

```html
<div class="flex flex-col items-center justify-center p-4 m-2 bg-blue-100 dark:bg-blue-800 rounded-md">
  <span class="text-lg font-bold text-center">内容</span>
</div>
```

### 国际化

项目使用vue-i18n实现国际化支持：

```typescript
// 在组件中使用
import { useI18n } from 'vue-i18n';

const { t } = useI18n();
console.log(t('common.confirm'));
```

## 💎 特性与功能

### 前端特性

- **多种布局模式**：支持垂直、水平、混合等多种布局
- **可配置的主题**：明暗模式、主题色定制
- **标签页管理**：多种标签风格、右键菜单
- **组件封装**：进度条、图标、加载动画等
- **路由生成**：基于目录结构的路由生成
- **权限管理**：菜单和按钮级别的权限控制

### 业务功能

- **用户管理**：用户信息维护、角色分配
- **角色管理**：角色权限配置
- **菜单管理**：系统功能配置
- **部门管理**：组织架构维护
- **字典管理**：数据字典配置
- **租户管理**：多租户配置
- **系统监控**：登录日志、操作日志、在线用户、缓存监控
- **代码生成**：生成前后端代码，提升开发效率

## 🤝 贡献指南

### 开发流程

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'feat: add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 提交Pull Request

### 提交规范

项目使用约定式提交规范：

- `feat`: 新功能
- `fix`: 修复Bug
- `docs`: 文档更新
- `style`: 代码风格调整
- `refactor`: 代码重构
- `perf`: 性能优化
- `test`: 测试代码
- `chore`: 构建或工具变动

## 📄 许可证

[MIT License](./LICENSE)

## 🔗 相关链接

- [RuoYi-Vue-Plus](https://gitee.com/dromara/RuoYi-Vue-Plus) - 后端基础框架
- [Soybean Admin](https://github.com/soybeanjs/soybean-admin) - 前端基础框架
- [RuoYi-Plus-Soybean](https://ruoyi.xlsea.cn) - 官方演示站点
- [RuoYi-Plus-Soybean-Docs](https://docs.ruoyi.xlsea.cn) - 项目文档
- [Open Hives](https://openhives.com/questions) - OpenHives 问答社区

## 📮 联系方式

- **作者**: xlsea
- **邮箱**: m@xlsea.cn
- **作者主页**: https://gitee.com/xlsea

更多周边生态请翻阅 [周边生态](https://docs.soybeanjs.cn/zh/awesome) 文档。

- **作者**: Elio
- **邮箱**: 1983933789@qq.com
- **作者主页**: https://gitee.com/ahcode

## 💬 交流群

**加群前请先阅读一下内容：**

- 禁止内容：黄腔、暴力言论、政治话题，违者直接飞机票（踢出群）
- 遇到问题请先阅读 [项目文档](https://docs.ruoyi.xlsea.cn) 和 [Soybean 文档](https://docs.soybeanjs.cn/)，某些简单问题不予理睬

### 微信交流群

蜡笔小新头像为机器人助手，私聊不保证回复，问题请在群内讨论

<img src="https://foruda.gitee.com/images/1749174520085305975/ad1b54fe_5601833.png" width="300px" />

添加作者微信备注：加群

### QQ 交流群

<a href="https://qm.qq.com/q/jNMKfdCL8Q" target="_blank"><img src="https://img.shields.io/badge/%E7%82%B9%E5%87%BB%E5%8A%A0%E5%85%A5%20QQ%20%E4%BA%A4%E6%B5%81%E7%BE%A4-451067199-EB1923?logo=qq&logoColor=white" alt="license"></a>

<img src="https://foruda.gitee.com/images/1769569918127494786/c6e5b6af_5601833.jpg" width="300px" />

## 🧧 捐献作者

作者为兼职做开源，平时还需要工作，如果帮到了您可以请作者吃个盒饭

<img src="https://foruda.gitee.com/images/1746840166037207866/f8c6f06b_5601833.png" width="300px" height="300px" />

## 🫡 捐赠列表

**捐赠列表已移至 [捐赠列表](https://docs.ruoyi.xlsea.cn/other/donate.html)**
