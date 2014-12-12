# OXID shell install script

Install an OXID eShop within 30 seconds on your server ...
	 

##Installation

download ps_oxid-installer.sh

`curl -O https://raw.githubusercontent.com/proudcommerce/oxid-installer/master/pc_oxid-installer.sh`

set executable rights

`chmod 777 pc_oxid-installer.sh`

start script

`sh pc_oxid-installer.sh`

##Alternate Installation (Run from the web directly)

`bash <(curl -s https://raw.githubusercontent.com/proudcommerce/oxid-installer/master/pc_oxid-installer.sh)`


## How to use

    1/11 | enter shop version [CE-4.9.2]:
    2/11 | enter install directory [/var/www/CE-4.9.2]:
    3/11 | enter shop url [http://yourshop.tld]: 
    4/11 | enter shop subdirectory url [/]: 
    5/11 | set shop utf8 mode [false]:
    6/11 | install shop demodata [true]:
    7/11 | enter mysql database host [localhost]:
    8/11 | enter mysql database user [root]:
    9/11 | enter mysql database password [6fw8iOP3V4aISRDL8Kqp]:
    10/11 | enter mysql database name [ce492]:
    11/11 | install ioly module manager [true]:

##Changelog

    1.0.0 - 2014-12-12 - release
	
	
##License

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    

##Copyright

	Proud Sourcing GmbH 2014
	www.proudcommerce.com
