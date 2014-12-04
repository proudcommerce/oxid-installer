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


# shop source (git repo)
shop_source="https://github.com/proudcommerce/oxid-downloads.git"

# shop version (git branch)
shop_version="CE-4.9.2"
read -p "1/11 | enter shop version [$shop_version]: " shop_version_i
if [ -n "$shop_version_i" ]
then
  shop_version="$shop_version_i"
fi

# shop install directory
shop_dir=`pwd`/$shop_version
read -p "2/11 | enter install directory [$shop_dir]: " shop_dir_i
if [ -n "$shop_dir_i" ]
then
  shop_dir="$shop_dir_i"
fi

# shop url
shop_url="http://yourshop.tld/ (subdirectory configuration in 4/12)"
read -p "3/11 | enter shop url [$shop_url]: " shop_url_i
if [ -n "$shop_url_i" ]
then
  shop_url="$shop_url_i"
fi

# shop url subdirectory
shop_url_dir="ce492/"
read -p "4/11 | enter shop subdirectory url [$shop_url_dir]: " shop_url_dir_i
if [ -n "$shop_url_dir_i" ]
then
  shop_url_dir="$shop_url_dir_i"
fi

# shop utf8 mode
shop_utf8=false
shop_utf8_config=0
read -p "5/11 | set shop utf8 mode [$shop_utf8]: " shop_utf8_i
if [ -n "$shop_utf8_i" ]
then
  shop_utf8="$shop_utf8_i"
  shop_utf8_config=1
fi

# shop demodata
shop_demotdata=true
read -p "6/11 | install shop demodata [$shop_demotdata]: " shop_demotdata_i
if [ -n "$shop_demotdata_i" ]
then
  shop_demotdata="$shop_demotdata_i"
fi

# shop database host
db_host="localhost"
read -p "7/11 | enter mysql database host [$db_host]: " db_host_i
if [ -n "$db_host_i" ]
then
  db_host="$db_host_i"
fi

# shop database user
db_user="youruser"
read -p "8/11 | enter mysql database user [$db_user]: " db_user_i
if [ -n "$db_user_i" ]
then
  db_user="$db_user_i"
fi

# shop database password
db_pass="yourpassword"
read -p "9/11 | enter mysql database password [$db_pass]: " db_pass_i
if [ -n "$db_pass_i" ]
then
  db_pass="$db_pass_i"
fi

# shop database name
db_name="yourdbname"
read -p "10/11 | enter mysql database name [$db_name]: " db_name_i
if [ -n "$db_name_i" ]
then
  db_name="$db_name_i"
fi

# ioly module manager
install_ioly=false
read -p "11/11 | install ioly module manager [$install_ioly]: " install_ioly_i
if [ -n "$install_ioly_i" ]
then
  install_ioly="$install_ioly_i"
fi

# shop tmp directory
shop_tmp="$shop_dir/tmp"


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

if [ $shop_utf8 = true ]
then
	echo "----------"
	echo "### setting database tu utf8"
	echo "----------"
	cd $shop_dir && mysql -h$db_host -u$db_user -p$db_pass $db_name < setup/sql/latin1_to_utf8.sql
	shop_utf8_config=1
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
cd $shop_dir && sed -i "s|<dbHost_ce>|$db_host|g" "config.inc.php" && sed -i "s|<dbName_ce>|$db_name|g" "config.inc.php" && sed -i "s|<dbUser_ce>|$db_user|g" "config.inc.php" && sed -i "s|<dbPwd_ce>|$db_pass|g" "config.inc.php" && sed -i "s|<sShopURL_ce>|"$shop_url"/"$shop_url_dir"|g" "config.inc.php" && sed -i "s|<sShopDir_ce>|$shop_dir|g" "config.inc.php" && sed -i "s|<sCompileDir_ce>|$shop_tmp|g" "config.inc.php" && sed -i "s|<iUtfMode>|$shop_utf8_config|g" "config.inc.php"
cd $shop_dir && sed -i "s|RewriteBase /|RewriteBase /$shop_url_dir|g" ".htaccess" 

echo "----------"
echo "### remove setup and documentation dir"
echo "----------"
cd $shop_dir && rm -rf setup/ documentation/

echo "----------"
echo "### set file and folder permissions (2/2)"
echo "----------"
cd $shop_dir; chmod 444 .htaccess config.inc.php

if [ $install_ioly = true ]
then
	echo "----------"
	echo "### install ioly module manager"
	echo "----------"
	cd $shop_dir && mkdir ioly && chmod 777 ioly/
fi

echo "----------"
echo "### installation done"
echo "----------"
echo "shop url: $shop_url"
echo "shop admin url: "$shop_url"/"$shop_url_dir"admin"
echo "shop admin user: admin"
echo "shop admin password: admin"

