# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
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
