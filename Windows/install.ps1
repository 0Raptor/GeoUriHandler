 param (
    [string]$path = "C:\Program Files\GeoUriHandler",
    [switch]$silent = $false,
    [switch]$override = $false,
    [switch]$legacyMode = $false
 )

#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

# install script
if (-NOT $silent -and ([string]::IsNullOrWhitespace($path) -or $path -eq "C:\Program Files\GeoUriHandler")) { $path = Read-Host -Prompt "Enter folder to install script to [C:\Program Files\GeoUriHandler]" }
if ([string]::IsNullOrWhitespace($path)) { $path = "C:\Program Files\GeoUriHandler" }
if (-NOT (Test-Path -Path $path)) {
    New-Item -ItemType Directory -Force -Path $path
}
else {
    Write-Warning "Selected folder exists."
    if (-NOT $silent ) {
        $query = Read-Host -prompt "Clear content and try to remove old configuration from registry? [yN]"
        if ($query -like "y") { $override = $true }
    }
    if ($override) {
        # backup cert thumbprint if present
        try { $certificateThumbprint = Get-Content -Path "$path\cert.txt" } catch { Write-Host "No certificate thumbprint to recover. Skipping." }
        # clear folder content
        Get-ChildItem -Path $path -Directory | Remove-Item
        Get-ChildItem -Path $path -File | Remove-Item
        # try to remove node from registry
        try { Remove-Item "Registry::HKEY_CLASSES_ROOT\geo" -Recurse } catch { Write-Host "Registry key not found. Skipping." }
    }
}
if ($legacyMode) { # install batch version
    Copy-Item ".\GeoUriHandler.bat" -Destination $path
} else { # install native powershell version, sign script with new certificate and update execution policy
    Copy-Item ".\GeoUriHandler.ps1" -Destination $path

    # prompt user to confirm script integridy
    if (-NOT $silent) {
        $hashSHA256 = (Get-FileHash "$path\GeoUriHandler.ps1" -Algorithm SHA256).hash
        $hashSHA512 = (Get-FileHash "$path\GeoUriHandler.ps1" -Algorithm SHA512).hash
        $hashSHA1 = (Get-FileHash "$path\GeoUriHandler.ps1" -Algorithm SHA1).hash
        $hashMD5 = (Get-FileHash "$path\GeoUriHandler.ps1" -Algorithm MD5).hash
        Write-Host "Please make sure the script '$path\GeoUriHandler.ps1' matches the script you are trying to install."
        Write-Host "  You can compare the following checksum with the source's checksum or"
        Write-Host "  compare the file's content with https://github.com/0Raptor/GeoUriHandler/blob/main/Windows/GeoUriHandler.ps1"
        Write-Host "(SHA256): $hashSHA256"
        Write-Host "(SHA512): $hashSHA512"
        Write-Host "(SHA1): $hashSHA1"
        Write-Host "(MD5): $hashMD5"
        $query = Read-Host -prompt "Installation candidate is valid? Proceed with installation? [yN]"
        if ($query -ne "y") { exit }
    }

    if (-NOT [string]::IsNullOrWhitespace($certificateThumbprint)) { # try to get stored certificate
        try { 
            $codeSignCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object {$_.Thumbprint -eq $certificateThumbprint}
            # export thumbprint to use it for updates
            $certificateThumbprint | Out-File -FilePath "$path\cert.txt"
        } catch { Write-Warning "Exported certificate thumbprint was not found in user's certificate store." }
    }
    if (-NOT $codeSignCert) { # create new certificate for codesigning (and store in user's cert store)
        # create cert and export
        $certificateName = "GeoUriHandler Code Signing"
        $certificate = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Subject "CN=$certificateName" -KeySpec Signature -Type CodeSigningCert -NotAfter (Get-Date).AddYears(10)
        $certificateThumbprint = $certificate.Thumbprint
        $certificatePath = "$path\$certificateName.cer"
        Export-Certificate -Cert $certificate -FilePath $certificatePath
        # init certstore (for fresh windows installations)
        $certStore = Get-Item "cert:\LocalMachine\TrustedPublisher"
        $certStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $certStore.Close()
        # import to trusted cerstore and clean-up
        Get-Item $certificatePath | Import-Certificate -CertStoreLocation "Cert:\LocalMachine\Root"
        Import-Certificate -FilePath $certificatePath -CertStoreLocation Cert:\LocalMachine\TrustedPublisher
        Remove-Item -Path $certificatePath
        # export thumbprint to use it for updates
        $certificateThumbprint | Out-File -FilePath "$path\cert.txt"
        # import created certificate to sign cert
        $codeSignCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object {$_.Thumbprint -eq $certificateThumbprint}
    }

    Set-AuthenticodeSignature -FilePath "$path\GeoUriHandler.ps1" -Certificate $CodeSignCert

    $currentPolicy = Get-ExecutionPolicy
    if ($currentPolicy -eq "Restricted" -or $currentPolicy -eq "Undefined" -or $currentPolicy -eq "Bypass") { 
        try { Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope LocalMachine -Force } catch {}
    }
}

# configure registry
$key = New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo" -Value '"URL:Geo URI scheme"'
New-ItemProperty -Path $key.PSPath -Name 'URL Protocol' -PropertyType String -Value ''

New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\DefaultIcon" -Value '%SystemRoot%\System32\SHELL32.dll,14'

New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\shell"
New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\shell\open"
if ($legacyMode) {
    $val = [System.String]::Concat('"',$path,'\GeoUriHandler.bat" "%1"')
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\shell\open\command" -Value $val
} else {
    $val = [System.String]::Concat('"C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" "-File" "',$path,'\GeoUriHandler.ps1" "%1"')
    New-Item -Path "Registry::HKEY_CLASSES_ROOT\geo\shell\open\command" -Value $val
}
