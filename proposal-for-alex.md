# Proposal for Alex's Neovim Configuration

This document proposes a Neovim setup tailored for Alex on **Aliyun Ubuntu 22.04 remote desktop**, optimized for a **40% keyboard** layout, with strong support for **Python** and **Golang** development.

---

## 1. Context & Goals
*   **Environment**: Aliyun remote desktop (Ubuntu 22.04.5 LTS).
*   **Access**: Remote access from a Windows client.
*   **Hardware**: 40% keyboard layout (minimal keys, heavy reliance on layers).
*   **Languages**: Python, Golang.
*   **Core goals**: Minimal keystrokes, fast response, fully automated setup.

---

## 2. Key Modifications

### 2.1 Base Options (`options.lua`)
*   **Indentation**: Set `tabstop` and `shiftwidth` to 4 to match Python and Go conventions.
*   **Clipboard sync**: Enable `unnamedplus` and use `xclip` for seamless copy/paste with Windows.
*   **UI tuning**: Reduce remote desktop latency by adjusting `updatetime` (250ms) and `timeoutlen` (300ms).

### 2.2 40% Keyboard Keymaps (`keymaps.lua`)
Designed for the lack of number row and function keys:
*   **Leader**: `Space`, the entry point for core actions.
*   **Window navigation**:
    *   `Space + h/j/k/l`: replaces `Ctrl-w + h/j/k/l` for fast splits.
*   **File management**:
    *   `H` / `L`: switch between open buffers.
    *   `Space + e`: toggle the file tree (Neo-tree).
*   **Command input**:
    *   `;`: mapped to `:` to avoid Shift.
*   **Quick exit**:
    *   `jk`: exit insert mode.

### 2.3 Debug Keymap Unification (`debug.lua`)
To avoid function keys on a 40% layout, DAP keymaps are unified:
*   **Prefix**: `Space + d` (shown as `[D]ebug` in which-key).
*   **Core actions**:
    *   `Space + dc`: start/continue
    *   `Space + di`: step into
    *   `Space + do`: step over
    *   `Space + dO`: step out
    *   `Space + db`: toggle breakpoint
    *   `Space + dB`: conditional breakpoint
    *   `Space + du`: toggle debug UI
*   **Compatibility**: `Space + b / Space + B` still works for breakpoints (recommended to migrate to `Space + d...`).

### 2.4 which-key Display Disambiguation (`init.lua`)
To avoid confusion, which-key shows:
*   `D` modifier (Command/Super) as `<Command-...>` instead of `<D-...>`.

### 2.5 Language Support Enhancements (`lsp.lua`)
*   **Python**: auto install/configure `pyright` (LSP), `black` (format), `ruff` (lint).
*   **Golang**: auto install/configure `gopls` (LSP), `goimports` (imports), `gofumpt` (strict formatting).
*   **Auto install**: Mason downloads missing tools on first launch.

---

## 3. Main Features
*   **Automatic plugin management**: Based on `Lazy.nvim`, downloads on first launch.
*   **Completion**: Fast completion via `blink.cmp`.
*   **AI helpers**: Built-in Claude / Gemini / OpenCode, triggered by `Space + c/g/o`.
*   **Fuzzy search**: `Space + ff` (files), `Space + fw` (text).
*   **Diagnostics**: Real-time Python/Go errors with `Space + ca` for quick fixes.
*   **Statusline**: Clean UI with Git branch, LSP state, and file encoding.

---

## 4. Deployment Workflow

### Phase 1: Code Changes (AI)
1.  Update core files like `options.lua`, `keymaps.lua`, `lsp.lua`.
2.  Generate the `install-for-alex.sh` automation script.
3.  Commit all changes to GitHub.

### Phase 2: Remote Deployment (Alex)
Run the following in the Aliyun Ubuntu terminal:
```bash
# 1. Enter the workspace
cd ~/workspace (or your code directory)

# 2. Clone or pull latest code
git clone https://github.com/your-repo/10-alex.nvim.git
cd 10-alex.nvim

# 3. Run the one-click installer
chmod +x install-for-alex.sh
./install-for-alex.sh
```

---

## 5. `install-for-alex.sh` Script Logic
1.  **Dependencies**: Install `git`, `curl`, `unzip`, `gcc`, `nodejs`, `golang`, `xclip`.
2.  **Cleanup**: Back up and remove old `~/.config/nvim` and cache.
3.  **Link config**: Link repo `nvim` to `~/.config/nvim`.
4.  **Warm up**: Trigger plugin download.

---

**Alex, please review this proposal. If it looks good, let me know and I will proceed with code changes and script generation.**
