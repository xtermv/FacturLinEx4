#!/bin/bash
# -*- ENCODING: UTF-8 -*-
su
cd /var/lib/mysql/$3
/etc/init.d/mysql stop
tar cvfz cpsegfl2_$1.tgz * 
chmod 666 cpsegfl2_$1.tgz
/etc/init.d/mysql start
mkdir $2/cseg
chmod 777 $2/cseg
mv cpsegfl2_$1.tgz $2/cseg
cd $2
exit

