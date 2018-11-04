# Nomaden map generation

This set of scripts creates OpenStreetMap tiles of Hamburg for the Nomaden site. It spins up a spot instance on EC2, installs all the necessary stuff and then downloads the raw map database and renders the tiles.

After we're finished you'll find a `tile.tar` in the local directory.

## Requirements

 - Python 3
 - boto3
 - netcat
 - bash
 
## Running

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
