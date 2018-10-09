
FROM ubuntu:16.04

# MicroBadge
ARG VCS_REF

RUN groupadd -g 997 dasadm1 &&\ 
    useradd -u 1002 -g dasadm1 -m -d /home/wcsdb wcsdb &&\
    echo "wcsdb:passw0rd" | chpasswd
