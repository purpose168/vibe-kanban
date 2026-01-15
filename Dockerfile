# Vibe Kanban Dockerfile
# 多阶段构建配置：构建阶段和运行时阶段

# ==========================================
# 构建阶段 (Builder Stage)
# 用于构建前端和后端应用程序
FROM node:24-alpine AS builder

# 安装构建依赖项
RUN apk add --no-cache \
    curl \
    build-base \
    perl \
    llvm-dev \
    clang-dev

# 配置 Rust 编译参数，允许在 musl 上链接 libclang
ENV RUSTFLAGS="-C target-feature=-crt-static"

# 安装 Rust 开发环境
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"  

# PostHog 分析服务的构建参数
ARG POSTHOG_API_KEY
ARG POSTHOG_API_ENDPOINT

# 设置前端使用的环境变量
ENV VITE_PUBLIC_POSTHOG_KEY=$POSTHOG_API_KEY
ENV VITE_PUBLIC_POSTHOG_HOST=$POSTHOG_API_ENDPOINT

# 设置工作目录
WORKDIR /app

# 复制包文件用于依赖缓存
COPY package*.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY frontend/package*.json ./frontend/
COPY npx-cli/package*.json ./npx-cli/

# 安装 pnpm 包管理器和项目依赖
RUN npm install -g pnpm && pnpm install

# 复制所有源代码
COPY . .

# 构建应用程序
RUN npm run generate-types  # 生成 TypeScript 类型定义
RUN cd frontend && pnpm run build  # 构建前端应用
RUN cargo build --release --bin server  # 构建 Rust 后端服务器

# ==========================================
# 运行时阶段 (Runtime Stage)
# 用于生产环境运行，包含最小化的运行时依赖
FROM alpine:latest AS runtime

# 安装运行时依赖项
RUN apk add --no-cache \
    ca-certificates \
    tini \
    libgcc \
    wget

# 创建应用用户以提高安全性（不使用 root）
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# 从构建阶段复制编译好的二进制文件
COPY --from=builder /app/target/release/server /usr/local/bin/server

# 创建仓库目录并设置权限
RUN mkdir -p /repos && \
    chown -R appuser:appgroup /repos

# 切换到非 root 用户
USER appuser

# 设置运行时环境变量
ENV HOST=0.0.0.0  
ENV PORT=3000     
EXPOSE 3000       

# 设置工作目录
WORKDIR /repos

# 配置健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider "http://${HOST:-localhost}:${PORT:-3000}" || exit 1

# 设置入口点和命令
ENTRYPOINT ["/sbin/tini", "--"]  # 使用 tini 处理信号和僵尸进程
CMD ["server"]  # 启动服务器应用
