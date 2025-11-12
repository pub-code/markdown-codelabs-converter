/**
 * Cloudflare D1 数据库操作类
 */
class Database {
    constructor(d1Database) {
        this.db = d1Database;
    }

    /**
     * 存储转换结果到数据库
     */
    async storeToDatabase(originalUrl, convertedId, title, content) {
        try {
            await this.db
                .prepare(
                    `INSERT OR REPLACE INTO codelabs (original_url, converted_id, title, content, accessed_at)
                    VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)`
                )
                .bind(originalUrl, convertedId, title, content)
                .run();

            return { success: true };
        } catch (error) {
            console.error('存储到数据库失败:', error);
            throw error;
        }
    }

    /**
     * 根据原始URL获取缓存
     */
    async getFromDatabase(originalUrl) {
        try {
            const result = await this.db
                .prepare(`SELECT * FROM codelabs WHERE original_url = ?`)
                .bind(originalUrl)
                .first();

            return result;
        } catch (error) {
            console.error('从数据库获取失败:', error);
            throw error;
        }
    }

    /**
     * 根据转换ID获取内容
     */
    async getByConvertedId(convertedId) {
        try {
            const result = await this.db
                .prepare(`SELECT * FROM codelabs WHERE converted_id = ?`)
                .bind(convertedId)
                .first();

            if (result) {
                // 更新访问时间
                await this.db
                    .prepare(`UPDATE codelabs SET accessed_at = CURRENT_TIMESTAMP WHERE converted_id = ?`)
                    .bind(convertedId)
                    .run();
            }

            return result;
        } catch (error) {
            console.error('获取转换内容失败:', error);
            throw error;
        }
    }

    /**
     * 获取所有记录
     */
    async getAllRecords(limit = 50) {
        try {
            const { results } = await this.db
                .prepare(`SELECT * FROM codelabs ORDER BY created_at DESC LIMIT ?`)
                .bind(limit)
                .all();

            return results || [];
        } catch (error) {
            console.error('获取所有记录失败:', error);
            throw error;
        }
    }
}

export default Database;
