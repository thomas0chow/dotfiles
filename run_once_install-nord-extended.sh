#!/bin/sh
# Install nord-extended oh-my-zsh theme
THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/nord-extended"
if [ ! -d "$THEME_DIR" ]; then
  git clone https://github.com/fxbrit/nord-extended "$THEME_DIR"
fi
