# 远程服务

`remote` crate 包含 Vibe Kanban 托管 API 的实现。

## 先决条件

在仓库根目录创建一个 `.env.remote` 文件：

```env
VIBEKANBAN_REMOTE_JWT_SECRET=your_base64_encoded_secret         # JWT 密钥，使用 base64 编码
SERVER_PUBLIC_BASE_URL=http://localhost:3000                    # 服务器公共基础 URL
GITHUB_OAUTH_CLIENT_ID=your_github_web_app_client_id            # GitHub OAuth 客户端 ID
GITHUB_OAUTH_CLIENT_SECRET=your_github_web_app_client_secret    # GitHub OAuth 客户端密钥
GOOGLE_OAUTH_CLIENT_ID=your_google_web_app_client_id            # Google OAuth 客户端 ID
GOOGLE_OAUTH_CLIENT_SECRET=your_google_web_app_client_secret    # Google OAuth 客户端密钥
```

使用 `openssl rand -base64 48` 生成一次 `VIBEKANBAN_REMOTE_JWT_SECRET`，并将值复制到 `.env.remote` 中。

必须配置至少一个 OAuth 提供商（GitHub 或 Google）。

## 在本地运行堆栈

```bash
docker compose --env-file .env.remote -f docker-compose.yml up --build  # 使用 Docker Compose 启动服务
```
API 将在 `http://localhost:8081` 上暴露。Postgres 服务可通过 `postgres://remote:remote@localhost:5432/remote` 访问。

## 运行 Vibe Kanban

```bash
export VK_SHARED_API_BASE=http://localhost:8081  # 设置 API 基础 URL 环境变量

pnpm run dev  # 运行 Vibe Kanban 开发环境
```
