-- ------------------------------------------------------------------------------------------
-- soybean 前端菜单适配脚本（RuoYi-Vue-Plus 单体版，PostgreSQL）
--
-- 用途：
--   将 script/sql/postgres/postgres_ry_vue.sql 初始化出来的 sys_menu 种子数据适配为
--   ruoyi-plus-soybean 前端可识别的形式（component 特殊值 Layout/ParentView/FrameView、
--   iconify 图标、i18n 菜单名、iframe 控制台、about 页面、停用前端没有对应页面的菜单）。
--
-- 执行前提：
--   1. 必须先执行 script/sql/postgres/postgres_ry_vue.sql 完成建库建表和种子数据初始化；
--   2. script/sql/postgres/postgres_ry_workflow.sql 为可选脚本，本文件末尾的工作流菜单停用语句
--      仅在其已执行时生效（未执行时 UPDATE 命中 0 行，无副作用）；
--   3. 本脚本中所有 UPDATE 的 menu_id 均对准 postgres_ry_vue.sql / postgres_ry_workflow.sql
--      中真实存在的行。
--
-- 幂等性：
--   所有 UPDATE 重复执行结果一致；所有 INSERT 均带 ON CONFLICT (menu_id) DO UPDATE，可重复执行。
--
-- 其他说明：
--   1. 单体后端对 M 型目录（component 为空）会自动输出 Layout（一级）/ ParentView（二级），
--      因此目录行无需显式设置 component；
--   2. 单体后端 is_frame 为字符 'Y'/'N'（与 Cloud 版一致）：
--      外链 = is_frame='Y' + path 为 http 地址 + component='FrameView'（前端识别 meta.link 新窗口打开）；
--      内嵌 iframe = is_frame='N' + path 为普通字符串 + component='FrameView'
--                    + query_param='{"url":"..."}'（前端 iframe-page 读取 url 渲染）；
--   3. 菜单名以 route. / menu. 开头时前端走 i18n，否则原样显示中文；
--   4. 单体特有处理（与 Cloud 版脚本的差异）：
--      - 登录日志：种子 path/component 为 logininfo（无 r），前端视图目录是 monitor/logininfor，需修正；
--      - Admin监控/任务调度中心/AI控制台：种子指向 plus-ui 的 iframe 包装页
--        （monitor/admin|snailjob|snailai/index），soybean 前端无这些组件，改为 FrameView 内嵌；
--      - AI会话（ai/chat/index）：soybean 前端无此页面，直接停用；
--   5. 与 MySQL 版脚本（docs/sql/sys_menu.sql）的差异：
--      postgres 种子中「AI会话」菜单的 menu_id 是 1761400000000000006（MySQL 种子为
--      1761400000000000008），故停用 AI会话 的语句使用 1761400000000000006。
-- ------------------------------------------------------------------------------------------

-- ----------------------------
-- 一、目录类型菜单（iconify 图标 + i18n 菜单名；component 留空由后端自动输出 Layout/ParentView）
-- ----------------------------
UPDATE sys_menu SET icon = 'carbon:cloud-service-management', menu_name = 'route.system' WHERE menu_id = 1761400000000000001;
UPDATE sys_menu SET icon = 'stash:dashboard', menu_name = 'route.monitor' WHERE menu_id = 1761400000000000002;
UPDATE sys_menu SET icon = 'tabler:tools', menu_name = 'route.tool' WHERE menu_id = 1761400000000000003;
UPDATE sys_menu SET icon = 'material-symbols:kid-star-outline', menu_name = 'route.demo' WHERE menu_id = 1761400000000000005;
UPDATE sys_menu SET icon = 'tabler:logs', menu_name = 'menu.system_log' WHERE menu_id = 1761400000000000108;

