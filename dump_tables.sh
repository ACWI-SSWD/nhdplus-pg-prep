username=$1
password=$2
host=$3
db=$4
check=$5

if [ -z "$db" ]; then
     echo "You must pass in four variables, admin username, password, host, and database name."
     exit
fi

if [ -n "$check" ]; then
    echo "You must pass in four variables, admin username, password, host, and database name."
    exit
fi

pg_dump -t gage postgresql://$username:$password@$host/$db -O --file="dumps/gage.pgdump"

pg_dump -t sink postgresql://$username:$password@$host/$db -O --file="dumps/sink.pgdump"

pg_dump -t landsea postgresql://$username:$password@$host/$db -O --file="dumps/landsea.pgdump"

pg_dump -t nhdwaterbody postgresql://$username:$password@$host/$db -O --file="dumps/nhdwaterbody.pgdump"

pg_dump -t nhdarea postgresql://$username:$password@$host/$db -O --file="dumps/nhdarea.pgdump"

pg_dump -t nhdflowline_network postgresql://$username:$password@$host/$db -O --file="dumps/nhdflowline_network.pgdump"

pg_dump -t nhdflowline_nonnetwork postgresql://$username:$password@$host/$db -O --file="dumps/nhdflowline_nonnetwork.pgdump"

pg_dump -t huc12 postgresql://$username:$password@$host/$db -O --file="dumps/huc12.pgdump"

pg_dump -t catchmentsp postgresql://$username:$password@$host/$db -O --file="dumps/catchmentsp.pgdump"

pg_dump -t catchment postgresql://$username:$password@$host/$db -O --file="dumps/catchment.pgdump"

pg_dump -t nhdwaterbody postgresql://$username:$password@$host/$db -O --file="dumps/nhdwaterbody.pgdump"

pg_dump -t nhdpoint postgresql://$username:$password@$host/$db -O --file="dumps/nhdpoint.pgdump"

pg_dump -t nhdline postgresql://$username:$password@$host/$db -O --file="dumps/nhdline.pgdump"

for file in dumps/*.pgdump; do gzip $file; done;