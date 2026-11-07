# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }
${function:mkcd} = {
    param([string]$Path)
    New-Item -ItemType Directory -Force -Path $Path -ErrorAction Stop | Out-Null
    Set-Location -LiteralPath $Path
}

# MARK: Linux alternatives

${function:uptime} = { systeminfo | Select-String -Pattern "System Boot Time" }
