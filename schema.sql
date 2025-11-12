-- Cloudflare D1 数据库 Schema
CREATE TABLE IF NOT EXISTS codelabs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    original_url TEXT UNIQUE NOT NULL,
    converted_id TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    accessed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_original_url ON codelabs(original_url);
CREATE INDEX IF NOT EXISTS idx_converted_id ON codelabs(converted_id);
CREATE INDEX IF NOT EXISTS idx_created_at ON codelabs(created_at DESC);
