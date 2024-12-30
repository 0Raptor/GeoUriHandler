#!/bin/bash

sudo tee /usr/share/applications/geo-opener.desktop > /dev/null <<'EOT'
[Desktop Entry]
Type=Application
Name=GEO Uri Scheme Handler
Exec=/usr/bin/GeoUriHandler.sh %u
StartupNotify=false
MimeType=x-scheme-handler/geo;
EOT

sudo tee /usr/bin/GeoUriHandler.sh > /dev/null <<'EOT'
#!/usr/bin/env bash

# (C) 2024 0Raptor
# GeoUriHandler was released under the MIT license

if [[ "$1" == "geo:"* ]]; then
    data=${1#geo:}
    dataArray=(${data//;/ })
    coords=${dataArray[0]}
    coordsArray=(${coords//,/ })
    xdg-open "https://www.openstreetmap.org/?mlat=${coordsArray[0]}&mlon=${coordsArray[1]}&zoom=15"
else
    xdg-open "$1" # Malformed input, just open with the default handler
fi
EOT
sudo chmod +x /usr/bin/GeoUriHandler.sh

sudo xdg-mime default geo-opener.desktop x-scheme-handler/geo
sudo update-desktop-database /usr/share/applications