#!/bin/sh
set -x

mkdir -p /etc/supervisor/conf.d
mkdir -p /run/php

/scripts/mariadb.sh

#Do the app specific stuff here!
if [ ! -f /etc/app_configured ]; then
    # Remove the default index
    rm -fr /var/www/html/index.php

cat << EOF >> /var/www/html/index.php
<?php
echo "<h1>Welcome to your new webserver with MariaDB!</h1>";
?>
EOF

    #Tell Apex we're done installing.
    curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST "https://api.cylo.io/v1/apps/installed/$INSTANCE_ID"
    touch /etc/app_configured
fi

exec "$@"