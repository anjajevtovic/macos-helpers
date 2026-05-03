#!/bin/bash

set -euo pipefail

green()  { echo -e "\033[32m$*\033[0m"; }
red()    { echo -e "\033[31m$*\033[0m"; }
gray()   { echo -e "\033[90m$*\033[0m"; }

# XCODE
################
if xcode-select -p &>/dev/null; then
	gray "-> xcode already installed, skipping"
else
	gray  "Installing xcode CMD Line Tools"
	xcode-select --install 2>/dev/null || true

	if xcode-select -p &>/dev/null; then
		green "[x] xcode install successful"
	else
		red "[!] xcode install failed. try again"
	fi
fi
################

# BREW
################
if command -v brew &>/dev/null; then
	gray "-> Homebrew already installed, skipping"
else
	gray "Installing brew"
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

if ! grep -q "brew shellenv" ~/zprofile; then
	echo >> ~/.zprofile
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
fi

eval "$(/opt/homebrew/bin/brew shellenv)"	
green "[x] brew install successful; brew PATH set in .zprofile"
################

# APPS via BREW
################
gray "Installing iterm2, firefox, keepassxc, the-unarchiver, rectangle, surfshark, cursor via brew"
brew install --cask iterm2 firefox keepassxc the-unarchiver rectangle surfshark cursor
green "[x] Apps install successful"
################

# OhMyZSH
################
if [ -d "$HOME/.oh-my-zsh" ]; then
	gray "-> Oh My Zsh already installed, skipping"
else
	gray "Installing OhMyZSH and setting theme"
	curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended
fi

sed -i '' '/ZSH_THEME/c\ZSH_THEME="xiong-chiamiov-plus"' ~/.zshrc
green "[x] OMZ install successful"
################

# Hostname&Computername
################
echo -n "Set new hostname and computer name? [y/n]:"
read -r ans

if [[ "$ans" =~ ^[Yy]$ ]]; then
	echo -n "Enter new hostname:"
	read -r hostname

	echo -n "Enter new computer name:"
	read -r computername
	sudo scutil --set HostName "$hostname"
	sudo scutil --set LocalHostName "$hostname"
	sudo scutil --set ComputerName "$computername"
else
	gray "-> Skipping hostname setup"
fi
################

green "[x] Setup complete!"
