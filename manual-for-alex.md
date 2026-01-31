# Alex 的 Neovim（Mars.nvim 定制版）完整操作手册

本手册以当前仓库里的真实配置为准（入口：`nvim/init.lua`，核心模块：`nvim/lua/mars/`）。

---

## 0. 快速开始（安装 / 更新 / 首次启动）

### 0.1 一键安装（推荐）
- 运行脚本：`install-for-alex.sh`
  - 会备份旧的 `~/.config/nvim` / `~/.local/share/nvim` 等目录
  - 创建符号链接到本仓库的 `nvim/`
  - 预热：执行 `nvim --headless "+Lazy! sync" +qa` 自动拉取插件

### 0.2 常用维护命令
- `:Lazy`：插件管理（安装/更新/清理）
- `:Mason`：LSP/格式化/检查工具管理
- `:ConformInfo`：查看格式化器是否可用
- `:checkhealth`：总健康检查
- `:checkhealth mars.nvim`：本配置的健康检查（会检查 `git/make/unzip/rg` 等外部依赖）

### 0.3 升级 Neovim（卸载低版本 → 安装高版本）
> 目标：确保系统里只保留一个最新版本，避免 PATH 指向旧版本。

#### 第 1 步：确认当前版本与安装来源
- `nvim --version`
- `which -a nvim` 查看是否有多个路径

#### 第 2 步：卸载旧版本（Ubuntu）
- `sudo apt remove -y neovim`
- 若通过 snap 安装：`sudo snap remove nvim`

#### 第 3 步：安装高版本（推荐官方稳定版）
- 推荐 AppImage（单条命令，以 v0.11.6 为例）：
    ```
    sudo apt update && sudo apt install -y libfuse2 && sudo wget -O /usr/local/bin/nvim https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.appimage && sudo chmod +x /usr/local/bin/nvim && hash -r && nvim --version
    ``` 

#### 第 4 步：验证与清理
- `nvim --version` 确认已升级
- 如仍显示旧版本，优先检查 PATH 与 `which -a nvim`

> 说明：本仓库的配置不需要删除；升级后直接运行 `nvim` 即可。

---

## 1. 约定与核心手感（40% 键盘友好）

### 1.1 Leader 键
- **Leader**：`Space`
- **LocalLeader**：`Space`

### 1.2 最重要的全局快捷键（强烈建议记住）
| 按键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `;` | 进入命令行 | 等同 `:`（免 Shift） |
| `jk` | 退出插入模式 | 插入模式下等同 `<Esc>` |
| `<Esc>` | 清除搜索高亮 | 关闭 `hlsearch` 高亮 |
| `H` / `L` | 上/下一个 Buffer | 在已打开文件间切换 |
| `tn` / `tj` / `tk` | 新建/下一个/上一个 Tab | 轻量标签页流转 |
| `Space + h/j/k/l` | 窗口跳转 | 在分屏窗口间移动 |
| `<C-h/j/k/l>` | 分屏/跨 tmux 导航 | `vim-tmux-navigator`（同时配合 `tmux.conf`） |

### 1.3 终端模式（Neovim 内置 terminal）
| 按键 | 功能 |
| :--- | :--- |
| `jk`（终端模式） | 退出终端输入，回到普通模式 |
| `<Esc><Esc>`（终端模式） | 同上（更保险） |

---

## 2. 文件/搜索/替换（Telescope + Neo-tree + grug-far）

### 2.1 Telescope（模糊查找）
| 按键 | 功能 |
| :--- | :--- |
| `<C-p>` 或 `Space + sf` | 查找文件 |
| `Space + sg` | 全局内容搜索（Live Grep） |
| `Space + sw` | 搜索光标下单词（grep_string） |
| `Space + sh` | 搜索帮助文档（help_tags） |
| `Space + sk` | 搜索快捷键（keymaps） |
| `Space + sd` | 搜索诊断（diagnostics） |
| `Space + sr` | 恢复上一次 Telescope（resume） |
| `Space + s.` | 最近文件（oldfiles） |
| `Space + Space` | 已打开 Buffer 列表（buffers） |
| `Space + /` | 当前 buffer 模糊搜索 |
| `Space + s/` | 只在“已打开文件”里 Live Grep |
| `Space + sn` | 搜索 Neovim 配置文件（cwd=配置目录） |

