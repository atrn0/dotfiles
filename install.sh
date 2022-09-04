#!/bin/bash

set -euo pipefail

git clone https://github.com/atrn0/dotfiles.git ~/ghq/github.com/atrn0/dotfiles || true
cd ~/ghq/github.com/atrn0/dotfiles
make
cd - > /dev/null
