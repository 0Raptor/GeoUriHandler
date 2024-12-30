# Geo-Uri Handler - Firefox

The add-on for the web-browser Mozilla Firefox has been tested with version 133.0.  
This will not work with Firefox for Android since Android is handling geo-URIs internally.

## Install

- You can temporarily load the source code into Firefox as described in [Mozilla's docs](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Your_first_WebExtension#installing)
- To use the addon permanently, you have to sign it as described in [Mozilla's extension workshop](https://extensionworkshop.com/documentation/publish/submitting-an-add-on/)
  - ZIP all files in the [src subdirectory](src) (excluding `src` itself)
  - Open the [Add-ons Developer Hub](https://addons.mozilla.org/developers/), sign in or register and submit your file
  - For private use, the distribution type "On your own" should be sufficient. Otherwise, the add-on will be listed publicly in Mozilla's Add-ons Manager

## Change Map Service

- Edit the string created after `targetUrl =` in line four of [GeoUriHandler.js](src/GeoUriHandler.js)
  - You can use the string `data` which contains the original input (`geo:10,20`) without `geo` -> `data = 10,20`
  - You can use the string-array `coords` which contains the latitude (0), longitude (1) and, if supplied, the altitude (3)
- This string will be opened in the current tab

## Existing products

To avoid compiling your own Firefox add-on, the already existing [geo-handler add-on](https://github.com/Andrew67/geo-handler) might satisfy your needs (installable via [Firefox Browser Add-ons](https://addons.mozilla.org/de/firefox/addon/geo-uri-handler)).

## Contribution

The used map icon was created by Pixel perfect and shared on [Flaticon](https://www.flaticon.com/free-icons/map).

## References

- [Your first extension](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Your_first_WebExtension)
- [OpenStreetMap: How to put a pin at the map?](https://help.openstreetmap.org/questions/7019/how-to-put-a-pin-at-the-map)
