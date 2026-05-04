#!/bin/bash

set -euo pipefail

green()  { echo -e "\033[32m$*\033[0m"; }
red()    { echo -e "\033[31m$*\033[0m"; }
gray()   { echo -e "\033[90m$*\033[0m"; }

# XCODE
################
# TODO: xcode-select is interactive install - set it to be non-interactive
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

# TODO: Ensure this this line is appended only once 
if ! grep -q "brew shellenv" ~/zprofile; then
	echo >> ~/.zprofile
	echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> ~/.zprofile
fi

eval "$(/opt/homebrew/bin/brew shellenv zsh)"	
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

# TODO: This line is not working as expected
sed -i '' '/ZSH_THEME/c\ZSH_THEME="xiong-chiamiov-plus"' ~/.zshrc
green "[x] OMZ install successful"
################

# Hostname change
################
echo -n "Set new hostname and computer name? [y/n]:"
read -r ans

if [[ "$ans" =~ ^[Yy]$ ]]; then
	echo -n "Enter new hostname:"
	read -r hostname
	
	sudo scutil --set HostName "$hostname"
	sudo scutil --set LocalHostName "$hostname"
	sudo scutil --set ComputerName "$hostname"
else
	gray "-> Skipping hostname setup"
fi
################

green "[x] Setup complete!"
