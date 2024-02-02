#! /usr/bin/bash
USRHOME="$(getent passwd $SUDO_USER | cut -d: -f6)"
set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"
echo updating...
apt update
echo installing the must-have pre-requisites
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
        ninja-build
        gettext
        cmake
        unzip
        curl
        tree
EOF
)

git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
echo INSTALLING NEOVIM...
sudo make install
cd ..
rm -rf neovim/

echo creating config if it does not exist
mkdir -p ~/.config/nvim/

echo getting NeoVim config
git clone https://github.com/ntk148v/neovim-config.git
echo ol switcheroo
cd neovim-config/
cp -Rv nvim $USRHOME/.config/nvim
cd ..
rm -rf neovim-config/
echo Done
