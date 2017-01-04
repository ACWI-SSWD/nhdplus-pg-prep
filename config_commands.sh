username=$1
password=$2
host=$3
db=$4
owner=$5
ownerpass=$6
check=$7

if [ -z "$ownerpass" ]; then
     echo "You must pass in six variables, admin username, password, host, database name, database owner, and a database owner password."
     exit
fi

if [ -n "$check" ]; then
    echo "You must pass in six variables, admin username, password, host, database name, database owner, and a database owner password."
    exit
fi
if [-e NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb ]; then
  echo "Found NHDPlusV21_National_Seamless.gdb geo database"
else
  echo "Didn't find NHDPlusV21_National_Seamless.gdb in NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb. Download the National Seamless Geodatabase from: https://www.epa.gov/waterdata/nhdplus-national-data and extract to the current working directory."
fi

echo Create new database role for tables
psql -c "CREATE ROLE $owner LOGIN PASSWORD '$ownerpass' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;" postgresql://$username:$password@$host:5432/

echo Create database 
psql -c "CREATE DATABASE \"$db\" WITH OWNER = \"$owner\";" postgresql://$username:$password@$host:5432/

echo Add postgis extensions
psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" postgresql://$username:$password@$host:5432/$db

echo Insert Gages into Database as gage.
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "gage" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb Gage

echo Index Gages.
psql -c "CREATE INDEX ON gage (flcomid); CREATE INDEX ON gage (reachcode); CREATE INDEX ON gage (eventdate); CREATE INDEX ON gage (reachsmdat); CREATE INDEX ON gage (reachresol); CREATE INDEX ON gage (measure); CREATE INDEX ON gage (eventtype); CREATE INDEX ON gage (state); CREATE INDEX ON gage (dasqkm);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert Sink as sink
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "sink" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb Sink

echo Index sink
psql -c "CREATE INDEX ON sink (SINKID); CREATE INDEX ON sink (PURPCODE); CREATE INDEX ON sink (PURPDESC); CREATE INDEX ON sink (FEATUREID); CREATE INDEX ON sink (SOURCEFC); CREATE INDEX ON sink (GridCode); CREATE INDEX ON sink (InRPU); CREATE INDEX ON sink (Catchment); CREATE INDEX ON sink (Burn);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert LandSea as landsea
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "landsea" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb LandSea

echo Index landsea
psql -c "CREATE INDEX ON landsea (LANDSEAID); CREATE INDEX ON landsea (LAND);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert NHDWaterbody as nhdwaterbody
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "nhdwaterbody" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb NHDWaterbody

echo Index nhdwaterbody
psql -c "CREATE INDEX ON nhdwaterbody (COMID); CREATE INDEX ON nhdwaterbody (FDATE); CREATE INDEX ON nhdwaterbody (RESOLUTION); CREATE INDEX ON nhdwaterbody (GNIS_ID); CREATE INDEX ON nhdwaterbody (GNIS_NAME); CREATE INDEX ON nhdwaterbody (AREASQKM); CREATE INDEX ON nhdwaterbody (ELEVATION); CREATE INDEX ON nhdwaterbody (REACHCODE); CREATE INDEX ON nhdwaterbody (FTYPE); CREATE INDEX ON nhdwaterbody (FCODE); CREATE INDEX ON nhdwaterbody (ONOFFNET); CREATE INDEX ON nhdwaterbody (PurpCode); CREATE INDEX ON nhdwaterbody (PurpDesc);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert NHDArea as nhdarea
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "nhdarea" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb NHDArea

echo Index nhdarea
psql -c "CREATE INDEX ON nhdarea (COMID); CREATE INDEX ON nhdarea (FDATE); CREATE INDEX ON nhdarea (RESOLUTION); CREATE INDEX ON nhdarea (GNIS_ID); CREATE INDEX ON nhdarea (GNIS_NAME); CREATE INDEX ON nhdarea (AREASQKM); CREATE INDEX ON nhdarea (ELEVATION); CREATE INDEX ON nhdarea (FTYPE); CREATE INDEX ON nhdarea (FCODE); CREATE INDEX ON nhdarea (ONOFFNET); CREATE INDEX ON nhdarea (PurpCode); CREATE INDEX ON nhdarea (PurpDesc);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert NHDFlowline_Network as nhdflowline_network
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "nhdflowline_network" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb NHDFlowline_Network

