# Initial Setup file for new systems
rm -r ~/AppData/Local/nvim
rm -r ~/AppData/Local/nvim-data
mkdir -p $HOME/.vim/undodir
mkdir -p $HOME/.scripts
irm "https://osdn.net/frs/redir.php?m=rwthaachen&f=mingw%2F68260%2Fmingw-get-setup.exe" -o "mingw-setup.exe"
# Share system clipboard with unnamedplus
#sudo apt install vim-gtk3 ripgrep fd-find xclip neovim python3-venv luarocks go luarocks go
New-Item -Path "$HOME\AppData\Local\nvim" -ItemType SymbolicLink -Target "$pwd\custom"
# Grab dependencies

# Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#Vale Setup
choco install vale
Copy-Item ".vale.ini" -Destination $HOME
C:\ProgramData\chocolatey\bin\vale.exe sync

# Winget Programs
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
        foreach ( $node in $wingetinstall ) {
            try {
                Start-Process powershell.exe -Verb RunAs -ArgumentList "-command winget install -e --accept-source-agreements --accept-package-agreements --silent $node | Out-Host" -WindowStyle Normal
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
