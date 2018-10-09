# Learn Shell

# Version: 2018-01-28
# Author: Robin 
# Made in China.

FROM busybox:latest

ENV DEFAULT_DB_PASSWD=passw0rd


RUN   echo "root:${DEFAULT_DB_PASSWD}" | chpasswd 
RUN   cat /etc/passwd
RUN   grep root /etc/passwd
RUN   echo "abc" > a.txt
RUN   cp -iv a.txt b.txt
RUN   cat b.txt