echo Index nhdflowline_network
psql -c "CREATE INDEX ON nhdflowline_network (COMID); CREATE INDEX ON nhdflowline_network (FDATE); CREATE INDEX ON nhdflowline_network (RESOLUTION); CREATE INDEX ON nhdflowline_network (GNIS_ID); CREATE INDEX ON nhdflowline_network (GNIS_NAME); CREATE INDEX ON nhdflowline_network (LENGTHKM); CREATE INDEX ON nhdflowline_network (REACHCODE); CREATE INDEX ON nhdflowline_network (FLOWDIR); CREATE INDEX ON nhdflowline_network (WBAREACOMI); CREATE INDEX ON nhdflowline_network (FTYPE); CREATE INDEX ON nhdflowline_network (FCODE); CREATE INDEX ON nhdflowline_network (StreamLeve); CREATE INDEX ON nhdflowline_network (StreamOrde); CREATE INDEX ON nhdflowline_network (StreamCalc); CREATE INDEX ON nhdflowline_network (FromNode); CREATE INDEX ON nhdflowline_network (ToNode); CREATE INDEX ON nhdflowline_network (Hydroseq); CREATE INDEX ON nhdflowline_network (LevelPathI); CREATE INDEX ON nhdflowline_network (Pathlength); CREATE INDEX ON nhdflowline_network (TerminalPa); CREATE INDEX ON nhdflowline_network (ArbolateSu); CREATE INDEX ON nhdflowline_network (Divergence); CREATE INDEX ON nhdflowline_network (StartFlag); CREATE INDEX ON nhdflowline_network (TerminalFl); CREATE INDEX ON nhdflowline_network (DnLevel); CREATE INDEX ON nhdflowline_network (UpLevelPat); CREATE INDEX ON nhdflowline_network (UpHydroseq); CREATE INDEX ON nhdflowline_network (DnLevelPat); CREATE INDEX ON nhdflowline_network (DnMinorHyd); CREATE INDEX ON nhdflowline_network (DnDrainCou); CREATE INDEX ON nhdflowline_network (DnHydroseq); CREATE INDEX ON nhdflowline_network (FromMeas); CREATE INDEX ON nhdflowline_network (ToMeas); CREATE INDEX ON nhdflowline_network (RtnDiv); CREATE INDEX ON nhdflowline_network (VPUIn); CREATE INDEX ON nhdflowline_network (VPUOut); CREATE INDEX ON nhdflowline_network (AreaSqKM); CREATE INDEX ON nhdflowline_network (TotDASqKM); CREATE INDEX ON nhdflowline_network (DivDASqKM); CREATE INDEX ON nhdflowline_network (HWNodeSqKM); CREATE INDEX ON nhdflowline_network (MAXELEVRAW); CREATE INDEX ON nhdflowline_network (MINELEVRAW); CREATE INDEX ON nhdflowline_network (MAXELEVSMO); CREATE INDEX ON nhdflowline_network (MINELEVSMO); CREATE INDEX ON nhdflowline_network (SLOPE); CREATE INDEX ON nhdflowline_network (ELEVFIXED); CREATE INDEX ON nhdflowline_network (HWTYPE); CREATE INDEX ON nhdflowline_network (SLOPELENKM); CREATE INDEX ON nhdflowline_network (V0001A); CREATE INDEX ON nhdflowline_network (Qincr0001A); CREATE INDEX ON nhdflowline_network (Q0001B); CREATE INDEX ON nhdflowline_network (V0001B); CREATE INDEX ON nhdflowline_network (Qincr0001B); CREATE INDEX ON nhdflowline_network (Q0001C); CREATE INDEX ON nhdflowline_network (V0001C); CREATE INDEX ON nhdflowline_network (Qincr0001C); CREATE INDEX ON nhdflowline_network (Q0001D); CREATE INDEX ON nhdflowline_network (V0001D); CREATE INDEX ON nhdflowline_network (Qincr0001D); CREATE INDEX ON nhdflowline_network (Q0001E); CREATE INDEX ON nhdflowline_network (V0001E); CREATE INDEX ON nhdflowline_network (Qincr0001E); CREATE INDEX ON nhdflowline_network (Q0001F); CREATE INDEX ON nhdflowline_network (Qincr0001F); CREATE INDEX ON nhdflowline_network (ARQ0001NAV); CREATE INDEX ON nhdflowline_network (TEMP0001); CREATE INDEX ON nhdflowline_network (PPT0001); CREATE INDEX ON nhdflowline_network (PET0001); CREATE INDEX ON nhdflowline_network (QLOSS0001); CREATE INDEX ON nhdflowline_network (QG0001ADJ); CREATE INDEX ON nhdflowline_network (QG0001NAV); CREATE INDEX ON nhdflowline_network (LAT); CREATE INDEX ON nhdflowline_network (Gageadj); CREATE INDEX ON nhdflowline_network (avgqadj); CREATE INDEX ON nhdflowline_network (SMGageID); CREATE INDEX ON nhdflowline_network (SMgageq); CREATE INDEX ON nhdflowline_network (ETFRACT1); CREATE INDEX ON nhdflowline_network (ETFRACT2); CREATE INDEX ON nhdflowline_network (a); CREATE INDEX ON nhdflowline_network (b); CREATE INDEX ON nhdflowline_network (BCF); CREATE INDEX ON nhdflowline_network (r2); CREATE INDEX ON nhdflowline_network (SER); CREATE INDEX ON nhdflowline_network (NRef); CREATE INDEX ON nhdflowline_network (gageseqp); CREATE INDEX ON nhdflowline_network (gageseq); CREATE INDEX ON nhdflowline_network (RPUID); CREATE INDEX ON nhdflowline_network (Shape_Length);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert NHDFlowline_NonNetwork as nhdflowline_nonnetwork
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "nhdflowline_nonnetwork" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb NHDFlowline_NonNetwork

