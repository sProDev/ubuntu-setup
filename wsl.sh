#!/bin/bash

# save current directory to variable
CURR_DIR=$(pwd)

# change dir to /tmp
cd /tmp

# update & upgrade packages
sudo apt update
sudo apt upgrade -y

# install initial dependencies
sudo apt install -y net-tools build-essential telnet zip unzip cmake

# generate missing locale
sudo locale-gen id_ID.UTF-8

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# install node.js
nvm install --lts
npm i -g npm yarn

# install personal utility
yarn global add typescript concurrently nodemon vercel heroku lerna

# install libreoffice
sudo apt install -y libreoffice

# install wkhtmltopdf
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
sudo apt install -y ./wkhtmltox_0.12.6-1.focal_amd64.deb
rm -rf ./wkhtmltox_0.12.6-1.focal_amd64.deb

# install ngrok
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz
sudo tar xvzf ./ngrok-stable-linux-amd64.tgz -C /usr/local/bin

# install oh-my-zsh
sudo apt install -y wget git
sudo apt install -y zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# .zshrc configuration
rm -f ~/.zshrc && cat >> ~/.zshrc << 'END'
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode auto

CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
export MANPATH="/usr/local/man:$MANPATH"
export LANG=id_ID.UTF-8

# zplug init
if [ -f ${HOME}/.zplug/init.zsh ]; then
    source ${HOME}/.zplug/init.zsh
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# zplug loader
zplug "dracula/zsh", as:theme
ZSH_THEME="dracula"
zplug load

# dracula theme configuration
DRACULA_DISPLAY_GIT=0
DRACULA_DISPLAY_TIME=1
DRACULA_DISPLAY_CONTEXT=1
DRACULA_ARROW_ICON="->"
DRACULA_DISPLAY_NEW_LINE=1

# yarn
export PATH="$(yarn global bin):$PATH"

# custom alias
alias sdev="concurrently \"yarn watch\" \"php spark serve\""
END

# set zsh as default shell
sudo chsh -s $(which zsh) $(whoami)

# install zsh-syntax-higlighting
export ZSH_CUSTOM=~/.oh-my-zsh/custom
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# load zplug
zplug load

# install dracula theme for zsh
zplug install "dracula/zsh"

# autoremove & autoclean
sudo apt autoremove -y
sudo apt autoclean

# change dir to CURR_DIR
cd ${CURR_DIR}
