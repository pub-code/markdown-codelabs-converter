-- Cloudflare D1 数据库清空脚本
-- 用于清空 codelabs 表的所有数据
-- 执行命令: wrangler d1 execute codelabs-db --remote --file=clear.sql

-- =============================================
-- 安全警告：此操作不可逆，请谨慎执行！
-- =============================================

-- 第一步：备份当前数据统计（可选，用于记录）
-- 记录清空前的数据量
SELECT COUNT(*) as total_records_before FROM codelabs;

-- 第二步：显示即将删除的数据摘要
SELECT 
    COUNT(*) as records_to_delete,
    MIN(created_at) as oldest_record,
    MAX(created_at) as newest_record
FROM codelabs;

-- 第三步：显示即将删除的标题列表（前10条）
SELECT 
    title,
    converted_id,
    created_at
FROM codelabs 
ORDER BY created_at DESC 
LIMIT 10;

-- =============================================
-- 清空操作开始
-- =============================================

-- 第四步：禁用外键约束（如果存在）
PRAGMA foreign_keys = OFF;

-- 第五步：清空 codelabs 表的所有数据
DELETE FROM codelabs;

-- 第六步：重置自增 ID 计数器
-- 注意：SQLite 使用 sqlite_sequence 表管理自增ID
DELETE FROM sqlite_sequence WHERE name='codelabs';

-- 第七步：重新启用外键约束
PRAGMA foreign_keys = ON;

-- =============================================
-- 验证操作结果
-- =============================================

-- 第八步：验证表是否已清空
SELECT COUNT(*) as total_records_after FROM codelabs;

-- 第九步：检查自增ID是否重置
SELECT * FROM sqlite_sequence WHERE name='codelabs';

-- 第十步：显示表结构（确认表仍然存在）
.schema codelabs

-- =============================================
-- 操作完成确认
-- =============================================

-- 如果 total_records_after 为 0，则清空成功
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM codelabs) = 0 
        THEN '✅ 数据库清空成功！所有记录已删除。'
        ELSE '❌ 数据库清空失败！仍有记录存在。'
    END as operation_status;

-- 显示当前数据库状态
SELECT 
    '当前时间: ' || datetime('now') as current_time,
    '数据库: codelabs-db' as database_name,
    '操作: 完全清空' as operation_type;
