$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

# check administrative permission
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $arguments = "&amp; '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# install script
$path = Read-Host -prompt "Enter folder to install script to [C:\Program Files\GeoUriHandler]"
if ([string]::IsNullOrWhitespace($path)) { $path = "C:\Program Files\GeoUriHandler" }
if (-NOT (Test-Path -Path $path)) {
    New-Item -ItemType Directory -Force -Path $path
}
else {
    Write-Warning "Selected folder exists."
    $query = Read-Host -prompt "Clear content and try to remove old configuration from registry? [yN]"
    if ($query -like "y") {
        # clear folder content
        Get-ChildItem -Path $path -Directory | Remove-Item
        Get-ChildItem -Path $path -File | Remove-Item
        # try to remove node from registry
        try { Remove-Item "Registry::HKEY_CLASSES_ROOT\geo" -Recurse } catch { Write-Host "Registry key not found. Skipping." }
    }
}
Copy-Item ".\GeoUriHandler.bat" -Destination $path

# configure registry
$key = New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo" -Value '"URL:Geo URI scheme"'
New-ItemProperty -Path $key.PSPath -Name 'URL Protocol' -PropertyType String -Value ''

New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\DefaultIcon" -Value '%SystemRoot%\System32\SHELL32.dll,14'

New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\shell"
New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\shell\open"
New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\shell\open\command" -Value '"C:\Program Files\GeoUriHandler\GeoUriHandler.bat" "%1"'
#New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\shell\open\command" -Value '"powershell" "C:\Program Files\GeoUriHandler\GeoUriHandler.bat" "%1"'
