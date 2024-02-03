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
	fd-find
	ripgrep
        gettext
        cmake
        unzip
        curl
        tree
	neofetch
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
mkdir -p $USRHOME/.config/nvim/

echo getting NeoVim config
git clone https://github.com/c-alex-horton/kickstart.nvim.git $USRHOME/.config/nvim/

sudo chown -R $USER $USRHOME/

neofetch


