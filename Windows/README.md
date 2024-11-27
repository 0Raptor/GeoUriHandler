# Geo-Uri Handler - Windows

The add-on for Microsoft Windows is tested with Windows 10 and Windows 11. No additional applications are required.

## Install

- Download the project via `git clone` *or* click on the Button "<> Code" and select "Download ZIP"
- Extract ZIP-file if this method was used
- Open the subfolder "Windows" in the file explorer *or* execute PowerShell from the start menu and `cd` to the subfolder "Windows"
- Click into the address bar of the file explorer (*or* directly type into the shell), type `powershell -ExecutionPolicy Bypass -File .\install.ps1` and hit enter
  - When unexpected errors occur and the terminal just closes execute the command from the shell, so the error messages does not disappear
- To check if everything worked, type `geo:64.0273717353389,-16.97493164751844` into `explorer.exe` or your browser and expect [OpenStreetMap](https://www.openstreetmap.org/?mlat=64.0273717353389&mlon=-16.97493164751844&zoom=15) to be opened in your browser

## Change Map Service

- Edit the string created after `; $url =` in line three of [GeoUriHandler.bat](GeoUriHandler.bat)
  - You can use the string `$data` which contains the original input (`geo:10,20`) without `geo` -> `$data = 10,20`
  - You can use the string-array `$coords` which contains the latitude (0), longitude (1) and, if supplied, the altitude (3)
- This string will be fed into `Start-Process -FilePath`
  - To test your changes, just type a manually-forged test-string into the addressbar of explorer.exe

## References

- [Registering an Application to a URI Scheme](https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa767914(v=vs.85))
