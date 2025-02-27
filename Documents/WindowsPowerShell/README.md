# PowerShell scripts

`$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` will get loaded when a PowerShell is opened. Note that the `Documents` folder may be redirected, for example if Document are synchronized to OneDrive.

If this is the case, create a file to load the one from $HOME\Documents, e.g. `OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` with contents:

```powershell
$tmpPath = "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
if (Test-Path $tmpPath -PathType Leaf) {
  . $tmpPath
}
```

## References

* [about_Profiles | microsoft.com](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.5)