#### Telescope 界面内常用按键（插入模式）
| 按键 | 功能 |
| :--- | :--- |
| `<C-j>` / `<C-k>` | 上/下移动选择 |
| `<C-t>` | 用 Tab 打开（tab drop） |
| `<Esc>` | 退出 Telescope |

### 2.2 Neo-tree（文件树）
| 按键 | 功能 | 说明 |
| :--- | :--- | :--- |
| `Space + e` | 开关文件树 | `Neotree toggle` |
| `<C-e>` | reveal 当前文件 | 在树里定位当前文件；也可用于关闭树窗口 |

#### Neo-tree 窗口内（常用）
| 按键 | 功能 |
| :--- | :--- |
| `o` | 打开文件/目录 |
| `z` | 在当前目录范围打开 grug-far（查找替换，路径会自动预填） |
| `O` | 帮助/排序入口（按创建时间、诊断、git 状态、修改时间等排序） |

> 提示：打开文件时，Neo-tree 会自动关闭（避免占屏）。

### 2.3 grug-far（跨文件查找替换）
| 按键 | 功能 |
| :--- | :--- |
| `Space + gs` | 打开 grug-far（新 Tab）用于全局查找替换 |

---

## 3. LSP（智能跳转 / 重构 / 诊断）

> LSP 快捷键是在 **LspAttach** 后按 buffer 绑定的（进入支持 LSP 的文件类型后生效）。

### 3.1 常用 LSP 快捷键
| 按键 | 功能 |
| :--- | :--- |
| `grd` | 跳转定义（definition，Telescope 列表） |
| `grr` | 查找引用（references，Telescope 列表） |
| `gri` | 跳转实现（implementations） |
| `grt` | 类型定义（type definition） |
| `grD` | 跳转声明（declaration） |
| `grn` | 重命名（rename） |
| `gra` | Code Action（普通/可视模式） |
| `gO` | 当前文件符号（document symbols） |
| `gW` | 工作区符号（workspace symbols） |
| `L` | 浮窗显示“当前行”诊断详情 |
| `Space + q` | 打开诊断列表（loclist） |
| `Space + th` | 开关 Inlay Hints（仅当 LSP 支持时） |
| `Space + yd` | 复制当前行诊断（含 file:line:col）到系统剪贴板 |

### 3.2 已配置的 LSP（由 Mason 管理）
已在配置中声明：`gopls`、`ts_ls`、`eslint`、`ruff`、`pyright`、`lua_ls`

---

## 4. 补全与输入体验（blink.cmp / snippets / autopairs）

### 4.1 补全（blink.cmp）
- 输入时自动弹出补全

| 按键 | 功能 |
| :--- | :--- |
| `<C-j>` / `<C-k>` | 选择下一项/上一项 |
| `<C-e>` | 显示/隐藏补全 |
| `<C-s>` | 显示/隐藏签名（signature） |
| `<C-l>` | 显示/隐藏文档（documentation） |

### 4.2 自动括号（nvim-autopairs）
- 插入模式输入 `(` / `[` / `{` 等会自动补全另一半

---

## 5. 格式化与静态检查（conform.nvim / nvim-lint）

### 5.1 一键格式化（conform.nvim）
| 按键 | 功能 |
| :--- | :--- |
| `Space + f` | 格式化当前 buffer（async；LSP 兜底） |

#### 保存时自动格式化
- 默认开启（部分文件类型例外：`c/cpp` 不自动格式化）
- 常见格式化器配置：
  - **Lua**：`stylua`
  - **Go**：`goimports` / `goimports-reviser` / `gofumpt`
  - **Python**：`isort` / `black`
  - **JS/TS**：优先 `prettierd`，否则 `prettier`

### 5.2 实时 lint（nvim-lint）
触发时机：`BufEnter` / `BufWritePost` / `InsertLeave`

- **Markdown**：`markdownlint`
- **TypeScript**：`eslint`

> 这些工具通常由 Mason 安装/管理；若 lint 不生效，优先检查 `:Mason` 与 `:checkhealth mars.nvim`。

---

## 6. Git（gitsigns / neogit）

