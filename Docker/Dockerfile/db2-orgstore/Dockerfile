# This Docker creates a db2instance for orgstore
#
# Version: 2018-01-28
# Author: Robin (yilubj@cn.ibm.com)
# Made in China.

FROM angoca/db2-install:ese-11.1

LABEL maintainer="yilubj@cn.ibm.com" 


# Set of variables to define the type of DB2 being installed.

## Script to create the instance
ENV DB2_INST_CREA_SCR=createInstance \
## Directory for all scripts.
    DB2_CONF=/tmp/db2_conf \
## Response file name
    DB2_RESP_FILE=db2server_t_instance.rsp \
## Port number for Db2
    PORT=50000 \
## Default instance name
    DEFAULT_INSTANCE_NAME=db2inst1 \
## Default dbuser name
    DEFAULT_DB_USER=wcsdb \
## Default dbuser passwd
    DEFAULT_DB_PASSWD=passw0rd

WORKDIR ${DB2_CONF}

ARG INSTANCE_NAME=${DEFAULT_INSTANCE_NAME}



RUN ${DB2_CONF}/${DB2_INST_CREA_SCR} ${INSTANCE_NAME} && \
# Modifies the db2nodes file to include a valid name.
  cat /home/${INSTANCE_NAME}/sqllib/db2nodes.cfg && \
  echo "0 localhost 0" > /home/${INSTANCE_NAME}/sqllib/db2nodes.cfg && \
  cat /home/${INSTANCE_NAME}/sqllib/db2nodes.cfg && \
  groupadd -g 997 dasadm1 && \
  useradd -u 1002 -g dasadm1 -m -d /home/${DEFAULT_DB_USER} ${DEFAULT_DB_USER} && \
  echo "${DEFAULT_DB_USER}:${DEFAULT_DB_PASSWD}" | chpasswd 




USER ${INSTANCE_NAME}

WORKDIR /home/${INSTANCE_NAME}

COPY ./create_database_db2.sh /home/${INSTANCE_NAME}

EXPOSE ${PORT}