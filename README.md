# Geo-Uri Handler

This small project is designed to create a basic but solid implementation of the [Geo URI scheme](https://en.wikipedia.org/wiki/Geo_URI_scheme) as described in [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) for major operating systems.

The goal is to open a map-application or -website when a geo-URI e.g. [geo:64.0273717353389,-16.97493164751844](geo:64.0273717353389,-16.97493164751844) (`<indicator>:<latitude>,<longitude>[,<altitude>][;crs=<coordinate reference systems>][;u=<uncertainty in meters>]]`) is clicked.

Exemplarily [OpenStreetMap](https://www.openstreetmap.org) is used as service to handle geo-URIs. Any service can be configured in the executables installed by this project.

## Usage

For each OS that has a supported add-on, a subfolder is created. Please refer to the README-files inside this folder.

- [Windows](Windows/README.md)

## License

This project is licensed under the MIT-License described in the [LICENSE file](LICENSE).
