#!/usr/bin/env bash
set -o pipefail

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
read -s -N1 

if [[ $OSTYPE == linux-gnu ]]; then
	if command -v apt-get >/dev/null 2>&1; then
		MANAGER="apt-get update -y && apt-get upgrade -y"
	elif command -v dnf >/dev/null 2>&1; then
		MANAGER="dnf update -y"
	elif command -v yum >/dev/null 2>&1; then
		MANAGER="yum update -y"
	elif command -v zypper >/dev/null 2>&1; then
		MANAGER="zypper update -y"
	elif command -v pacman >/dev/null 2>&1; then
		MANAGER="pacman -Syu --noconfirm"
	# Add your package manager below
	#elif command -v [package manager] > /dev/null 2>&1; then
	# 	MANAGER="[command]"
	else
		echo "Can't find a supported package manager!"
		exit 1
	fi

	if command -v flatpak >/dev/null 2>&1; then
		FLATPAK=true
	fi

	if command -v snap >/dev/null 2>&1; then
		SNAP=true
	fi

	case "$MANAGER" in
	*apt-get*)
		sudo $MANAGER
		;;
	esac

	case "$MANAGER" in
	*dnf*)
		sudo $MANAGER
		;;
	esac

	case "$MANAGER" in
	*yum*)
		sudo $MANAGER
		;;
	esac

	case "$MANAGER" in
	*zypper*)
		sudo $MANAGER
		;;
	esac

	case "$MANAGER" in
	*pacman*)
		if command -v yay >/dev/null 2>&1; then
			yay -Syu --noconfirm
		elif command -v paru >/dev/null 2>&1; then
			paru -Syu --noconfirm
		else
			sudo $MANAGER
		fi
		;;
	esac

	#case "$MANAGER" in
	#	*[package manager]*)
	#		[command]
	#		;;
	#esac

	if echo "$FLATPAK" | grep -q "true"; then
		sudo flatpak upgrade
	fi

	if echo "$SNAP" | grep -q "true"; then
		sudo snap upgrade
	fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	sudo softwareupdate --install --all
elif [[ "$OSTYPE" == * ]]; then
	echo "Unsupported operating system."
	exit 1
fi
