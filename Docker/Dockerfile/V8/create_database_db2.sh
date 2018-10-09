#!/bin/sh

# -----------------------------------------------------------------
#  Licensed Materials - Property of IBM
#
#  WebSphere Commerce
#
#  (C) Copyright IBM Corp. 2017 All Rights Reserved.
#
#  US Government Users Restricted Rights - Use, duplication or
#  disclosure restricted by GSA ADP Schedule Contract with
#  IBM Corp.
# -----------------------------------------------------------------

if [ $# -lt 4 ]
then
	echo "Usage: $0 <dbName> <dbaUser> <dbaPassword> <dbUser>"
	echo
	echo "Example: $0 mall db2inst1 diet4coke wcs"
	echo
	echo "Parameter options :"
	echo  "1 <dbName> - database name"
	echo  "2 <dbaUser> - dba user name"
	echo  "3 <dbaPassword> - dba user password"
	echo  "4 <dbUser> - db user name"
	echo
   exit 1
fi

echo "Starting DB2 server"
s=1
while [ $s -eq 0 ]; do
	/bin/su -c "db2start" - db2inst1
	rc=$?
	if [ $rc -eq 4 ]; then
		exit 1
	fi
	if [ $rc -eq 28 ]; then
		# Code 28 seems to indicate that a DB2 start is still
		# in progress.  Sleep and then retry
		sleep 10
	else
		s=1
	fi
done

# end with failure
endfailure() {
	if [ -n "$1" ]; then
		echo -e $1
	fi
	echo "Error creating database."
	echo "Createdb stopped with error at: $(date +%F-%H.%M.%S.%6N)."
	exit 1
}
#End when return value is error or warning
endfailureWithError(){
	if [ $1 != 0 ] && [ $1 != 2 ]; then
		endfailure
	fi
}

#End when return value is error or warning
endfailureWithErrorAndWarning(){
	if [ $1 != 0 ]; then
		endfailure
	fi
}

updateDBConfiguration(){
	#udpate database configuration
	db2 update database configuration for $DATABASE_NAME using locklist 2400 AUTOMATIC
	endfailureWithError $?

	db2 update database configuration for $DATABASE_NAME using indexrec RESTART
	endfailureWithError $?

	db2 update database configuration for $DATABASE_NAME using logfilsiz 8192
	endfailureWithError $?

	db2 update database configuration for $DATABASE_NAME using logprimary 12
	endfailureWithError $?

	db2 update database configuration for $DATABASE_NAME using logsecond 10
	endfailureWithError $?

	db2 update database configuration for $DATABASE_NAME using pckcachesz 16384 AUTOMATIC
	endfailureWithError $?

	db2 update database configuration for $DATABASE_NAME using catalogcache_sz 16384
	endfailureWithError $?

	db2 update database configuration for $DATABASE_NAME using locktimeout 45
	endfailureWithError $?

	db2set DB2_WORKLOAD=WC
	endfailureWithError $?

	db2set DB2BIDI=yes
	endfailureWithError $?

	db2 update dbm cfg using cpuspeed -1
	endfailureWithError $?
}

createBufferPool(){
	db2 alter bufferpool IBMDEFAULTBP deferred SIZE 10000 AUTOMATIC
	endfailureWithError $?

	db2 CREATE bufferpool BUFF8K deferred SIZE 5000 AUTOMATIC PAGESIZE 8 K
	endfailureWithError $?

	db2 CREATE bufferpool BUFF16K deferred SIZE 5000 AUTOMATIC PAGESIZE 16 K
	endfailureWithError $?

	db2 CREATE bufferpool BUFF32K deferred SIZE 2500 AUTOMATIC PAGESIZE 32 K
	endfailureWithError $?

	#table space
	db2 CREATE REGULAR TABLESPACE TAB8K PAGESIZE 8 K BUFFERPOOL BUFF8K
	endfailureWithErrorAndWarning $?

	db2 CREATE REGULAR TABLESPACE TAB16K PAGESIZE 16 K BUFFERPOOL BUFF16K
	endfailureWithErrorAndWarning $?

	db2 CREATE  SYSTEM TEMPORARY  TABLESPACE TEMPSYS8K PAGESIZE 8 K  BUFFERPOOL BUFF8K
	endfailureWithError $?

	db2 CREATE  SYSTEM TEMPORARY  TABLESPACE TEMPSYS16K PAGESIZE 16 K BUFFERPOOL BUFF16K
	endfailureWithError $?

	db2 CREATE  SYSTEM TEMPORARY  TABLESPACE TEMPSYS32K PAGESIZE 32 K BUFFERPOOL BUFF32K
	endfailureWithError $?
}

#grant access to dbuser
grantAccess(){
	db2 grant bindadd, connect, createtab, implicit_schema on database to user $DB_USER
	endfailureWithError $?

	db2 grant use of tablespace tab8k to user $DB_USER
	endfailureWithError $?

	db2 grant use of tablespace tab16k to user $DB_USER
	endfailureWithError $?
}

DATABASE_NAME=$1
DBA_USER=$2
DBA_PASSWORD=$3
DB_USER=$4

#create database
db2 create database $DATABASE_NAME using codeset UTF-8 territory US
endfailureWithErrorAndWarning $?

#connect to database
db2 connect to $DATABASE_NAME user $DBA_USER using $DBA_PASSWORD
endfailureWithErrorAndWarning $?


updateDBConfiguration

createBufferPool

grantAccess

db2 connect reset
endfailureWithError $?
