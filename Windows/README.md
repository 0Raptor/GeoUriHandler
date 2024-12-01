# Geo-Uri Handler - Windows

The add-on for Microsoft Windows is tested with Windows 10 and Windows 11. No additional applications are required.

## Install

- Download the project via `git clone` *or* click on the Button "<> Code" and select "Download ZIP"
- Extract ZIP-file if button was used
- Execute PowerShell as administrator from the start menu and `cd` to the subfolder "Windows"
- Type `powershell -ExecutionPolicy Bypass -File .\install.ps1` and hit enter
  - ATTENTION: If you have already changed your system's [PowerShell execution policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4) to something less restrictive than `AllSigned` omit `-ExecutionPolicy Bypass` from the command or reset the policy after installation (to get your current configuration type `Get-ExecutionPolicy -List` into PowerShell) - this does not apply to the [legacy mode](#legacy-mode)
- To check if everything worked, type `geo:64.0273717353389,-16.97493164751844` into `explorer.exe` or your browser and expect [OpenStreetMap](https://www.openstreetmap.org/?mlat=64.0273717353389&mlon=-16.97493164751844&zoom=15) to be opened in your browser

## Optional parameters

- `-path <string>`
  - Specify the folder the application should be installed to. The input prompt will be skipped if it differs from the default value.
  - Default: `C:\Program Files\GeoUriHandler`
- `-silent`
  - Skips all input prompts when submitted. Use the other parameters to control the installation.
  - Default: `false`
  - Useful for unattended installations.
- `-override`
  - Clears the content of the installation directory (`-path`-parameter) and required registry keys if submitted and if the installation directory already exists.
  - Default: `false`
  - Useful for upgrades.
- `-legacyMode`
  - Install using the [legacy mode](#legacy-mode) when submitted.
  - Default: `false`

## Legacy mode

By default, the installer will install the add-on as a PowerShell-script. This script will be signed with a self-signed certificate to prevent malicious tempering. Therefore, your system's execution policies and certificate store must be changed.

In case these parameters cannot be modified or problems with the cryptographic-functions occur, the installer offers the **legacy mode**:  
In **legacy mode**, a batch-script will be installed. This script executed PowerShell-commands to start the map service.

In **legacy mode**, the following configurations are unnecessary and skipped:

- Creation of self-signed certificate
- Adding certificate to trusted root- and publisher certificates
- Setting Execution Policy to (at least) `AllSigned`

Certainly, the security benefits of a signed application are lost!

## Change Map Service

- Edit the string created after `; $url =` in line three of [GeoUriHandler.bat](GeoUriHandler.bat) / line four of [GeoUriHandler.ps1](GeoUriHandler.ps1)
  - You can use the string `$data` which contains the original input (`geo:10,20`) without `geo` -> `$data = 10,20`
  - You can use the string-array `$coords` which contains the latitude (0), longitude (1) and, if supplied, the altitude (3)
- This string will be fed into `Start-Process -FilePath`
  - To test your changes, just type a manually-forged test-string into the addressbar of explorer.exe
- If you want to open another application and supply the coordinates as command-line-aguments, edit the `Start-Process`-command
  - Enter the path to the binary after `-FilePath` and the coordinates after `-ArgumentList`

## References

- [Registering an Application to a URI Scheme](https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa767914(v=vs.85))
- [Start-Process](https://learn.microsoft.com/de-de/powershell/module/microsoft.powershell.management/start-process?view=powershell-7.4)
- [OpenStreetMap: How to put a pin at the map?](https://help.openstreetmap.org/questions/7019/how-to-put-a-pin-at-the-map)
