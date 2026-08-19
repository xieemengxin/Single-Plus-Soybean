# docs

本前端已随本仓库的 RuoYi-Vue-Plus 单体后端完成适配，旧版针对 RuoYi-Vue-Plus 的
`VelocityUtils.java` 替换文件与 `template/*.vm` 模板已移除。

## 代码生成模板

soybean 前端的代码生成模板已内置在后端代码生成器中，位于
`ruoyi-modules/ruoyi-gen/src/main/resources/fm/soybean/`（FreeMarker 格式），
无需任何替换操作。在代码生成页面把「前端模板类型」选择为 `soybean`
（即 `gen_table.frontend_type = 'soybean'`）即可生成本前端风格的
api / typings / views 代码。

## sql

菜单与字典数据适配 SQL，按数据库类型分为两套（内容同构，二选一执行）：

- 根目录为 **MySQL 版**：
  - `sys_menu.sql`：把 `script/sql/ry_vue.sql` 初始化后的菜单适配为 soybean
    前端所需的形态（i18n 菜单名、iconify 图标、FrameView iframe、停用无对应页面的菜单等）。
  - `sys_dict_data.sql`：字典标签 i18n key 化、`danger` 样式改 `error`。
- `postgres/` 子目录为 **PostgreSQL 版**：
  - `postgres/sys_menu.sql`、`postgres/sys_dict_data.sql`，内容与 MySQL 版逐条对应
    （方言差异：无反引号、`ON CONFLICT (menu_id) DO UPDATE` 替代 `ON DUPLICATE KEY UPDATE`、
    `now()` 替代 `sysdate()`；另因 postgres 种子中「AI会话」菜单 ID 与 MySQL 种子不同，
    停用语句的 menu_id 相应调整）。

执行前提：MySQL 先执行 `script/sql/ry_vue.sql`、PostgreSQL 先执行
`script/sql/postgres/postgres_ry_vue.sql` 完成初始化，再执行对应目录 SQL
（workflow 停用段对应可选的 `ry_workflow.sql` / `postgres_ry_workflow.sql`，
未执行时相关 UPDATE 命中 0 行，无副作用）；
执行后请清理字典 Redis 缓存或重启后端服务。
