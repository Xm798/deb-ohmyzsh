#!/bin/sh

set -e

source functions.sh

echo "Activating feature 'deb-ohmyzsh'"

check_and_install ca-certificates

# check if zsh is installed
if which zsh; then
  echo "ZSH is already installed. Great!"
else
  echo "ZSH needs to be installed"
  apt install zsh
fi

# Set zsh as default shell
chsh -s "$(which zsh)" "$_CONTAINER_USER"

apt install wget git

if [ -z "$_CONTAINER_USER_HOME" ]; then
  if [ -z "$_CONTAINER_USER" ]; then
    _CONTAINER_USER_HOME=/root
  else
    _CONTAINER_USER_HOME=$(getent passwd $_CONTAINER_USER | cut -d: -f6)
  fi
fi

ZSH_RC_FILE=$_CONTAINER_USER_HOME/.zshrc

# Install ohmyzsh
su -c "wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s" $_CONTAINER_USER

# Remove default plugins from ohmyzsh
upsert_config_option "^plugins=(.*)$" "plugins=(\n)" $ZSH_RC_FILE

# Install plugins
if echo "$PLUGINS" | grep -w -q "zsh-autosuggestions"; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $_CONTAINER_USER_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

if echo "$PLUGINS" | grep -w -q "zsh-syntax-highlighting"; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $_CONTAINER_USER_HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if echo "$PLUGINS" | grep -w -q "autoupdate"; then
  git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $_CONTAINER_USER_HOME/.oh-my-zsh/custom/plugins/autoupdate
fi

if echo "$PLUGINS" | grep -w -q "autojump"; then
  git clone https://github.com/wting/autojump $_CONTAINER_USER_HOME/.oh-my-zsh/custom/plugins/autojump
  check_and_install python3
  su -c "cd $_CONTAINER_USER_HOME/.oh-my-zsh/custom/plugins/autojump/ && SHELL=zsh && ./install.py" $_CONTAINER_USER
  echo $'\n[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh' >> $ZSH_RC_FILE
  echo $'\nautoload -U compinit && compinit -u' >> $ZSH_RC_FILE
fi

if echo "$PLUGINS" | grep -w -q "alias-tips"; then
  check_and_install python3
  git clone https://github.com/djui/alias-tips $_CONTAINER_USER_HOME/.oh-my-zsh/custom/plugins/alias-tips
fi

if echo "$PLUGINS" | grep -w -q "zsh-interactive-cd"; then
  check_and_install fzf
fi

for plugin in $PLUGINS; do
  upsert_config_option "^plugins=(.*)$" "plugins=(\n  $plugin\n)" $ZSH_RC_FILE
done

# Set zsh theme
upsert_config_option "^ZSH_THEME=.*$" "ZSH_THEME=\"$THEME\"" "$ZSH_RC_FILE"

# Set locales
if [ "$SETLOCALE" = "true" ]; then
  check_and_install locales
  echo "$DESIREDLOCALE" >>/etc/locale.gen
  locale-gen
fi

echo 'Done!'