-- ----------------------------
-- 二、页面类型菜单（iconify 图标 + i18n 菜单名）
-- ----------------------------
UPDATE sys_menu SET icon = 'ic:round-manage-accounts', menu_name = 'route.system_user' WHERE menu_id = 1761400000000000100;
UPDATE sys_menu SET icon = 'carbon:user-role', menu_name = 'route.system_role' WHERE menu_id = 1761400000000000101;
UPDATE sys_menu SET icon = 'material-symbols:route', menu_name = 'route.system_menu' WHERE menu_id = 1761400000000000102;
UPDATE sys_menu SET icon = 'mingcute:department-line', menu_name = 'route.system_dept' WHERE menu_id = 1761400000000000103;
UPDATE sys_menu SET icon = 'hugeicons:permanent-job', menu_name = 'route.system_post' WHERE menu_id = 1761400000000000104;
UPDATE sys_menu SET icon = 'qlementine-icons:dictionary-16', menu_name = 'route.system_dict' WHERE menu_id = 1761400000000000105;
UPDATE sys_menu SET icon = 'carbon:parameter', menu_name = 'route.system_config' WHERE menu_id = 1761400000000000106;
UPDATE sys_menu SET icon = 'solar:chat-line-outline', menu_name = 'route.system_notice' WHERE menu_id = 1761400000000000107;
UPDATE sys_menu SET icon = 'majesticons:status-online-line', menu_name = 'route.monitor_online' WHERE menu_id = 1761400000000000109;
UPDATE sys_menu SET icon = 'simple-icons:redis', menu_name = 'route.monitor_cache' WHERE menu_id = 1761400000000000113;
UPDATE sys_menu SET icon = 'material-symbols:code-blocks-outline', menu_name = 'route.tool_gen' WHERE menu_id = 1761400000000000115;
UPDATE sys_menu SET icon = 'material-symbols:attach-file', menu_name = 'route.system_oss' WHERE menu_id = 1761400000000000118;
UPDATE sys_menu SET icon = 'tabler:device-imac-cog', menu_name = 'route.system_client' WHERE menu_id = 1761400000000000123;
UPDATE sys_menu SET icon = 'carbon:operations-record', menu_name = 'route.monitor_operlog' WHERE menu_id = 1761400000000000500;
-- 登录日志：postgres_ry_vue.sql 种子为 path='logininfo'、component='monitor/logininfo/index'（无 r），
-- 前端页面目录为 monitor/logininfor（带 r），必须同步修正 path 与 component，
-- 否则前端按 component 生成的路由名 monitor_logininfo 找不到对应视图；
-- perms 保持 monitor:logininfo:list 不动（后端注解与前端 hasAuth 均为 logininfo 拼写）
UPDATE sys_menu SET path = 'logininfor', component = 'monitor/logininfor/index', icon = 'tabler:login-2', menu_name = 'route.monitor_logininfor' WHERE menu_id = 1761400000000000501;
UPDATE sys_menu SET icon = 'gg:debug', menu_name = 'route.demo_demo' WHERE menu_id = 1761400000000001500;
UPDATE sys_menu SET icon = 'gg:debug', menu_name = 'route.demo_tree' WHERE menu_id = 1761400000000001506;
-- 文件配置管理：种子为 path='oss-config/index'、component='system/oss/config'，前端页面目录是
-- system/oss-config，改指向该页面（路由名 system_oss-config，oss 页面通过
-- routerPushByKey('system_oss-config') 跳转）；active_menu 写 '/system_oss' 供前端菜单高亮
UPDATE sys_menu SET path = 'oss/config', component = 'system/oss-config/index', icon = 'hugeicons:configuration-01', menu_name = 'route.system_oss-config', active_menu = '/system_oss' WHERE menu_id = 1761400000000000133;

-- ----------------------------
-- 三、新增 about 关于页面（前端 views/about/index.vue，i18n key: route.about；
--     menu_id 1761400000000000009 已核实在 postgres_ry_vue.sql 等种子中空闲）
-- ----------------------------
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query_param, is_frame, is_cache, menu_type, visible, status, perms, icon, active_menu, ext, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (1761400000000000009, 'route.about', 0, 99, 'about', 'about/index', '', 'N', 'Y', 'C', '0', '0', '', 'fluent:book-information-24-regular', '', '', 1761000000000000103, 1761100000000000001, now(), null, null, '关于页面')
ON CONFLICT (menu_id) DO UPDATE SET update_time = now();

-- ----------------------------
-- 四、iframe 内嵌控制台（component='FrameView' + query_param 存放 url，path 改为普通字符串、is_frame 保持 'N'）
--     种子中这三个菜单的 component 指向 plus-ui 的 iframe 包装页
--     （monitor/admin/index、monitor/snailjob/index、monitor/snailai/index），soybean 前端没有
--     这些组件，统一改为 FrameView 直接内嵌；perms 保持种子原样不动。
--     url 与本仓库部署一致：Spring Boot Admin 9090(/admin，见 ruoyi-admin application-*.yml
--     spring.boot.admin.client.url)、snail-job 8800(/snail-job)、snail-ai 8900(/snail-ai)
-- ----------------------------
UPDATE sys_menu SET path = 'admin', component = 'FrameView', query_param = '{"url":"http://localhost:9090/admin"}', is_frame = 'N', icon = 'bx:bxl-spring-boot', menu_name = 'menu.monitor_admin' WHERE menu_id = 1761400000000000117;
UPDATE sys_menu SET path = 'snailJob', component = 'FrameView', query_param = '{"url":"http://localhost:8800/snail-job"}', is_frame = 'N', icon = 'gridicons:scheduled', menu_name = 'menu.monitor_snail-job' WHERE menu_id = 1761400000000000120;
-- AI 控制台前端语言包无对应 i18n key，菜单名保持中文原样显示
UPDATE sys_menu SET path = 'snailAi', component = 'FrameView', query_param = '{"url":"http://localhost:8900/snail-ai"}', is_frame = 'N', icon = 'mdi:robot', menu_name = 'AI控制台' WHERE menu_id = 1761400000000000121;