### 6.1 gitsigns（行内 diff 与 hunk 操作）
| 按键 | 功能 |
| :--- | :--- |
| `]c` / `[c` | 下/上一个修改块（hunk） |
| `Space + hp` | 预览 hunk |
| `Space + hb` | blame 当前行 |
| `Space + hs` | stage hunk |
| `Space + hr` | reset hunk |
| `Space + hS` | stage buffer |
| `Space + hR` | reset buffer |
| `Space + hd` / `Space + hD` | diff against index / last commit |
| `Space + tb` | 开关“行尾实时 blame” |
| `Space + tD` | 预览删除（inline） |

### 6.2 Neogit（类 Magit 界面）
| 按键 | 功能 |
| :--- | :--- |
| `Space + ng` | 打开 Neogit |

---

## 7. 调试（nvim-dap / dap-ui / dap-go）

> 当前配置确保安装 `delve`，并启用 `dap-go`。调试 UI 会在会话开始自动打开，结束自动关闭。

| 按键 | 功能 |
| :--- | :--- |
| `Space + dc` | 开始/继续 |
| `Space + di` | Step Into |
| `Space + do` | Step Over |
| `Space + dO` | Step Out |
| `Space + db` | 切换断点 |
| `Space + dB` | 条件断点 |
| `Space + du` | 开关调试 UI |

兼容别名（不依赖功能键）：
- `Space + b`：切换断点
- `Space + B`：条件断点

---

## 8. AI（Claude / Gemini / Opencode / Supermaven）

### 8.1 Claude Code（`<leader>c`）
| 按键 | 功能 |
| :--- | :--- |
| `Space + cc` | 开关 Claude |
| `Space + cf` | 聚焦 Claude |
| `Space + cr` | Resume 对话 |
| `Space + cC` | Continue 对话 |
| `Space + cm` | 选择模型 |
| `Space + cb` | 把当前文件加入上下文 |
| `Space + cs`（可视模式） | 发送选中内容 |
| `Space + ca` / `Space + cd` | 接受/拒绝 diff |

### 8.2 Gemini（`<leader>g`）
| 按键 | 功能 |
| :--- | :--- |
| `Space + gg` | 开关 Gemini 侧边栏 |
| `Space + gc` | 切换到 Gemini CLI 会话 |
| `Space + gD` | 发送“整个文件”的诊断 |
| `Space + gs`（可视模式） | 发送选中内容到 Gemini |
| `Space + ga` | 接受 diff |

> 注意：当前配置里 `Space + gd` 存在重复绑定（既用于发送“当前行诊断”，也用于“拒绝 diff”）。以实际生效为准；如果你发现 `gd` 只能“拒绝 diff”，请使用 `gD` 发送文件诊断作为替代。

### 8.3 Opencode（`<leader>o`）
前置条件：系统里需要 `opencode` 命令（脚本会尝试安装；也可手动执行 `npm install -g opencode-ai`）。

| 按键 | 功能 |
| :--- | :--- |
| `Space + ot` | 开关 Opencode 面板 |
| `Space + oa` | 提问（携带当前上下文） |
| `Space + os` | 选择 Prompt |
| `Space + oc` | 列出会话（session.list） |

### 8.4 Supermaven（补全建议）
- 输入时自动提供 AI 建议（与补全系统并存）

---

## 9. 其他体验增强（上手即用）

### 9.1 Leap（超快跳转）
| 按键 | 功能 |
| :--- | :--- |
| `e` | Leap 跳转 |
| `E` | 跨窗口 Leap |

### 9.2 启动欢迎页（mars-greeter）
- 当你以空 buffer/目录启动时，会显示欢迎页（提示：`<C-p>` 打开文件、`:q` 退出等）

---

## 10. 常见问题排查（优先看这里）

### 10.1 搜索不好用 / Live Grep 没结果
- 确认安装了 `rg`（ripgrep）
- 运行：` :checkhealth mars.nvim `

### 10.2 Telescope 的 fzf 加速没生效
- `telescope-fzf-native.nvim` 需要 `make`
- 如果系统没有 `make`，配置会自动跳过编译，但 Telescope 仍可用（只是没那么快）

### 10.3 图标显示异常
- 确认终端字体是 Nerd Font
- 本配置默认 `vim.g.have_nerd_font = true`

### 10.4 格式化/诊断不生效
- 先看 `:Mason` 是否安装了对应工具
- 再看 `:ConformInfo` / `:checkhealth`

---

（你可以随时 `nvim manual-for-alex.md` 打开本手册；如果后续你又调整了 `lua/mars/`，我也可以帮你自动“从配置反推”更新这份文档。）
