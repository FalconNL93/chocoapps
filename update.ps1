$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $arguments = "pwsh.exe -NoProfile -NoLogo -NoExit " + $myinvocation.mycommand.definition + ""
    Start-Process wt.exe -Verb runAs -ArgumentList $arguments
    Exit
}

if(!$isAdmin)
{
    Write-Error "This script must be run as Administrator"
    Exit    
}

$p = Get-Process -Name "HWiNFO64"
Stop-Process -InputObject $p
Get-Process | Where-Object {$_.HasExited}

sudo choco upgrade all --except="'libreoffice-fresh'"
sudo winget upgrade --all

& "C:\Program Files\HWiNFO64\HWiNFO64.exe"
