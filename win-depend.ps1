# Windows dependency repair script (safe to run repeatedly)

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

New-Item -ItemType Directory -Force -Path (Join-Path $HOME ".vim/undodir") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $HOME ".scripts") | Out-Null

$repoPath = (Get-Location).Path
$targetPath = Join-Path $repoPath "titus-kickstart"

if (Test-Path $nvimConfigPath) {
	$item = Get-Item $nvimConfigPath -Force
	if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
		$currentTarget = $item.Target
		if ($currentTarget -ne $targetPath) {
			Remove-Item -Force $nvimConfigPath
			New-Item -Path $nvimConfigPath -ItemType SymbolicLink -Target $targetPath | Out-Null
		}
	} else {
		Write-Warning "$nvimConfigPath exists and is not a symlink. Leaving it untouched."
		Write-Warning "Remove it manually if you want this script to recreate the symlink."
	}
} else {
	New-Item -Path $nvimConfigPath -ItemType SymbolicLink -Target $targetPath | Out-Null
}

Write-Host "Dependency check complete."
