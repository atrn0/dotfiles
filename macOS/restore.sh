#!/bin/sh

# restore homebrew
if ! type brew &>/dev/null; then
    # install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# restore homebrew packages
if [ -e $BREWFILE ]; then
    brew bundle --file=$BREWFILE --no-lock
fi

# create links for home directory
ls -A $MAC_HOME | xargs -I {} ln -sf $PWD/$MAC_HOME/{} ~/
