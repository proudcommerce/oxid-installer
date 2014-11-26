#!/bin/sh
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# @copyright (c) Proud Sourcing GmbH | 2014
# @link www.proudcommerce.com
# @package oxid-installer
# @version 1.0.0
# 
 
shop_source="https://github.com/proudcommerce/oxid-downloads.git"
shop_version="CE-4.9.2"
shop_dir=""
shop_tmp="$shop_dir/tmp"
shop_url=""
shop_url_dir="ce492/"
shop_demotdata=true
shop_utf8=0

db_host="localhost"
db_user="root"
db_pass=""
db_name=""

echo "----------"
echo "### create directory $shop_dir/"
mkdir $shop_dir
echo "----------"

echo "----------"
echo "### clone $shop_source to $shop_dir"
echo "----------"
cd $shop_dir && git clone $shop_source $shop_dir

echo "----------"
echo "### checkout branch $shop_version"
echo "----------"
cd $shop_dir && git checkout $shop_version

echo "----------"
echo "### set file and folder permissions (1/2)"
echo "----------"
cd $shop_dir && chmod -R 777 out/pictures/ out/media/ log/ tmp/ export/ && chmod 666 .htaccess config.inc.php

echo "----------"
echo "### create oxid database tables"
echo "----------"
cd $shop_dir && mysql -h$db_host -u$db_user -p$db_pass $db_name < setup/sql/database.sql

if [ $shop_utf8 = 1 ]
then
	echo "----------"
	echo "### setting database tu utf8"
	echo "----------"
	cd $shop_dir && mysql -h$db_host -u$db_user -p$db_pass $db_name < setup/sql/latin1_to_utf8.sql
fi

if [ $shop_demotdata = true ]
then
	echo "----------"
	echo "### insert demodata into database"
	echo "----------"
	cd $shop_dir && mysql -h$db_host -u$db_user -p$db_pass $db_name < setup/sql/demodata.sql
fi

echo "----------"
echo "### write config.inc.php and .htaccess"
echo "----------"
cd $shop_dir && sed -i "s|<dbHost_ce>|$db_host|g" "config.inc.php" && sed -i "s|<dbName_ce>|$db_name|g" "config.inc.php" && sed -i "s|<dbUser_ce>|$db_user|g" "config.inc.php" && sed -i "s|<dbPwd_ce>|$db_pass|g" "config.inc.php" && sed -i "s|<sShopURL_ce>|"$shop_url"/"$shop_url_dir"|g" "config.inc.php" && sed -i "s|<sShopDir_ce>|$shop_dir|g" "config.inc.php" && sed -i "s|<sCompileDir_ce>|$shop_tmp|g" "config.inc.php" && sed -i "s|<iUtfMode>|$shop_utf8|g" "config.inc.php"
cd $shop_dir && sed -i "s|RewriteBase /|RewriteBase /$shop_url_dir|g" ".htaccess" 

echo "----------"
echo "### remove setup and documentation dir"
echo "----------"
cd $shop_dir && rm -rf setup/ documentation/

echo "----------"
echo "### set file and folder permissions (2/2)"
echo "----------"
cd $shop_dir; chmod 444 .htaccess config.inc.php

echo "----------"
echo "### installation done"
echo "----------"
echo "shop url: $shop_url"
echo "shop admin url: "$shop_url"/"$shop_url_dir"admin"
echo "shop admin user: admin"
echo "shop admin password: admin"