-- ----------------------------
-- 五、外链类型（is_frame='Y' + http 路径 + component='FrameView'，前端识别 meta.link 后新窗口打开）
-- ----------------------------
UPDATE sys_menu SET menu_name = 'RuoYi-Vue-Plus', order_num = 100, component = 'FrameView', icon = 'local-icon-gitee', remark = 'RuoYi-Vue-Plus 仓库地址' WHERE menu_id = 1761400000000000004;
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query_param, is_frame, is_cache, menu_type, visible, status, perms, icon, active_menu, ext, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (1761400000000000007, 'Soybean Admin', 0, 100, 'https://github.com/soybeanjs', 'FrameView', '', 'Y', 'Y', 'M', '0', '0', '', 'mdi:github', '', '', 1761000000000000103, 1761100000000000001, now(), null, null, 'Soybean Admin 仓库地址')
ON CONFLICT (menu_id) DO UPDATE SET update_time = now();
-- 注：Cloud 版脚本此行用的是 1761400000000000008；postgres 单体种子中该 ID 虽然空闲
--     （「AI会话」在 postgres 种子占用的是 1761400000000000006），但为与 MySQL 版脚本
--     （docs/sql/sys_menu.sql）保持一致，仍使用两个种子中均已核实空闲的 1761400000000000010
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, query_param, is_frame, is_cache, menu_type, visible, status, perms, icon, active_menu, ext, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (1761400000000000010, 'RuoYi-Plus-Soybean', 0, 100, 'https://gitee.com/xlsea/ruoyi-plus-soybean', 'FrameView', '', 'Y', 'Y', 'M', '0', '0', '', 'local-icon-gitee', '', '', 1761000000000000103, 1761100000000000001, now(), null, null, 'RuoYi-Plus-Soybean 仓库地址')
ON CONFLICT (menu_id) DO UPDATE SET update_time = now();

-- ----------------------------
-- 六、停用 soybean 前端没有对应页面的菜单
-- ----------------------------
-- 说明：前端 hasAuth 使用的按钮权限串已与 postgres_ry_vue.sql 种子的 F 型按钮行逐一核对一致
-- （monitor:logininfo:*、system:oss:download/remove、system:ossConfig:add/edit/remove、
--   tool:gen:code/edit/preview/remove、demo:demo:*、demo:tree:* 等），无需额外新增按钮。
-- AI会话（component='ai/chat/index'）：soybean 前端无此页面
-- 注意：postgres 种子中「AI会话」的 menu_id 是 1761400000000000006（MySQL 种子为 1761400000000000008）
UPDATE sys_menu SET status = '1' WHERE menu_id = 1761400000000000006;
-- plus-ui 独有的独立编辑页（soybean 用抽屉/弹窗实现）：
--   修改生成配置 tool/gen/editTable、分配用户 system/role/authUser、分配角色 system/user/authRole
UPDATE sys_menu SET status = '1' WHERE menu_id IN (1761400000000000116, 1761400000000000130, 1761400000000000131);
-- 工作流（warm-flow）全部目录/页面：soybean 前端没有 workflow 相关视图。
-- 这些行来自可选脚本 script/sql/postgres/postgres_ry_workflow.sql，未执行该脚本时以下 UPDATE 命中 0 行，无副作用
--   （挂在其下的 F 型按钮行不产生路由，无需停用；父级停用后子页面不会出现在路由中）
UPDATE sys_menu SET status = '1' WHERE menu_id IN (
    1761400000000011616, -- 工作流(目录)
    1761400000000011618, -- 我的任务(目录)
    1761400000000011619, -- 我的待办
    1761400000000011632, -- 我的已办
    1761400000000011633, -- 我的抄送
    1761400000000011620, -- 流程定义
    1761400000000011621, -- 流程实例
    1761400000000011622, -- 流程分类
    1761400000000011801, -- 流程表达式
    1761400000000011629, -- 我发起的
    1761400000000011630, -- 流程监控(目录)
    1761400000000011631, -- 待办任务
    1761400000000011700, -- 流程设计(隐藏页)
    1761400000000011701  -- 请假申请-编辑(隐藏页)
);
-- 测试菜单下的请假申请（workflow/leave/index，soybean 前端无此视图，同样来自 postgres_ry_workflow.sql）
UPDATE sys_menu SET status = '1' WHERE menu_id = 1761400000000011638;
