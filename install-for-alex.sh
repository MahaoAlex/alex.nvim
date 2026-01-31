#!/bin/bash

# install-for-alex.sh
# 针对 Alex 的阿里云 Ubuntu 22.04 环境定制的一键部署脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"

info "开始为 Alex 部署 Neovim 配置..."

# 1. 系统依赖安装
info "检查并安装系统依赖..."
# 注意：nodejs 22.x 已经包含 npm，不再单独安装 npm 以防冲突
sudo apt update
sudo apt install -y git curl unzip gcc g++ make nodejs python3-venv python3-pip golang-go xclip ripgrep

# 1.1 安装 OpenCode CLI（用于 Neovim 内 opencode.nvim）
if command -v opencode >/dev/null 2>&1; then
    info "检测到 opencode 已安装：$(opencode --version 2>/dev/null || true)"
else
    if command -v npm >/dev/null 2>&1; then
        info "未检测到 opencode，尝试通过 npm 安装 opencode-ai ..."
        # 需要网络；失败不阻断整体安装流程
        if npm install -g opencode-ai; then
            info "opencode 安装完成：$(opencode --version 2>/dev/null || true)"
            warn "首次使用建议执行：opencode init（可选）以及 opencode auth login（如需要登录）"
        else
            warn "opencode 安装失败（不影响 Neovim 其他功能）。你可以稍后手动执行：npm install -g opencode-ai"
            warn "或使用官方脚本：curl -fsSL https://opencode.ai/install | bash"
        fi
    else
        warn "未检测到 npm，跳过 opencode 安装。请确认 nodejs/npm 已正确安装后再执行：npm install -g opencode-ai"
    fi
fi

# 2. 备份旧配置
backup_config() {
    local dir=$1
    if [ -d "$dir" ]; then
        local backup="${dir}.backup.$(date +%Y%m%d%H%M%S)"
        warn "备份旧配置 $dir -> $backup"
        mv "$dir" "$backup"
    fi
}

info "清理旧配置..."
backup_config "${CONFIG_DIR}/nvim"
backup_config "${HOME}/.local/share/nvim"
backup_config "${HOME}/.local/state/nvim"
backup_config "${HOME}/.cache/nvim"

# 3. 创建配置链接
info "创建配置符号链接..."
mkdir -p "$CONFIG_DIR"
ln -s "$SCRIPT_DIR/nvim" "${CONFIG_DIR}/nvim"

# 4. Tmux 配置 (可选)
if [ -d "$SCRIPT_DIR/tmux" ]; then
    info "配置 Tmux..."
    backup_config "${CONFIG_DIR}/tmux"
    mkdir -p "${CONFIG_DIR}/tmux"
    ln -s "$SCRIPT_DIR/tmux/tmux.conf" "${CONFIG_DIR}/tmux/tmux.conf"
    # 如果没有 ~/.tmux.conf，也链一个过去
    if [ ! -e "${HOME}/.tmux.conf" ]; then
        ln -s "${CONFIG_DIR}/tmux/tmux.conf" "${HOME}/.tmux.conf"
    fi
fi

# 5. 预热 Neovim (自动下载插件)
info "正在启动 Neovim 以自动安装插件 (请耐心等待，完成后手动退出)..."
nvim --headless "+Lazy! sync" +qa

info "部署完成！"
echo -e "${GREEN}--------------------------------------------------${NC}"
echo -e "现在你可以输入 ${YELLOW}nvim${NC} 开启你的开发之旅了。"
echo -e "针对 40% 键盘的特别提醒："
echo -e "- 使用 ${YELLOW};${NC} 代替 ${YELLOW}:${NC} 进入命令模式"
echo -e "- 使用 ${YELLOW}jk${NC} 快速退出插入模式"
echo -e "- 使用 ${YELLOW}H / L${NC} 切换文件标签"
echo -e "- 使用 ${YELLOW}Space + e${NC} 打开文件树"
echo -e "${GREEN}--------------------------------------------------${NC}"
