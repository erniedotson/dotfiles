# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Load Functions
$tmpPath = "$HOME\Documents\WindowsPowerShell\functions.ps1"
if (Test-Path $tmpPath -PathType Leaf) {
. $tmpPath
}

# Load Custom Aliases
$tmpPath = "$HOME\Documents\WindowsPowerShell\aliases.ps1"
if (Test-Path $tmpPath -PathType Leaf) {
. $tmpPath
}

# Load extra
$tmpPath = "$HOME\Documents\WindowsPowerShell\extra.ps1"
if (Test-Path $tmpPath -PathType Leaf) {
. $tmpPath
}

# Initialize Starship prompt
if (Get-Command -Name starship -ErrorAction SilentlyContinue) {
	Invoke-Expression (&starship init powershell)
}
