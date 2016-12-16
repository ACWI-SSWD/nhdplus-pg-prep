# NHDPlusV21 PostGIS Loader and Geoserver Configuration

## GeoDatabase to PostGIS
These scripts can be used to load the NHDPlusV21 National Flattened Geodatabase into a Postgres database. A 7z version of the data is available here: http://www.horizon-systems.com/NHDPlus/V2NationalData.php along with the pdf documentation of the database.

The config_commands.sh bash script uses ogr2ogr, a [gdal](http://www.gdal.org/) command, to transform vector geospatial data, and psql to insert data into a postgres database and index pertinant columns.  

If you don't want all the tables to be loaded, open the script and comment out unwanted content. The script takes an admin user name and password, a host for postgres, a database name to create, the non-admin owner to associate with the new database and its password.  
like:  
`bash config_commands.sh postgres password localhost nhdplus nhdplus password`

The script tries to create the non-admin user, create the database, and add the postgis extension. It then loads tables and creates indexes overwriting any tables that alread exist in the target database.

The dump\_tables.sh script will dump the created tables to files suitable for inserting into a remote (production) database using psql.

## Geoserver Configuration
A requirements.txt file to be used with a virtual environment and pip is included.  

The config\_geoserver.py and config\_geoserver\_vars.py python script and variables files use the [gsconfig](https://github.com/boundlessgeo/gsconfig) python package to configure geoserver through its REST configuration API. The config\_geoserver\_vars.py file contains default variables that need to be changed depending on the environment this will be run under.  

A geoserver.war at version 2.6.2 is required for this. It should be deployed in a Tomcat container per normal geoserver deployment methods.
