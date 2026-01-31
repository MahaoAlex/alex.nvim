# Proposal for Alex's Neovim Configuration

这份文档旨在为 Alex 定制一套在 **阿里云 Ubuntu 22.04 远程桌面** 环境下，适配 **40% 键盘** 布局，并深度支持 **Python** 与 **Golang** 开发的 Neovim 配置方案。

---

## 1. 环境与目标 (Context & Goals)
*   **运行环境**: 阿里云远程桌面 (Ubuntu 22.04.5 LTS)。
*   **接入方式**: Windows 客户端远程接入。
*   **硬件适配**: 40% 布局键盘（按键精简，高度依赖层级）。
*   **开发语言**: Python, Golang。
*   **核心目标**: 极简按键、快速响应、全自动环境部署。

---

## 2. 核心修改项 (Key Modifications)

### 2.1 基础选项 (`options.lua`)
*   **缩进优化**: 统一设置 `tabstop`, `shiftwidth` 为 4，符合 Python 和 Go 的官方规范。
*   **剪贴板同步**: 强制开启 `unnamedplus`，配合远程桌面的 `xclip` 实现与本地 Windows 的无缝复制粘贴。
*   **UI 微调**: 针对远程桌面可能存在的渲染延迟，优化 `updatetime` (250ms) 和 `timeoutlen` (300ms)。

### 2.2 40% 键盘专属快捷键 (`keymaps.lua`)
针对 40% 键盘没有数字行和 F 区的特点，重新设计快捷键：
*   **Leader 键**: 设为 `Space` (空格)，所有核心操作的起点。
*   **窗口跳转**: 
    *   `Space + h/j/k/l`: 代替传统的 `Ctrl-w + h/j/k/l`，实现快速分屏跳转。
*   **文件管理**:
    *   `H` / `L`: 在已打开的 Buffer (文件) 之间快速左右切换（无需 Shift 层级以外的按键）。
    *   `Space + e`: 快速开关文件树 (Neo-tree)。
*   **命令输入**:
    *   `;`: 映射为 `:`，进入命令行模式不再需要按 Shift。
*   **快速退出**:
    *   `jk`: 在插入模式下快速回到普通模式。

### 2.3 调试快捷键收敛 (`debug.lua`)
针对 40% 键盘没有 F 区/不方便按功能键的问题，DAP 调试快捷键做了收敛与统一：
*   **统一前缀**: 使用 `Space + d` 作为调试入口（which-key 中显示为 `[D]ebug` 分组）。
*   **核心操作**:
    *   `Space + dc`: 开始/继续调试
    *   `Space + di`: Step Into
    *   `Space + do`: Step Over
    *   `Space + dO`: Step Out
    *   `Space + db`: 切换断点
    *   `Space + dB`: 条件断点
    *   `Space + du`: 开关调试 UI
*   **兼容保留**: `Space + b / Space + B` 仍可用于断点操作（推荐逐步迁移到 `Space + d...`）。

### 2.4 which-key 显示去歧义 (`init.lua`)
为避免歧义，which-key 对修饰键的显示做了小调整：
*   `D` 修饰键（Command/Super）不再显示成 `<D-…>`，改为更明确的 `<Command-…>`。

### 2.3 语言支持增强 (`lsp.lua`)
*   **Python**: 自动安装并配置 `pyright` (LSP), `black` (格式化), `ruff` (快速诊断)。
*   **Golang**: 自动安装并配置 `gopls` (LSP), `goimports` (自动导包), `gofumpt` (严格格式化)。
*   **自动安装**: 启动 Neovim 后，Mason 会自动下载所有缺失的二进制工具。

---

## 3. 主要功能预览 (Main Features)
*   **全自动插件管理**: 基于 `Lazy.nvim`，首次启动自动下载。
*   **智能补全**: 基于 `blink.cmp` 的极速补全体验。
*   **AI 辅助**: 内置 Claude / Gemini / OpenCode（Opencode）三套入口，统一以 `Space + c/g/o` 前缀触发。
*   **模糊搜索**: `Space + ff` (找文件), `Space + fw` (找文字)。
*   **代码诊断**: 实时显示 Python/Go 的语法错误，并支持 `Space + ca` 快速修复。
*   **状态栏**: 简洁美观，显示当前 Git 分支、LSP 状态及文件编码。

---

## 4. 部署流程 (Deployment Workflow)

### 第一阶段：代码提交 (AI 执行)
1.  修改 `options.lua`, `keymaps.lua`, `lsp.lua` 等核心文件。
2.  生成 `install-for-alex.sh` 自动化部署脚本。
3.  提交所有更改到 GitHub 仓库。

### 第二阶段：远程部署 (Alex 执行)
在阿里云 Ubuntu 终端执行以下命令：
```bash
# 1. 进入工作目录
cd ~/workspace (或您的代码目录)

# 2. 克隆或拉取最新代码
git clone https://github.com/your-repo/10-alex.nvim.git
cd 10-alex.nvim

# 3. 运行一键部署脚本
chmod +x install-for-alex.sh
./install-for-alex.sh
```

---

## 5. 自动化脚本 `install-for-alex.sh` 逻辑
1.  **系统依赖检测**: 检查并安装 `git`, `curl`, `unzip`, `gcc`, `nodejs`, `golang`, `xclip`。
2.  **清理冲突**: 自动备份并清理旧的 `~/.config/nvim` 和插件缓存。
3.  **配置映射**: 将仓库中的 `nvim` 目录链接到 `~/.config/nvim`。
4.  **预热**: 自动触发插件下载流程。

---

**Alex，请预览以上 Proposal。如果确认无误，请告知我，我将开始执行代码修改和脚本生成。**
