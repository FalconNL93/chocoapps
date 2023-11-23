$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$scriptPath = $PSScriptRoot

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $arguments = "pwsh.exe -WorkingDirectory $scriptPath -NoProfile -NoLogo -NoExit " + $myinvocation.mycommand.definition + ""
    Start-Process wt.exe -Verb runAs -ArgumentList $arguments
    Exit
}

if(!$isAdmin)
{
    Write-Error "This script must be run as Administrator"
    Exit    
}

$chocoVersion = powershell choco -v
if(-not($chocoVersion)){
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    refreshenv
    choco feature enable -n=allowGlobalConfirmation
}

[string[]]$packages = "install";
[string[]]$packages += Get-Content -Path 'apps.txt'

Start-Process "choco.exe" -Wait -ArgumentList $packages