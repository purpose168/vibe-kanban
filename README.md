<p align="center">
  <a href="https://vibekanban.com">
    <picture>
      <source srcset="frontend/public/vibe-kanban-logo-dark.svg" media="(prefers-color-scheme: dark)">
      <source srcset="frontend/public/vibe-kanban-logo.svg" media="(prefers-color-scheme: light)">
      <img src="frontend/public/vibe-kanban-logo.svg" alt="Vibe Kanban Logo">
    </picture>
  </a>
</p>

<p align="center">让 Claude Code、Gemini CLI、Codex、Amp 等编码代理的效率提升 10 倍...</p>
<p align="center">
  <a href="https://www.npmjs.com/package/vibe-kanban"><img alt="npm" src="https://img.shields.io/npm/v/vibe-kanban?style=flat-square" /></a>
  <a href="https://github.com/BloopAI/vibe-kanban/blob/main/.github/workflows/publish.yml"><img alt="构建状态" src="https://img.shields.io/github/actions/workflow/status/BloopAI/vibe-kanban/.github%2Fworkflows%2Fpublish.yml" /></a>
  <a href="https://deepwiki.com/BloopAI/vibe-kanban"><img src="https://deepwiki.com/badge.svg" alt="询问 DeepWiki"></a>
</p>

<h1 align="center">
  <a href="https://jobs.polymer.co/vibe-kanban?source=github"><strong>我们正在招聘！</strong></a>
</h1>

![](frontend/public/vibe-kanban-screenshot-overview.png)

## 概述

AI 编码代理（coding agents）正在越来越多地编写世界上的代码，而人类工程师现在将大部分时间花在规划、审查和编排任务上。Vibe Kanban 简化了这一过程，使您能够：

- 轻松在不同的编码代理之间切换
- 并行或按顺序编排多个编码代理的执行
- 快速审查工作并启动开发服务器
- 跟踪您的编码代理正在处理的任务状态
- 集中配置编码代理的 MCP 配置
- 在远程服务器上运行 Vibe Kanban 时通过 SSH 远程打开项目

您可以[在此处](https://youtu.be/TFT3KnZOOAk)观看视频概述。

## 安装

确保您已使用您喜爱的编码代理进行身份验证。支持的编码代理完整列表可在[文档](https://vibekanban.com/docs)中找到。然后在您的终端中运行：

```bash
npx vibe-kanban  # 使用 npx 运行 Vibe Kanban
```

## 文档

请访问[官方网站](https://vibekanban.com/docs)获取最新文档和用户指南。

## 支持

我们使用 [GitHub Discussions](https://github.com/BloopAI/vibe-kanban/discussions) 来处理功能请求。请开启讨论来提出功能请求。对于错误，请在此仓库上开启一个 issue。

## 贡献

我们希望首先通过 [GitHub Discussions](https://github.com/BloopAI/vibe-kanban/discussions) 或 [Discord](https://discord.gg/AC4nwVtJM3) 与核心团队讨论想法和变更，以便我们可以讨论实现细节和与现有路线图的一致性。请不要在未与团队讨论您的提案的情况下直接开启 PR。

## 开发

### 先决条件

- [Rust](https://rustup.rs/)（最新稳定版）
- [Node.js](https://nodejs.org/) (>=18)
- [pnpm](https://pnpm.io/) (>=8)

额外的开发工具：
```bash
cargo install cargo-watch  # 安装 cargo-watch 用于监控 Rust 代码变化
cargo install sqlx-cli      # 安装 sqlx-cli 用于数据库操作
```

安装依赖：
```bash
pnpm i  # 使用 pnpm 安装所有依赖
```

### 运行开发服务器

```bash
pnpm run dev  # 启动开发服务器
```

这将启动后端。一个空的数据库将从 `dev_assets_seed` 文件夹复制过来。

### 构建前端

要仅构建前端：

```bash
cd frontend    # 进入前端目录
pnpm build     # 构建前端
```

### 从源代码构建（macOS）

1. 运行 `./local-build.sh`  # 执行本地构建脚本
2. 使用 `cd npx-cli && node bin/cli.js` 进行测试  # 进入 npx-cli 目录并运行 CLI

### 环境变量

以下环境变量可以在构建时或运行时配置：

| 变量 | 类型 | 默认值 | 描述 |
|------|------|-------|------|
| `POSTHOG_API_KEY` | 构建时 | 空 | PostHog 分析 API 密钥（为空时禁用分析） |
| `POSTHOG_API_ENDPOINT` | 构建时 | 空 | PostHog 分析端点（为空时禁用分析） |
| `PORT` | 运行时 | 自动分配 | **生产环境**：服务器端口。**开发环境**：前端端口（后端使用 PORT+1） |
| `BACKEND_PORT` | 运行时 | `0`（自动分配） | 后端服务器端口（仅开发模式，覆盖 PORT+1） |
| `FRONTEND_PORT` | 运行时 | `3000` | 前端开发服务器端口（仅开发模式，覆盖 PORT） |
| `HOST` | 运行时 | `127.0.0.1` | 后端服务器主机 |
| `DISABLE_WORKTREE_ORPHAN_CLEANUP` | 运行时 | 未设置 | 禁用 git worktree 清理（用于调试） |

**构建时变量**必须在运行 `pnpm run build` 时设置。**运行时变量**在应用程序启动时读取。

### 远程部署

当在远程服务器上运行 Vibe Kanban 时（例如，通过 systemctl、Docker 或云托管），您可以配置编辑器通过 SSH 打开项目：

1. **通过隧道访问**：使用 Cloudflare Tunnel、ngrok 或类似工具暴露 Web UI
2. **配置远程 SSH** 在设置 → 编辑器集成中：
   - 将 **Remote SSH Host** 设置为您的服务器主机名或 IP
   - 将 **Remote SSH User** 设置为您的 SSH 用户名（可选）
3. **先决条件**：
   - 从您的本地机器到远程服务器的 SSH 访问权限
   - 已配置 SSH 密钥（无密码认证）
   - VSCode Remote-SSH 扩展

配置完成后，"Open in VSCode" 按钮将生成类似 `vscode://vscode-remote/ssh-remote+user@host/path` 的 URL，用于打开您的本地编辑器并连接到远程服务器。

有关详细的设置说明，请参阅[文档](https://vibekanban.com/docs/configuration-customisation/global-settings#remote-ssh-configuration)。
