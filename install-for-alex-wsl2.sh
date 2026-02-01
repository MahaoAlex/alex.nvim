#!/bin/bash

# install-for-alex-wsl2.sh
# One-click setup for WSL2 (Ubuntu 24.04)

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"
NEOVIM_VERSION="0.11.6"
NEOVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux-x86_64.appimage"

info "Starting Neovim setup for Alex on WSL2 (Ubuntu 24.04)..."

# 0. Check WSL environment
if ! grep -qi "microsoft" /proc/version; then
    warn "WSL signature not detected (/proc/version). Continuing, but please verify the environment."
fi

# 1. System dependencies
info "Checking and installing system dependencies..."
sudo apt update
sudo apt install -y \
    git curl unzip gcc g++ make \
    python3-venv python3-pip \
    golang-go ripgrep \
    nodejs npm \
    libfuse2 ca-certificates

# 1.1 Install or upgrade Neovim (AppImage)
info "Checking Neovim version..."
NEED_NVIM_INSTALL=1
if command -v nvim >/dev/null 2>&1; then
    CURRENT_VER="$(nvim --version | awk 'NR==1{print $2}' | sed 's/^v//')"
    if [ -n "$CURRENT_VER" ] && dpkg --compare-versions "$CURRENT_VER" ge "0.11.0"; then
        info "Detected Neovim $CURRENT_VER, meets requirements, skipping install."
        NEED_NVIM_INSTALL=0
    else
        warn "Detected Neovim $CURRENT_VER, upgrading to ${NEOVIM_VERSION}."
    fi
fi

if [ "$NEED_NVIM_INSTALL" -eq 1 ]; then
    info "Installing Neovim AppImage v${NEOVIM_VERSION}..."
    sudo curl -fsSL -o /usr/local/bin/nvim "${NEOVIM_APPIMAGE_URL}"
    sudo chmod +x /usr/local/bin/nvim
    hash -r
    nvim --version | head -n 1 || true
fi

# 1.2 Install OpenCode CLI (for opencode.nvim inside Neovim)
if command -v opencode >/dev/null 2>&1; then
    info "Detected opencode: $(opencode --version 2>/dev/null || true)"
else
    if command -v npm >/dev/null 2>&1; then
        info "opencode not found, trying to install opencode-ai via npm ..."
        if npm install -g opencode-ai; then
            info "opencode installed: $(opencode --version 2>/dev/null || true)"
            warn "First-time use: opencode init (optional) and opencode auth login (if needed)"
        else
            warn "opencode install failed (does not affect other features). You can run: npm install -g opencode-ai"
            warn "Or use the official script: curl -fsSL https://opencode.ai/install | bash"
        fi
    else
        warn "npm not found, skipping opencode install. Ensure nodejs/npm is installed, then run: npm install -g opencode-ai"
    fi
fi

# 1.3 WSL2 clipboard support (win32yank.exe)
if command -v win32yank.exe >/dev/null 2>&1; then
    info "Detected win32yank.exe, WSL clipboard support is ready."
else
    info "Installing WSL clipboard tool win32yank.exe ..."
    mkdir -p "${HOME}/.local/bin"
    curl -fsSL -o "${HOME}/.local/bin/win32yank.exe" \
        "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank.exe"
    chmod +x "${HOME}/.local/bin/win32yank.exe"
fi

if ! echo "$PATH" | tr ':' '\n' | grep -qx "${HOME}/.local/bin"; then
    export PATH="${HOME}/.local/bin:${PATH}"
fi

# 2. Backup existing config
backup_config() {
    local dir=$1
    if [ -d "$dir" ] || [ -L "$dir" ]; then
        local backup="${dir}.backup.$(date +%Y%m%d%H%M%S)"
        warn "备份旧配置 $dir -> $backup"
        mv "$dir" "$backup"
    fi
}

info "Cleaning old config..."
backup_config "${CONFIG_DIR}/nvim"
backup_config "${HOME}/.local/share/nvim"
backup_config "${HOME}/.local/state/nvim"
backup_config "${HOME}/.cache/nvim"

# 3. Create config symlinks
info "创建配置符号链接..."
mkdir -p "$CONFIG_DIR"
ln -s "$SCRIPT_DIR/nvim" "${CONFIG_DIR}/nvim"

# 4. Tmux config (optional)
if [ -d "$SCRIPT_DIR/tmux" ]; then
    info "Configuring Tmux..."
    backup_config "${CONFIG_DIR}/tmux"
    mkdir -p "${CONFIG_DIR}/tmux"
    ln -s "$SCRIPT_DIR/tmux/tmux.conf" "${CONFIG_DIR}/tmux/tmux.conf"
    if [ ! -e "${HOME}/.tmux.conf" ]; then
        ln -s "${CONFIG_DIR}/tmux/tmux.conf" "${HOME}/.tmux.conf"
    fi
fi

# 5. Warm up Neovim (auto download plugins)
info "Launching Neovim to auto-install plugins (please wait, exit when done)..."
nvim --headless "+Lazy! sync" +qa

info "Setup complete!"
echo -e "${GREEN}--------------------------------------------------${NC}"
echo -e "You can now run ${YELLOW}nvim${NC} to start."
echo -e "Notes for a 40% keyboard:"
echo -e "- Use ${YELLOW};${NC} instead of ${YELLOW}:${NC} for command mode"
echo -e "- Use ${YELLOW}jk${NC} to exit insert mode"
echo -e "- Use ${YELLOW}H / L${NC} to switch buffers"
echo -e "- Use ${YELLOW}Space + e${NC} to toggle the file tree"
echo -e "${GREEN}--------------------------------------------------${NC}"
