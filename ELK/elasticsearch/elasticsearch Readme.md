# run
su elk
chown -R elk /var/log/elasticsearch
/usr/share/elasticsearch/bin/elasticsearch 

network.publish_host

# config file location
config directory location defaults to /etc/elasticsearch
edit /etc/sysconfig/elasticsearch
change ES_PATH_CONF=/etc/elasticsearch


# ulimit

vi /etc/security/limits.conf
elk              hard    nofile          65535
elk              hard    noproc          65535
elk              soft memlock unlimited
elk              hard memlock unlimited


add ulimit  -n  65535 to /etc/profil
source /etc/profile

# follow the log