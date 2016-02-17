#!venv/bin python

from geoserver.catalog import Catalog
import sys
import config_geoserver_vars

native_crs='EPSG:4269'
declared_crs='EPSG:4269'
dbFeatures=[{'name':'catchmentsp', 'styles':['polygon'], 'abstract':'test test test'},
            {'name':'catchment', 'styles':['polygon'], 'abstract':'test test test'},
            {'name':'gage','styles':['point'], 'abstract':'test test test'},
            {'name':'nhdflowline_network','styles':['line'], 'abstract':'test test test'},
            {'name':'nhdflowline_nonnetwork','styles':['line'], 'abstract':'test test test'},
            {'name':'huc12','styles':['polygon'], 'abstract':'test test test'},
            {'name':'sink','styles':['point'], 'abstract':'test test test'},
            {'name':'landsea','styles':['polygon'], 'abstract':'test test test'},
            {'name':'nhdwaterbody','styles':['polygon'], 'abstract':'test test test'},
            {'name':'nhdarea','styles':['polygon'], 'abstract':'test test test'},
            {'name':'nhdpoint','styles':['point'], 'abstract':'test test test'},
            {'name':'nhdline','styles':['line'], 'abstract':'test test test'}]

cat = Catalog(restURL, restUser, restPass)

try:
    ws = cat.create_workspace(workspace, workspaceURI)
except Exception, e:
    print "Error: %s" % e
    ws = cat.get_workspace(workspace)

ds = cat.create_datastore(storeName)

ds.connection_parameters.update(
    host=host,
    port=port,
    database=database,
    user=user,
    password=password,
    dbtype=dbtype)

try:
    cat.save(ds)
except Exception, e:
    print "Error: %s" % e

ds = cat.get_store(storeName)

for feature in dbFeatures:
    try:
        ft = cat.publish_featuretype(feature['name'], ds, native_crs, declared_crs)
    except Exception, e:
        print "Error: %s" % e
    lr = cat.get_layer(feature['name'])
    lr.default_style=feature['styles'][0]
    try:
        cat.save(lr)
    except Exception, e:
        print "Error: %s" % e