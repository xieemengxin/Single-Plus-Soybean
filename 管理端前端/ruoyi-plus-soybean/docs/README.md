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

菜单与字典数据适配 SQL：

- `sys_menu.sql`：把 `script/sql/ry-cloud.sql` 初始化后的菜单适配为 soybean
  前端所需的形态（i18n 菜单名、iconify 图标、FrameView iframe、停用无对应页面的菜单等）。
- `sys_dict_data.sql`：字典标签 i18n key 化、`danger` 样式改 `error`。

执行前提：先执行 `script/sql/ry_vue.sql` 完成初始化，再执行本目录 SQL；
执行后请清理字典 Redis 缓存或重启后端服务。
