#! /usr/bin/bash
USRHOME="$(getent passwd $SUDO_USER | cut -d: -f6)"
set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"
echo updating...
apt update
echo installing the must-have pre-requisites
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
        tree
EOF
)

sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd ..
rm -rf neovim/
sudo make install

echo installing the nice-to-have pre-requisites
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6

echo creating config if it does not exist
mkdir -p ~/.config/

echo getting NeoVim config
git clone https://github.com/ntk148v/neovim-config.git
echo ol switcheroo
cd neovim-config/
cp -Rv nvim $USRHOME/.config/
cd ..
rm -rf neovim-config/
