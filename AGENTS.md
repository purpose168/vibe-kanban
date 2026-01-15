# 仓库指南

## 项目结构与模块组织
- `crates/`: Rust 工作区 crate — `server`（API + 可执行文件）、`db`（SQLx 模型/迁移）、`executors`、`services`、`utils`、`deployment`、`local-deployment`、`remote`。
- `frontend/`: React + TypeScript 应用（Vite、Tailwind）。源代码位于 `frontend/src`。
- `frontend/src/components/dialogs`: 前端的对话框组件。
- `remote-frontend/`: 远程部署前端。
- `shared/`: 生成的 TypeScript 类型（`shared/types.ts`）。请勿直接编辑。
- `assets/`, `dev_assets_seed/`, `dev_assets/`: 打包和本地开发资源。
- `npx-cli/`: 发布到 npm CLI 包的文件。
- `scripts/`: 开发助手（端口、数据库准备）。
- `docs/`: 文档文件。

## 管理 Rust 和 TypeScript 之间的共享类型

ts-rs 允许您从 Rust 结构体/枚举派生 TypeScript 类型。通过使用 #[derive(TS)] 和相关宏注释您的 Rust 类型，ts-rs 将为这些类型生成 .ts 声明文件。
修改类型时，您可以使用 `pnpm run generate-types` 重新生成它们
请勿手动编辑 shared/types.ts，而是编辑 crates/server/src/bin/generate_types.rs

## 构建、测试和开发命令
- 安装：`pnpm i`  # 安装依赖
- 运行开发环境（前端 + 后端，端口自动分配）：`pnpm run dev`
- 后端（监听模式）：`pnpm run backend:dev:watch`
- 前端（开发模式）：`pnpm run frontend:dev`
- 类型检查：`pnpm run check`（前端）和 `pnpm run backend:check`（Rust cargo check）
- Rust 测试：`cargo test --workspace`
- 从 Rust 生成 TS 类型：`pnpm run generate-types`（或 CI 中的 `generate-types:check`）
- 准备 SQLx（离线）：`pnpm run prepare-db`
- 准备 SQLx（远程包，postgres）：`pnpm run remote:prepare-db`
- 本地 NPX 构建：`pnpm run build:npx`，然后在 `npx-cli/` 中运行 `pnpm pack`

## 自动化 QA
- 通过运行应用程序测试更改时，您应该优先使用 `pnpm run dev:qa` 而不是 `pnpm run dev`，后者会以专门针对 QA 测试优化的模式启动应用程序

## 编码风格与命名约定
- Rust：强制使用 `rustfmt`（`rustfmt.toml`）；按 crate 分组导入；snake_case 模块，PascalCase 类型。
- TypeScript/React：ESLint + Prettier（2 个空格，单引号，80 列）。PascalCase 组件，camelCase 变量/函数，尽可能使用 kebab-case 文件名。
- 保持函数小而精，在有用的地方添加 `Debug`/`Serialize`/`Deserialize`。

## 测试指南
- Rust：倾向于在代码旁编写单元测试（`#[cfg(test)]`），运行 `cargo test --workspace`。为新逻辑和边缘情况添加测试。
- 前端：确保 `pnpm run check` 和 `pnpm run lint` 通过。如果添加运行时逻辑，请在同一目录中包含轻量级测试（例如 Vitest）。

## 安全与配置提示
- 使用 `.env` 进行本地覆盖；切勿提交机密信息。关键环境变量：`FRONTEND_PORT`、`BACKEND_PORT`、`HOST`
- 开发端口和资源由 `scripts/setup-dev-environment.js` 管理。
