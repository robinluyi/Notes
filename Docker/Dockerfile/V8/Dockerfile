# This Docker creates a db2instance for orgstore
#
# Version: 2018-01-28
# Author: Robin (yilubj@cn.ibm.com)
# Made in China.

FROM angoca/db2inst1:ese

LABEL maintainer="yilubj@cn.ibm.com" 

## Default dbuser name
ENV     DEFAULT_DB_USER=wcsdb \
## Default dbuser passwd
        DEFAULT_DB_PASSWD=Passw0rd

COPY entrypoint.sh /home/db2inst1/entrypoint.sh
COPY create_database_db2.sh /home/db2inst1/create_database_db2.sh
COPY db2ese_o.lic /home/db2inst1/db2ese_o.lic

USER root
RUN   groupadd -g 997 dasadm1 && \
  useradd -u 1002 -g dasadm1 -m -d /home/${DEFAULT_DB_USER} ${DEFAULT_DB_USER} && \
  echo "${DEFAULT_DB_USER}:${DEFAULT_DB_PASSWD}" | chpasswd  && \
  echo "db2inst1:Passw0rd" | chpasswd && \
  chmod +x /home/db2inst1/entrypoint.sh && \
  chmod +x /home/db2inst1/create_database_db2.sh 

WORKDIR /home/db2inst1

USER db2inst1 

#db2licm -a /home/db2inst1/db2ese_o.lic 
#db2start 
#/home/db2inst1/create_database_db2.sh devqa db2inst1 Passw0rd Passw0rd 



EXPOSE 50000

#Start the DB2 server and print out the diag log 
#ENTRYPOINT ["/bin/bash","/home/db2inst1/entrypoint.sh" ] 
#CMD [ "start" ]d
CMD tail -F /home/db2inst1/sqllib/db2dump/db2diag.log 
