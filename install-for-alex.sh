#!/bin/bash

# install-for-alex.sh
# One-click setup for Alex on Aliyun Ubuntu 22.04

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

info "Starting Neovim setup for Alex..."

# 1. System dependencies
info "Checking and installing system dependencies..."
# Note: nodejs 22.x already includes npm; avoid separate npm install
sudo apt update
sudo apt install -y git curl unzip gcc g++ make nodejs python3-venv python3-pip golang-go xclip ripgrep

# 1.1 Install OpenCode CLI (for opencode.nvim inside Neovim)
if command -v opencode >/dev/null 2>&1; then
    info "Detected opencode: $(opencode --version 2>/dev/null || true)"
else
    if command -v npm >/dev/null 2>&1; then
        info "opencode not found, trying to install opencode-ai via npm ..."
        # Requires network; failure should not block the overall install
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

# 2. Backup existing config
backup_config() {
    local dir=$1
    if [ -d "$dir" ]; then
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
info "Creating config symlinks..."
mkdir -p "$CONFIG_DIR"
ln -s "$SCRIPT_DIR/nvim" "${CONFIG_DIR}/nvim"

# 4. Tmux config (optional)
if [ -d "$SCRIPT_DIR/tmux" ]; then
    info "Configuring Tmux..."
    backup_config "${CONFIG_DIR}/tmux"
    mkdir -p "${CONFIG_DIR}/tmux"
    ln -s "$SCRIPT_DIR/tmux/tmux.conf" "${CONFIG_DIR}/tmux/tmux.conf"
    # If ~/.tmux.conf does not exist, link one
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
