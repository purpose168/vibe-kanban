#!/bin/bash

set -e  # 任何错误发生时退出脚本

# 检测操作系统和架构
OS=$(uname -s | tr '[:upper:]' '[:lower:]')  # 获取操作系统名称并转换为小写
ARCH=$(uname -m)  # 获取系统架构

# 映射架构名称到标准化格式
case "$ARCH" in
  x86_64)
    ARCH="x64"  # 将 x86_64 映射为 x64
    ;;
  arm64|aarch64)
    ARCH="arm64"  # 将 arm64 或 aarch64 映射为 arm64
    ;;
  *)
    echo "⚠️  警告：未知架构 $ARCH，将直接使用"
    ;;
esac

# 映射操作系统名称到标准化格式
case "$OS" in
  linux)
    OS="linux"  # Linux 保持不变
    ;;
  darwin)
    OS="macos"  # 将 macOS 的 darwin 映射为 macos
    ;;
  *)
    echo "⚠️  警告：未知操作系统 $OS，将直接使用"
    ;;
esac

PLATFORM="${OS}-${ARCH}"  # 构建平台标识符（如 linux-x64 或 macos-arm64）

# 如果未定义 CARGO_TARGET_DIR，则设置默认值
if [ -z "$CARGO_TARGET_DIR" ]; then
  CARGO_TARGET_DIR="target"  # 默认目标目录为 target
fi

echo "🔍 检测到平台: $PLATFORM"
echo "🔧 使用目标目录: $CARGO_TARGET_DIR"
echo "🧹 清理之前的构建..."
rm -rf npx-cli/dist  # 删除旧的发布目录
mkdir -p npx-cli/dist/$PLATFORM  # 创建新的平台特定目录

echo "🔨 构建前端..."
(cd frontend && npm run build)  # 进入 frontend 目录并构建前端

echo "🔨 构建 Rust 二进制文件..."
cargo build --release --manifest-path Cargo.toml  # 构建主二进制文件
cargo build --release --bin mcp_task_server --manifest-path Cargo.toml  # 构建 MCP 任务服务器

echo "📦 创建发布包..."

# 复制主二进制文件
cp ${CARGO_TARGET_DIR}/release/server vibe-kanban  # 复制 server 二进制文件
zip -q vibe-kanban.zip vibe-kanban  # 创建 ZIP 包
rm -f vibe-kanban  # 删除临时文件
mv vibe-kanban.zip npx-cli/dist/$PLATFORM/vibe-kanban.zip  # 移动到发布目录

# 复制 MCP 二进制文件
cp ${CARGO_TARGET_DIR}/release/mcp_task_server vibe-kanban-mcp  # 复制 mcp_task_server 二进制文件
zip -q vibe-kanban-mcp.zip vibe-kanban-mcp  # 创建 ZIP 包
rm -f vibe-kanban-mcp  # 删除临时文件
mv vibe-kanban-mcp.zip npx-cli/dist/$PLATFORM/vibe-kanban-mcp.zip  # 移动到发布目录

# 复制 Review CLI 二进制文件
cp ${CARGO_TARGET_DIR}/release/review vibe-kanban-review  # 复制 review 二进制文件
zip -q vibe-kanban-review.zip vibe-kanban-review  # 创建 ZIP 包
rm -f vibe-kanban-review  # 删除临时文件
mv vibe-kanban-review.zip npx-cli/dist/$PLATFORM/vibe-kanban-review.zip  # 移动到发布目录

echo "✅ 构建完成!"
echo "📁 创建的文件:"
echo "   - npx-cli/dist/$PLATFORM/vibe-kanban.zip"  # 主应用程序二进制包
echo "   - npx-cli/dist/$PLATFORM/vibe-kanban-mcp.zip"  # MCP 任务服务器二进制包
echo "   - npx-cli/dist/$PLATFORM/vibe-kanban-review.zip"  # 代码审查工具二进制包
echo ""
echo "🚀 本地测试运行:"
echo "   cd npx-cli && node bin/cli.js"  # 进入 npx-cli 目录并运行 CLI
