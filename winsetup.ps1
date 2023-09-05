# Initial Setup file for new systems
rm -r ~/AppData/Local/nvim
rm -r ~/AppData/Local/nvim-data
mkdir -p $HOME/.vim/undodir
mkdir -p $HOME/.scripts
New-Item -Path "$HOME\AppData\Local\nvim" -ItemType SymbolicLink -Target "$pwd\titus-kickstart"
