#!/bin/bash

set -euo pipefail

git --version # to check git is available

git clone https://github.com/atrn0/dotfiles.git ~/ghq/github.com/atrn0/dotfiles || true
cd ~/ghq/github.com/atrn0/dotfiles
make
git remote remove origin && git remote add origin git@github.com:atrn0/dotfiles.git
cd - > /dev/null
