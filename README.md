# HI Crossing Analysis

hi_crossing

Github repository: github.com/jedalong/hi_crossing

## Description
This app facilitates crossing analysis of features in Open Street Map (OSM).

## Documentation
This app computes where tracking data segments (i.e., pairs of consecutive tracking points) cross OSM features. It extracts the 'key' of the feature that was crossed, and the key 'value' of the feature. If a single segment crosses multiple features it counts how many features it crossed and takes stores the key and value of type most frequently crossed during that segment. 

The OSM key, which is essentially a class of features in OSM, can be specified as an input variable. The default is to use the 'highway' key which includes roads, trails, etc.

The OSM value, which is essentially the typology of features within a given OSM key, can also be specified as an input variable. The default is to use all of the values in a given key, but single values can be specified for more targeted analysis.

The geom argument can be used to focus on a specific geometry type: one of 'line' (the default), or 'polygon'.

The back-end tools used for geoprocessing crossings work more efficiently with projected geographical data. Therefore, the crs_code parameter can be used to pass in a projected coordinate system which is then used for all geoprocessing tasks.


### Input data

MoveStack in Movebank format

### Output data

MoveStack in Movebank format with three additional columns:

- crossing_true: Logical, whether or not a segment was a crossing
- crossing_key: OSM key associated with crossings
- crossing_value: OSM value associated with crossings
- crossing_count: count of how many crossings are associated with a segment

### Artefacts

`Table_CrossingType.csv`: A csv file with a table of the number of crossings associated with each OSM valye. 
`Table_FixCrossings.csv`: A csv file with only those fixes associated with a crossing. First fix in a crossing segment only.
`Shapfile_Crossings.shp`: A shapefile with crossing locations (also has .shx,.dbf.prj files)

### Settings 

`key`: (string) OSM key class, as a string. Default is 'highway'. For more information see the (OSM Wiki Page)[ https://wiki.openstreetmap.org/wiki/Tags#Keys_and_values].

`value`: (string) OSM value tag, as a string. Default is to use all values for a specified key, but the user can choose specific value tags for more targeted analysis. For more information see the (OSM Wiki Page)[ https://wiki.openstreetmap.org/wiki/Tags#Keys_and_values].

`geom`: (string) geometry type to focus on, one of ('point', 'line', 'polygon'). Default is 'line'.

`crs_code`: (integer) With crossing analysis it is strongly recommended that the data be converted into a PROJECTED coordinate reference system (e.g., UTM Zone, national grid, etc.). CRS codes (also known as EPSG codes) are integer numbers that correspond to a specified Spatial Coordinate Reference System. A searchable website for identifying the CRS code associated with a given reference system is: https://spatialreference.org.

### Most common errors

- specified key/value is not present (check spelling of key and value settings)
- OSM data (for chosen key/value) not present in study area (overlay GPS data on OSM to check)
- Study area is too large (try to make study area or OSM query smaller)

### Null or error handling

***Input MoveStack:** If input data is of class: "Move", it is automatically converted to a "MoveStack". If it is another type of object the function returns NULL. 
