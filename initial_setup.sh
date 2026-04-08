#!/usr/bin/env bash

# Starship
mkdir -R ~/.local/bin
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin

apt install fzf
