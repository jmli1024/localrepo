#! /bin/bash
#  Descriptions: centos7 setting up static IP.

PATH_IP="/etc/sysconfig/network-scripts/ifcfg-"

read -p "Please input IP:" IPAD
read -p "Please input Gateway address:" GATE

## Check ONBOOT and DHCP
sed -i '/ONBOOT/ s/no/yes/g' ${PATH_IP}
sed -i '/BOOTPROTO/ s/dhcp/static/g' ${PATH_IP}

## Append static IP setting configure
cat << EOF >> ${PATH_IP}
IPADDR=${IPAD}
NETMASK=255.255.255.0
GATEWAY=${GATE}
DNS1=114.114.114.114
EOF 

clear && sleep 1
echo "Restarting network......"
systemctl restart network
