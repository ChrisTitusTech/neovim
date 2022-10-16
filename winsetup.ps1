#!/bin/bash

# Initial Setup file for new systems
rm -r ~/AppData/Local/nvim
rm -r ~/AppData/Local/nvim-data
mkdir -p $HOME/.vim/undodir
mkdir -p $HOME/.scripts
git clone https://github.com/NvChad/NvChad $HOME\AppData\Local\nvim --depth 1
irm "https://osdn.net/frs/redir.php?m=rwthaachen&f=mingw%2F68260%2Fmingw-get-setup.exe" -o "mingw-setup.exe"
# Share system clipboard with unnamedplus
#sudo apt install vim-gtk3 ripgrep fd-find xclip neovim python3-venv luarocks go luarocks go

# Grab dependancies
#
$wingetinstall = New-Object System.Collections.Generic.List[System.Object]
$wingetinstall.Add("rjpcomputing.luaforwindows")
$wingetinstall.Add("Python.Python.3")
$wingetinstall.Add("Rustlang.Rust.MSVC")
$wingetinstall.Add("OpenJS.NodeJS")
$wingetinstall.Add("Neovim.Neovim")
#$wingetinstall.Add("")
#$wingetinstall.Add("")
#$wingetinstall.Add("")
#$wingetinstall.Add("")
#$wingetinstall.Add("")

# Install all winget programs in new window
        $wingetinstall.ToArray()
        # Define Output variable
        $wingetResult = New-Object System.Collections.Generic.List[System.Object]
        foreach ( $node in $wingetinstall ) {
            try {
                Start-Process powershell.exe -Verb RunAs -ArgumentList "-command winget install -e --accept-source-agreements --accept-package-agreements --silent $node | Out-Host" -WindowStyle Normal
                $wingetResult.Add("$node`n")
                Start-Sleep -s 3
                Wait-Process winget -Timeout 90 -ErrorAction SilentlyContinue
            }
            catch [System.InvalidOperationException] {
                Write-Warning "Allow Yes on User Access Control to Install"
            }
            catch {
                Write-Error $_.Exception
            }
        }
        $wingetResult.ToArray()
        $wingetResult | ForEach-Object { $_ } | Out-Host
