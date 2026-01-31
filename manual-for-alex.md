# Manual for Alex's Neovim Configuration

这份手册总结了您当前 Neovim 配置的所有核心功能、AI 插件用法、开发调试工具以及针对 40% 键盘优化的快捷键。

---

## 1. 核心快捷键 (40% 键盘优化)

### 1.1 基础导航与命令
| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `;` | 进入命令模式 | 映射为 `:`，无需按 Shift，右手小指直达 |
| `jk` | 退出插入模式 | 插入模式下连按 `jk` 等同于 `Esc` |
| `H` | 上一个文件 | `Shift + h`，在打开的 Buffer 间左移 |
| `L` | 下一个文件 | `Shift + l`，在打开的 Buffer 间右移 |
| `Space + h/j/k/l` | 窗口跳转 | 快速在分屏窗口间移动 |
| `<Esc>` | 清除搜索高亮 | 快速取消搜索后的黄色高亮 |

### 1.2 文件与搜索 (Telescope & Neo-tree)
| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `Space + e` | 开关文件树 | 快速查看项目目录结构 |
| `Space + ff` | 查找文件 | 模糊搜索项目内的所有文件 |
| `Space + fw` | 搜索单词 | 在项目中全局搜索当前光标下的单词 |
| `Space + fg` | 全局搜索 | 通过文本内容实时搜索 (Live Grep) |
| `Space + <Space>` | 切换已打开文件 | 在当前打开的所有 Buffer 中搜索 |
| `Space + sh` | 搜索帮助 | 搜索 Neovim 官方文档 |
| `Space + sk` | 搜索快捷键 | 查看当前所有已定义的快捷键列表 |

---

## 2. AI 助手功能 (Claude & Gemini)

### 2.1 Claude Code (`<leader>c`)
| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `Space + cc` | 切换 Claude | 呼出/隐藏 Claude 聊天终端 |
| `Space + cb` | 添加当前文件 | 将当前打开的文件发送给 Claude 作为上下文 |
| `Space + cs` | 发送选中代码 | (可视模式) 将选中的代码块发给 Claude |
| `Space + ca` | 接受修改 | 接受 Claude 提出的代码 Diff 修改 |
| `Space + cd` | 拒绝修改 | 拒绝 Claude 提出的代码 Diff 修改 |

### 2.2 Gemini Code (`<leader>g`)
| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `Space + gg` | 切换 Gemini | 呼出/隐藏 Gemini 侧边栏 |
| `Space + gc` | AI 会话终端 | 启动或切换到 AI 命令行会话 |
| `Space + gd` | 诊断发送 | 将当前行的错误信息发送给 Gemini 请求解释 |
| `Space + gs` | 发送选中代码 | (可视模式) 将选中内容发送给 Gemini |

### 2.3 OpenCode / Opencode (`<leader>o`)
前置条件：系统里需要有 `opencode` 命令（脚本会尝试自动安装；也可手动执行 `npm install -g @opencode-ai/cli`）。

| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `Space + ot` | 切换 Opencode 面板 | 打开/关闭 Opencode 侧边面板 |
| `Space + oa` | 提问（带上下文） | 在普通/可视模式下把当前上下文发给 Opencode |
| `Space + os` | 选择 Prompt | 选择预设提示词 |
| `Space + oc` | 会话列表 | 列出当前活跃会话 |

---

## 3. 编程语言与开发工具 (LSP & Debug)

### 3.1 核心编程功能 (LSP)
| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `gd` | 跳转定义 | 跳转到函数或变量定义处 |
| `grr` | 查看引用 | 列出所有使用该变量/函数的地方 |
| `K` | 悬浮文档 | 查看光标下符号的详细文档 |
| `Space + ca` | 代码修复 | 自动修复错误、导入包或重构建议 |
| `grn` | 重命名 | 全局重命名当前变量/函数 |
| `L` | 行诊断 | 浮窗显示当前行的详细错误信息 |

### 3.2 调试功能 (DAP - 针对 Go/Python)
| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `Space + dc` | 开始/继续调试 | 启动调试会话或跳到下一个断点 |
| `Space + di` | 步入 (Step Into) | 进入函数内部 |
| `Space + do` | 步过 (Step Over) | 执行下一行代码 |
| `Space + dO` | 步出 (Step Out) | 跳出当前函数 |
| `Space + db` | 切换断点 | 在当前行开启/关闭断点 |
| `Space + dB` | 条件断点 | 设置带条件的断点 |
| `Space + du` | 切换调试 UI | 打开/关闭调试面板（变量查看、堆栈等） |

补充：
- 为了适配 40% 键盘，调试已**完全不依赖 F1-F12**，统一收敛到 `<leader>d` 前缀。
- 兼容保留：`Space + b` / `Space + B` 仍可用于断点切换/条件断点（推荐使用 `Space + db` / `Space + dB`）。

### 3.3 Git 集成 (Gitsigns)
| 快捷键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `]c` | 下一个修改点 | 跳转到下一个 Git 修改块 |
| `[c` | 上一个修改点 | 跳转到上一个 Git 修改块 |
| `Space + hp` | 预览修改 | 浮窗显示当前块相对于 Git 的修改内容 |
| `Space + hb` | Git Blame | 显示当前行是谁在什么时候写的 |
| `Space + tb` | 实时 Blame | 开启/关闭行末实时显示 Git 作者信息 |

---

## 4. 自动化与辅助功能
*   **自动补全**: 基于 `blink.cmp`，输入时自动弹出，`Enter` 确认。
*   **自动配对**: 输入 `(`、`[`、`{` 时自动补全另一半。
*   **缩进线**: 屏幕上会有淡淡的垂直线，帮助对齐代码块。
*   **自动格式化**: 
    *   **Python**: 保存时自动运行 `black` 和 `isort`。
    *   **Golang**: 保存时自动运行 `goimports` 和 `gofumpt`。
*   **实时检查**: 后台自动运行 `pylint` (Python) 或 `golangci-lint` (Go)。

---

## 5. 维护命令
*   `:Lazy` - 插件管理（更新、安装）。
*   `:Mason` - 语言工具管理（LSP、格式化工具安装）。
*   `:checkhealth` - 检查 Neovim 环境是否正常。

---

**Alex，这是为您汇总的完整全功能手册。您可以随时通过 `nvim manual-for-alex.md` 查看它。**
