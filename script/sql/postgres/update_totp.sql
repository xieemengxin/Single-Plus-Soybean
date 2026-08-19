-- ------------------------------------------------------------------------------------------
-- TOTP 两步验证升级脚本（PostgreSQL）
--
-- 用途：为存量数据库增加 TOTP 动态口令密钥字段。
--       新初始化的库无需执行本脚本（postgres_ry_vue.sql 建表语句已包含该字段）。
-- 说明：两步验证的开关与签发者等配置见 ruoyi-admin/src/main/resources/application.yml 的 security.totp。
-- ------------------------------------------------------------------------------------------

ALTER TABLE sys_user ADD COLUMN totp_secret varchar(64);
COMMENT ON COLUMN sys_user.totp_secret IS 'TOTP动态口令密钥（Base32编码 null未绑定）';
