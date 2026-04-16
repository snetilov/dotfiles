#!/usr/bin/env bash

# Starship
mkdir -R ~/.local/bin
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin

apt install fzf fd eza node tree-sitter-cli lua5.1 luarocks neovim openjdk maven gradle

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# On Debian
# cd /usr/local/bin
# sudo wget https://github.com/neovim/neovim/releases/download/v0.12.1/nvim-linux-x86_64.tar.gz
# sudo tar zxf nvim-linux-x86_64.tar.gz
# ln -s nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
