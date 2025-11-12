/**
 * 生成唯一的转换ID
 * @param {string} url - 原始URL
 * @returns {string} 生成的唯一ID
 */
function generateConvertedId(url) {
    // 在 Cloudflare Workers 环境中，使用 SubtleCrypto API
    const encoder = new TextEncoder();
    const data = encoder.encode(url + Date.now());
    
    // 使用 SubtleCrypto 生成 SHA-256 哈希
    return crypto.subtle.digest('SHA-256', data)
        .then(hash => {
            const hashArray = Array.from(new Uint8Array(hash));
            const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
            return hashHex.substring(0, 12);
        });
}

export {
    generateConvertedId
};