echo Index nhdflowline_nonnetwork
psql -c "CREATE INDEX ON nhdflowline_nonnetwork (COMID); CREATE INDEX ON nhdflowline_nonnetwork (FDATE); CREATE INDEX ON nhdflowline_nonnetwork (RESOLUTION); CREATE INDEX ON nhdflowline_nonnetwork (GNIS_ID); CREATE INDEX ON nhdflowline_nonnetwork (GNIS_NAME); CREATE INDEX ON nhdflowline_nonnetwork (LENGTHKM); CREATE INDEX ON nhdflowline_nonnetwork (REACHCODE); CREATE INDEX ON nhdflowline_nonnetwork (FLOWDIR); CREATE INDEX ON nhdflowline_nonnetwork (WBAREACOMI); CREATE INDEX ON nhdflowline_nonnetwork (FTYPE); CREATE INDEX ON nhdflowline_nonnetwork (FCODE);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert HUC12 as huc12
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "huc12" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb HUC12

echo Index huc12
psql -c "CREATE INDEX ON huc12 (HUC_8); CREATE INDEX ON huc12 (HUC_10); CREATE INDEX ON huc12 (HUC_12); CREATE INDEX ON huc12 (ACRES); CREATE INDEX ON huc12 (NCONTRB_A); CREATE INDEX ON huc12 (HU_10_GNIS); CREATE INDEX ON huc12 (HU_12_GNIS); CREATE INDEX ON huc12 (HU_10_NAME); CREATE INDEX ON huc12 (HU_10_MOD); CREATE INDEX ON huc12 (HU_10_TYPE); CREATE INDEX ON huc12 (HU_12_DS); CREATE INDEX ON huc12 (HU_12_NAME); CREATE INDEX ON huc12 (HU_12_MOD); CREATE INDEX ON huc12 (HU_12_TYPE); CREATE INDEX ON huc12 (META_ID); CREATE INDEX ON huc12 (STATES); CREATE INDEX ON huc12 (GlobalID); CREATE INDEX ON huc12 (SHAPE_Leng); CREATE INDEX ON huc12 (GAZ_ID); CREATE INDEX ON huc12 (WBD_Date); CREATE INDEX ON huc12 (VPUID); CREATE INDEX ON huc12 (HUC_2); CREATE INDEX ON huc12 (HUC_4); CREATE INDEX ON huc12 (HUC_6);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert Simplified Catchments into Database as Catchmentsp.
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "catchmentsp" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb CatchmentSP

echo Index CatchmentSP.
psql -c "CREATE INDEX ON catchmentsp (FEATUREID); CREATE INDEX ON catchmentsp (GRIDCODE); CREATE INDEX ON catchmentsp (AreaSqKM); CREATE INDEX ON catchmentsp (SOURCEFC);" postgresql://$owner:$ownerpass@$host:5432/$db

echo Insert Catchments into Database as Catchment.
ogr2ogr -overwrite -progress -f "PostGreSQL" PG:"host=$host user=$owner password=$ownerpass dbname=$db" -nln "catchment" -nlt PROMOTE_TO_MULTI -lco "GEOMETRY_NAME=the_geom" -lco "PRECISION=NO" -a_srs "EPSG:4269"   NHDPlusNationalData/NHDPlusV21_National_Seamless.gdb Catchment

echo Index Catchments.
psql -c "CREATE INDEX ON catchment (FEATUREID); CREATE INDEX ON catchment (GRIDCODE); CREATE INDEX ON catchment (AreaSqKM); CREATE INDEX ON catchment (SOURCEFC);" postgresql://$owner:$ownerpass@$host:5432/$db
