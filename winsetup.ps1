# Initial setup file for new Windows systems

$ErrorActionPreference = "Stop"

function Install-WingetPackage {
	param (
		[Parameter(Mandatory = $true)]
		[string]$Id
	)

	if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
		Write-Warning "winget is not available. Install dependencies manually."
		return
	}

	winget install --id $Id --exact --accept-source-agreements --accept-package-agreements --silent
}

function Ensure-Command {
	param (
		[Parameter(Mandatory = $true)]
		[string]$Command,
		[Parameter(Mandatory = $true)]
		[string]$WingetId
	)

	if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
		Install-WingetPackage -Id $WingetId
	}
}

# Core Neovim dependencies used by this config.
Ensure-Command -Command "nvim" -WingetId "Neovim.Neovim"
Ensure-Command -Command "rg" -WingetId "BurntSushi.ripgrep.MSVC"
Ensure-Command -Command "fd" -WingetId "sharkdp.fd"
Ensure-Command -Command "fzf" -WingetId "junegunn.fzf"
Ensure-Command -Command "node" -WingetId "OpenJS.NodeJS.LTS"

# ShellCheck package ID can vary across winget sources, so install best-effort.
if (-not (Get-Command shellcheck -ErrorAction SilentlyContinue)) {
	try {
		Install-WingetPackage -Id "koalaman.shellcheck"
	} catch {
		Write-Warning "Could not install shellcheck via winget. Install manually if needed."
	}
}

# markdown linting in nvim-lint expects markdownlint-cli2.
if (Get-Command npm -ErrorAction SilentlyContinue) {
	if (-not (Get-Command markdownlint-cli2 -ErrorAction SilentlyContinue)) {
		npm install -g markdownlint-cli2
	}
} else {
	Write-Warning "npm not found. Install markdownlint-cli2 manually to enable Markdown linting."
}

$nvimConfigPath = Join-Path $HOME "AppData/Local/nvim"
$nvimDataPath = Join-Path $HOME "AppData/Local/nvim-data"

if (Test-Path $nvimConfigPath) { Remove-Item -Recurse -Force $nvimConfigPath }
if (Test-Path $nvimDataPath) { Remove-Item -Recurse -Force $nvimDataPath }

New-Item -ItemType Directory -Force -Path (Join-Path $HOME ".vim/undodir") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $HOME ".scripts") | Out-Null

$repoPath = (Get-Location).Path
$targetPath = Join-Path $repoPath "titus-kickstart"
New-Item -Path $nvimConfigPath -ItemType SymbolicLink -Target $targetPath | Out-Null
