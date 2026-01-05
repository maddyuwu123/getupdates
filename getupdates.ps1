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

if ($IsWindows) {
	if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		if (Get-Command winget -ErrorAction SilentlyContinue) {
			winget upgrade --all --accept-source-agreements --accept-package-agreements
		}
		if (Get-Command choco -ErrorAction SilentlyContinue) {
			choco upgrade all -y
		}

		if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
			Write-Host "Downloading Windows updates, this may take a while."
			Get-WindowsUpdate
			Install-WindowsUpdate -AcceptAll
		} else {
			Write-Host "PSWindowsUpdate module not installed. Skipping Windows Update."
		}

		try {
			Get-CimInstance -Namespace "root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" -ErrorAction Stop | Invoke-CimMethod -MethodName "UpdateScanMethod"
		} catch {
			Write-Host "Microsoft Store update failed. Continuing."
		}
		
		Write-Host "All finished!"
		Start-Sleep 3
		exit 0
	}

	Write-Host "This script will update Windows, npm, scoop, winget, pip, msstore and chocolatey packages."
	Write-Host "Make sure you install the PSWindowsUpdate module."

	# run winget twice to catch packages in all scopes
	if (Get-Command winget -ErrorAction SilentlyContinue) {
		winget upgrade --all --accept-source-agreements --accept-package-agreements
	}

	if (Get-Command scoop -ErrorAction SilentlyContinue) {
		scoop update
		scoop update *
	}

	if (Get-Command pip -ErrorAction SilentlyContinue) {
		$outdated = pip list --outdated --format=json | ConvertFrom-Json
		if ($outdated) { pip install -U $outdated.name }
	}

	if (Get-Command npm -ErrorAction SilentlyContinue) {
		npm update -g
	}

	Start-Process pwsh -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
	exit
}
elseif ($IsLinux) {
	Write-Host "Wrong file! Execute getupdates.sh"
	exit 1
}
elseif ($IsMacOS) {
	Write-Host "Wrong file! Execute getupdates.sh"
	exit 1
}

# fallback for 5.1 and below
Write-Host "This script requires Powershell 6+!"
Write-Host "Exiting."
Start-Sleep -Seconds 3
exit 1
