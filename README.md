# Nomaden map generation

This set of scripts creates OpenStreetMap tiles of Hamburg for the Nomaden site. It spins up a spot instance on EC2, installs all the necessary stuff and then downloads the raw map database and renders the tiles.

After we're finished you'll find a `tile.tar` in the local directory.

See here for more info: [ofosos.org](https://ofosos.org/2018/11/04/osm-tile-creation-on-aws-spot/)

## Requirements

 - Python 3
 - boto3
 - netcat
 - bash
 
## Running

Be sure to set something similar to the following in you ssh client config or the connection may time out while generating the tiles.

```
Host *
ServerAliveInterval 100
```

The call `run.sh`.

```
$ bash run.sh
```

Please make sure to terminate any spot requests that are left over in EC2 after you run this script. If everything works alright, there are no instances left. If this script fails there will be a spot request and an instance left over.

## About

Copyright (c) 2018, Mark Meyer (mark@ofosos.org)

## Links

https://wiki.openstreetmap.org/wiki/Creating_your_own_tiles
https://github.com/mapnik/mapnik/blob/master/INSTALL.md
https://github.com/gravitystorm/openstreetmap-carto/blob/master/INSTALL.md
https://wiki.openstreetmap.org/wiki/PostGIS/Installation#Create_database
https://wiki.openstreetmap.org/wiki/Osm2pgsql
http://osmtipps.lefty1963.de/2008/10/api-und-bounding-box.html
