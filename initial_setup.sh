#!/usr/bin/env bash

# Starship
mkdir -R ~/.local/bin
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin

apt install fzf fd lua5.1 luarocks neovim openjdk maven gradle
