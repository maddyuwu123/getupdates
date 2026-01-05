#!/usr/bin/env bash
set -o pipefail
set -e

#  Copyright (C) 2026  Madison Reid
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

echo "This script supports Linux and macOS. Press any key to continue or Ctrl+C to exit."
read -s -n1 

if [[ $OSTYPE == linux* ]]; then
	for mgr in apt-get dnf yum zypper pacman; do
		command -v "$mgr" >/dev/null 2>&1 && MANAGER="$mgr" && break
	done

	[[ -z "$MANAGER" ]] && echo "Can't find a supported package manager!" && exit 1

	command -v flatpak >/dev/null 2>&1 && FLATPAK=true
	command -v snap >/dev/null 2>&1 && SNAP=true

	case "$MANAGER" in
	apt-get)
		sudo apt-get update && sudo apt-get upgrade -y
		;;
	dnf)
		sudo dnf update -y
		;;
	yum)
		sudo yum update -y
		;;
	zypper)
		sudo zypper update --non-interactive
		;;
	pacman)
		if command -v yay >/dev/null 2>&1; then
			yay -Syu --noconfirm
		elif command -v paru >/dev/null 2>&1; then
			paru -Syu --noconfirm
		else
			sudo pacman -Syu --noconfirm
		fi
		;;
	esac

	if [[ "$FLATPAK" == "true" ]]; then
		sudo flatpak upgrade -y
	fi

	if [[ "$SNAP" == "true" ]]; then
		sudo snap refresh
	fi

	echo "All done! Press any key to exit."
	read -s -n1
	exit 0
elif [[ "$OSTYPE" == "darwin"* ]]; then
	if command -v brew >/dev/null 2>&1; then
		brew update && brew upgrade
	fi
	sudo softwareupdate --install --all
else
	echo "Unsupported operating system."
	exit 1
fi

echo "Done!"
