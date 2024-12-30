# Geo-Uri Handler - Linux xdg-utils

The add-on for Linux Desktop systems that use [xdg-utils](https://freedesktop.org/wiki/Software/xdg-utils/) - which is preinstalled on most systems and a de facto standard. It is tested with GNOME on Debian 12 but should work with other distros and desktop environments.

## Install

- Download the installer by opening the [file](install.sh) online and clicking on the "Download raw file"-button *or* download the project via `git clone`
- Open a terminal in your "Downloads"-folder *or* `cd` into the repos "Linux xdg-utils" subfolder
- Make the script executable with `chmod +x install.sh`
- Install the add-on for all users on your system with `sudo ./install.sh`
- Use the command `xdg-open "geo:64.0273717353389,-16.97493164751844"` to verify that everything has worked. Expect [OpenStreetMap](https://www.openstreetmap.org/?mlat=64.0273717353389&mlon=-16.97493164751844&zoom=15) to be opened in your default browser

## Change Map Service

- Edit the string of the command at line 23 of [install.sh](install.sh)
  - You can use the string `$data` which contains the original input (`geo:10,20`) without `geo` -> `$data = 10,20`
  - You can use the string-array `${dataArray[x]}` which contains the position (0) and optional parameters (N)
  - You can use the string-array `${coordsArray[x]}` which contains the latitude (0), longitude (1) and, if supplied, the altitude (3)

## References

- [Create a custom URL Protocol Handler](https://unix.stackexchange.com/questions/497146/create-a-custom-url-protocol-handler)
- [Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry-spec/latest/)
- [desktop-file-utils](https://www.freedesktop.org/wiki/Software/desktop-file-utils/)
- [OpenStreetMap: How to put a pin at the map?](https://help.openstreetmap.org/questions/7019/how-to-put-a-pin-at-the-map)
