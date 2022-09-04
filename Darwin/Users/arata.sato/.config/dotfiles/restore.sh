#!/bin/bash

set -euo pipefail

ARCH=`arch`

# Install xcode-select
if ! xcode-select -p > /dev/null; then
    echo -n "install xcode-select? [Y/n]: "
    read ans

    case $ans in
    "" | [Yy]* )
        sudo xcode-select --install
        ;;
    esac
fi

# Software Update
echo -n "software update? [Y/n]: "
read ans

case $ans in
"" | [Yy]* )
    softwareupdate --all --install --force
    ;;
esac


# restore homebrew
if ! type brew &>/dev/null; then
    echo -n "install homebrew? [Y/n]: "
    read ans

    case $ans in
    "" | [Yy]* )
        # install homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ;;
    esac
fi

if test $ARCH = "arm64"
then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# restore homebrew packages
if [ -e $BREWFILE ]; then
    echo -n "restore homebrew packages? [Y/n]: "
    read ans

    case $ans in
    "" | [Yy]* )
        brew bundle --file=$BREWFILE --no-lock || true
        ;;
    esac
fi

# GPG
echo "GPG"
if type pinentry-mac &>/dev/null; then
mkdir -p ~/.gnupg
cat<<EOF > ~/.gnupg/gpg-agent.conf
pinentry-program $(which pinentry-mac)
EOF
fi

if test $ARCH = "arm64"
then
    mkdir -p ~/.docker/cli-plugins
    ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
fi

# use Touch ID for sudo
echo "use Touch ID for sudo"
# https://gist.github.com/kawaz/d95fb3b547351e01f0f3f99783180b9f
curl -fsSL https://gist.githubusercontent.com/kawaz/d95fb3b547351e01f0f3f99783180b9f/raw/bf4cc90f262206feeac062acc5139584a89d6c4a/install-pam_tid-and-pam_reattach.sh | bash

# restore asdf plugins
if type asdf &>/dev/null; then
    echo -n "install asdf plugins? [Y/n]: "
    read ans

    case $ans in
    "" | [Yy]* )
        cd ~
        set -x
        perl -pe "s/\s.+//" .tool-versions | xargs -I{} asdf plugin add {}
        asdf install
        set +x
        cd - > /dev/null
        ;;
    esac
fi
