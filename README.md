# getupdates
This is a project I made from scratch.
Originally, it was just going to be a bash script for Arch Linux, but it kind spiraled out of control.

## Installation
Download the zip file and execute the corresponding executable.
.ps1 for Windows
.sh for Linux and macOS

If you are on Windows, you will have to enable unsigned script executing.
Do so by inputting the following command into PowerShell.
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

If you are on Linux or macOS, make sure the file is executable by typing in the cloned repository;
```bash
chmod +x getupdates.sh
```

To make it so you only have to type ```getupdates``` everytime you want to update;

On Linux;
```bash
sudo cp -v getupdate.sh /bin/getupdates
```

On macOS;
```bash
sudo cp getupdates.sh /usr/local/bin/getupdates
```

On Windows;
i got no idea lmao

## COPYING
See LICENSE
