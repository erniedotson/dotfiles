# "npp <filename>" opens <filename> in Notepad++
#Set-Alias npp "C:\Program Files\Notepad++\notepad++.exe" @args
function npp
{
  if (Test-path "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe")
  {
    &"${env:ProgramFiles(x86)}\Notepad++\notepad++.exe"$args
  }
  elseif (Test-path "${env:ProgramFiles}\Notepad++\notepad++.exe")
  {
    &"${env:ProgramFiles}\Notepad++\notepad++.exe" $args
  }
  else
  {
    Write-Output "Could not find Notepad++ in the default installation locations"
  }
}

function web {
  param(
      [string]$url
  )

  # Open the provided URL in the default web browser
  Start-Process https://$url
}

function google {
  web("google.com")
}