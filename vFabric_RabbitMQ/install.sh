#!/bin/sh
set -e

export rabbitmq_node_ip=$(hostname -I)
export rhel_repo=http://mirror.centos.org/centos/5/os
export rabbitmq_node_port=5672
export install_tar=https://vra7cafe.virtualiseme.com.au/artifactory/nanotrader/vfabric-rabbit-install-2.4.1.tar.gz

export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export HOME=/root
export https_proxy=$http_proxy

wget --no-check-certificate $install_tar
mv vfabric-rabbit-install-2.4.1.tar.gz /tmp
export install_tar=/tmp/vfabric-rabbit-install-2.4.1.tar.gz

proxy_host=`echo $http_proxy | sed -e 's_http://__' -e 's/:.*//'`
proxy_port=`echo $http_proxy | sed  -e 's/.*://'`

if [ ! $proxy_host == "" ]; then
    echo "setting http proxy macro in /usr/lib/rpm/macros"
    echo "" >>  /usr/lib/rpm/macros
    echo "%_httpproxy $proxy_host" >> /usr/lib/rpm/macros
fi

if [ ! $proxy_port == "" ]; then
    echo "setting http port macro in /usr/lib/rpm/macros"
    echo "" >>  /usr/lib/rpm/macros
    echo "%_httpport $proxy_port" >> /usr/lib/rpm/macros
fi

#Start checking OS type
echo "Starting OS check"
KERNEL=`uname -r`
MACH=`uname -m`

   DistroBasedOn='RedHat'
   DIST=`cat /etc/redhat-release |sed s/\ release.*//`
   #REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
   REV="6"

       
       cd `dirname $install_tar`
       tar xvfz $install_tar
       cd vF-rabbit-install
       sed -i 's/  resolve_epel_erlang_repo/  #resolve_epel_erlang_repo/' ./rabbitmq_rhel.py

           sed -i 's/^[^#].*epel-release-5-4.noarch.rpm\"/epel_rpm=\"http:\/\/dl.fedoraproject.org\/pub\/epel\/6\/x86_64\/epel-release-6-8.noarch.rpm\"/g' ./rabbitmq_rhel.py


       echo "installing RabbitMQ"
       ./rabbitmq_rhel.py --setup-rabbitmq < /dev/console
       ./rabbitmq_rhel.py --start < /dev/console


            echo "64 bit machine"
            wget $rhel_repo/x86_64/CentOS/unixODBC-libs-2.2.11-10.el5.x86_64.rpm
            rpm -ivh unixODBC-libs-2.2.11-10.el5.x86_64.rpm
            wget $rhel_repo/x86_64/CentOS/unixODBC-2.2.11-10.el5.x86_64.rpm
            rpm -ivh unixODBC-2.2.11-10.el5.x86_64.rpm

#End checking OS type
#export rabbitmq_node_ip=$node_ip
echo "host:$rabbitmq_node_ip"
echo "port:$rabbitmq_node_port"