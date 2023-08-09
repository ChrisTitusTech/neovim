# Initial Setup file for new systems
rm -r ~/AppData/Local/nvim
rm -r ~/AppData/Local/nvim-data
mkdir -p $HOME/.vim/undodir
mkdir -p $HOME/.scripts
New-Item -Path "$HOME\AppData\Local\nvim" -ItemType SymbolicLink -Target "$pwd\custom"

# Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))


#
