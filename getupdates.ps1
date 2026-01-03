if ($IsWindows) {
    Write-Host "This script will update Windows and WinGet Packages."

    # we run winget twice to catch packages in all scopes
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget upgrade --all --accept-source-agreements --accept-package-agreements
    }
    
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop update
        scoop update *
    }

    if (Get-Command pip -ErrorAction SilentlyContinue) {
        pip list --outdated --format=json | ConvertFrom-Json | ForEach-Object { pip install -U $_.name }
    }

    if (Get-Command npm -ErrorAction SilentlyContinue) {
        npm update -g
    }

    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Start-Process pwsh -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
        exit
    }

    # start of admin commands

    Get-CimInstance -Namespace "root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName "UpdateScanMethod"

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget upgrade --all --accept-source-agreements --accept-package-agreements
    }

    # a lot of people have choco installed so we'll run this to make their life easier
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        choco upgrade all -y
    }

    # windows update (always run this last)
    UsoClient StartScan
    UsoClient StartDownload
    UsoClient StartInstall
    Write-Host "If Windows updated, you should probably reboot."
}
elseif ($IsLinux) {
    Write-Host "Wrong file! Execute getupdates.sh"
    exit 1
}
elseif ($IsMacOS) {
    Write-Host "Wrong file! Execute getupdates.sh"
    exit 1
}