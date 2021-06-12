#! /bin/bash
#  Description: 修改 centos7 的网卡配置文件，注意这里的情况是将dhcp修改为none模式.

# 获取网卡名称和网卡路径
NET_PATH="/etc/sysconfig/network-scripts/ifcfg-"
NET_NAME=`ip ro |awk '/^default/ {print $5}'`

# 如果有任何一条命令执行出错，就停止
set -e

# 获取IP地址、子网掩码、网关和DNS
clear && echo -e "\033[33m 开始修改IP地址…… \033[0m"
read -p '请输入目标IP地址：'   NET_IP
read -p '请输入目标子网掩码：' NET_MASK
read -p '请输入目标网关地址：' NET_GATEWAY
read -p '请输入目标DNS地址：'  NET_DNS

# 判断IP地址是否冲突
ping -c3 -w3 ${NET_IP} &> /dev/null && echo -e "\033[31m IP地址已经被占用 \033[0m"

# 修改网络配置文件 
sed -i '/BOOTPROTO/ s/dhcp/none/g' ${NET_PATH}${NET_NAME}
cat <<EOF >> ${NET_PATH}${NET_NAME}
IPADDR=${NET_IP}
NETMASK=${NET_MASK}
GATEWAY=${NET_GATEWAY}
DNS1=${NET_DNS}
EOF

# 重启网卡，这里需要先确认一遍，再手动选择重启
clear
echo -e "\033[35;1m 请确认一下网卡配置是否正确，即将重启网卡…… \033[0m"
sleep 2
echo "================================================"
cat ${NET_PATH}${NET_NAME}
echo "================================================"
sleep 5
read -p "重启网卡，请输入 y，按其它任意键结束." COMFIRE
if [ ${COMFIRE} == 'y' ];then
    systemctl restart network
else
   echo -e "\033[33m 您没有重启网卡，请手动重启 \033[0m"
fi
