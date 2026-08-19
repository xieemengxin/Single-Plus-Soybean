-- ------------------------------------------------------------------------------------------
-- soybean 前端字典适配脚本（RuoYi-Vue-Plus 单体版）
--
-- 用途：
--   将 script/sql/ry_vue.sql 初始化出来的 sys_dict_type / sys_dict_data 种子数据
--   适配为 ruoyi-plus-soybean 前端可识别的形式：
--   1. list_class 的 danger 改为 error（naive-ui 的标签类型没有 danger）；
--   2. dict_label 改为 i18n key（形如 dict.{dict_type}.{key}；前端 dict store 仅在
--      dict_label 以 "dict.{该行 dict_type}." 开头时才走 $t 翻译，否则原样显示）。
--   字典类型保持 ry_vue.sql 原样（含 sys_user_gender），前端页面与语言包
--   已按 sys_user_gender 适配，后端 @ExcelDictFormat(dictType = "sys_user_gender") 不受影响。
--
-- 执行前提：
--   1. 必须先执行 script/sql/ry_vue.sql 完成建库建表和种子数据初始化；
--   2. wf_* 三组字典（业务状态/表单类型/任务状态）来自可选脚本 script/sql/ry_workflow.sql，
--      未执行该脚本时对应 UPDATE 命中 0 行，无副作用；
--   3. 本脚本中所有 WHERE 的 dict_code 均对准 ry_vue.sql / ry_workflow.sql 中真实存在的行；
--   4. 后端字典存在 Redis 缓存，建议在服务启动前执行本脚本；若服务已启动，
--      执行后需清理 Redis 中的字典缓存（或重启后端应用）。
--
-- 幂等性：
--   全部为 UPDATE 且目标值固定，可重复执行。
--   注意 danger→error 语句需保留在最前（在 label 改写前后执行结果一致，但保持此顺序最直观）。
-- ------------------------------------------------------------------------------------------

-- 修改字典数据表的 list_class 字段，将 danger 改为 error
UPDATE `sys_dict_data` SET `list_class` = 'error' WHERE `list_class` = 'danger';

-- 字典适配多语言（i18n key 均已存在于前端语言包 zh-cn.ts / en-us.ts 的 dict 段）
-- 用户性别 sys_user_gender
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_user_gender.male' WHERE `dict_code` = 1761600000000000001;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_user_gender.female' WHERE `dict_code` = 1761600000000000002;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_user_gender.unknown' WHERE `dict_code` = 1761600000000000003;
-- 菜单状态 sys_show_hide
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_show_hide.show' WHERE `dict_code` = 1761600000000000004;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_show_hide.hide' WHERE `dict_code` = 1761600000000000005;
-- 系统开关 sys_normal_disable
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_normal_disable.normal' WHERE `dict_code` = 1761600000000000006;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_normal_disable.disable' WHERE `dict_code` = 1761600000000000007;
-- 系统是否 sys_yes_no
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_yes_no.yes' WHERE `dict_code` = 1761600000000000012;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_yes_no.no' WHERE `dict_code` = 1761600000000000013;
-- 通知类型 sys_notice_type
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_notice_type.notice' WHERE `dict_code` = 1761600000000000014;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_notice_type.announcement' WHERE `dict_code` = 1761600000000000015;
-- 通知状态 sys_notice_status
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_notice_status.normal' WHERE `dict_code` = 1761600000000000016;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_notice_status.close' WHERE `dict_code` = 1761600000000000017;
-- 操作类型 sys_oper_type
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.insert' WHERE `dict_code` = 1761600000000000018;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.update' WHERE `dict_code` = 1761600000000000019;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.delete' WHERE `dict_code` = 1761600000000000020;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.grant' WHERE `dict_code` = 1761600000000000021;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.export' WHERE `dict_code` = 1761600000000000022;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.import' WHERE `dict_code` = 1761600000000000023;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.force' WHERE `dict_code` = 1761600000000000024;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.gencode' WHERE `dict_code` = 1761600000000000025;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.clean' WHERE `dict_code` = 1761600000000000026;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_oper_type.other' WHERE `dict_code` = 1761600000000000029;
-- 系统状态 sys_common_status
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_common_status.success' WHERE `dict_code` = 1761600000000000027;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_common_status.fail' WHERE `dict_code` = 1761600000000000028;
-- 授权类型 sys_grant_type
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_grant_type.password' WHERE `dict_code` = 1761600000000000030;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_grant_type.sms' WHERE `dict_code` = 1761600000000000031;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_grant_type.email' WHERE `dict_code` = 1761600000000000032;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_grant_type.miniapp' WHERE `dict_code` = 1761600000000000033;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_grant_type.social' WHERE `dict_code` = 1761600000000000034;
-- 设备类型 sys_device_type
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_device_type.pc' WHERE `dict_code` = 1761600000000000035;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_device_type.android' WHERE `dict_code` = 1761600000000000036;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_device_type.ios' WHERE `dict_code` = 1761600000000000037;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.sys_device_type.miniapp' WHERE `dict_code` = 1761600000000000038;
-- 以下 wf_* 字典来自可选脚本 ry_workflow.sql（workflow 菜单虽已停用，字典 i18n 化无副作用，保留适配）
-- 业务状态 wf_business_status
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_business_status.revoked' WHERE `dict_code` = 1761600000000000039;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_business_status.draft' WHERE `dict_code` = 1761600000000000040;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_business_status.pending' WHERE `dict_code` = 1761600000000000041;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_business_status.completed' WHERE `dict_code` = 1761600000000000042;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_business_status.cancelled' WHERE `dict_code` = 1761600000000000043;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_business_status.returned' WHERE `dict_code` = 1761600000000000044;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_business_status.terminated' WHERE `dict_code` = 1761600000000000045;
-- 表单类型 wf_form_type
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_form_type.custom_form' WHERE `dict_code` = 1761600000000000046;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_form_type.dynamic_form' WHERE `dict_code` = 1761600000000000047;
-- 任务状态 wf_task_status
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.revoke' WHERE `dict_code` = 1761600000000000048;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.pass' WHERE `dict_code` = 1761600000000000049;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.pending_review' WHERE `dict_code` = 1761600000000000050;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.cancel' WHERE `dict_code` = 1761600000000000051;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.return' WHERE `dict_code` = 1761600000000000052;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.terminate' WHERE `dict_code` = 1761600000000000053;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.transfer' WHERE `dict_code` = 1761600000000000054;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.delegate' WHERE `dict_code` = 1761600000000000055;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.copy' WHERE `dict_code` = 1761600000000000056;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.add_sign' WHERE `dict_code` = 1761600000000000057;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.minus_sign' WHERE `dict_code` = 1761600000000000058;
UPDATE `sys_dict_data` SET `dict_label` = 'dict.wf_task_status.timeout' WHERE `dict_code` = 1761600000000000059;
