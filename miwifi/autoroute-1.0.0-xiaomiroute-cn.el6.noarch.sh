#!/bin/bash

################ Script Info ################		

## Program: Add/Delete the China IPs to the gateway V1.0
## Author:Chier Xuefei
## Date: 2014-09-30
## Update:None


################ Env Define ################

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:~/sbin
LANG=C
export PATH
export LANG

################ Var Setting ################

HomeDir="/tmp/autoroute"
CurrentDir=`pwd`
BasePkg=" wget bc coreutils "
Mytype=$1
Mygw=$2

################ Func Define ################ 
function _info_msg() {
_header
echo -e " |                                                                |"
echo -e " |        Thank you for use autoroute for xiaomi route (cn)!      |"
echo -e " |                                                                |"
echo -e " |                         Version: 1.0                           |"
echo -e " |                                                                |"
echo -e " |                     http://www.idcsrv.com                      |"
echo -e " |                                                                |"
echo -e " |                   Author:翅儿学飞(chier xuefei)                |"
echo -e " |                      Email:myregs@126.com                      |"
echo -e " |                         QQ:1810836851                          |"
echo -e " |                         QQ群:61749648                          |"
echo -e " |                                                                |"
echo -e " |          Hit [ENTER] to continue or ctrl+c to exit             |"
echo -e " |                                                                |"
printf " o----------------------------------------------------------------o\n"	
 read entcs 
clear
}

function _end_msg() {
_header
echo -e " |                                                                |"
echo -e " |       Thank you for use autoroute for xiaomi route (cn)!       |"
echo -e " |                                                                |"
echo -e " |       The route script for xiaomi route has been created!      |"
echo -e " |                                                                |"
echo -e " |                     http://www.idcsrv.com                      |"
echo -e " |                                                                |"
echo -e " |                   Author:翅儿学飞(chier xuefei)                |"
echo -e " |                      Email:myregs@126.com                      |"
echo -e " |                         QQ:1810836851                          |"
echo -e " |                         QQ群:61749648                          |"
echo -e " |                                                                |"
printf " o----------------------------------------------------------------o\n"
}

function _header() {
	printf " o----------------------------------------------------------------o\n"
	printf " | ::Auto Route For XiaoMi Route(CN)          v1.0.0 (2014/09/30) |\n"
	printf " o----------------------------------------------------------------o\n"	
}

##Program Function

################ Main ################
clear
_info_msg

if [ `id -u` != "0" ]; then
echo -e "You need to be be the root user to run this script.\nWe also suggest you use a direct root login, not su -, sudo etc..."
exit 1
fi

if [ ! -d $HomeDir ]; then
	mkdir -p $HomeDir
fi

cd $HomeDir || exit 1

##File Get
yum -y install $BasePkg
wget http://ftp.apnic.net/stats/apnic/delegated-apnic-latest
wget http://ftp.apnic.net/stats/apnic/delegated-apnic-latest.md5
md5sum delegated-apnic-latest|grep `cat delegated-apnic-latest.md5|cut -d" " -f4` || (echo 'MD5 Check Error!' ; exit 1)

##IP Analyze And Route Setting

echo "**** The route is setting,Please wait ... ****"

cat > autoroute_xiaomi.sh << \EOF
#!/bin/sh

if [ `id -u` != "0" ]; then
    echo -e "You need to be be the root user to run this script.\nWe also suggest you use a direct root login, not su -, sudo etc..."
    exit 1
fi

if [ "x" == "x"$1 ] ;then
    echo "**** You must assign the type! ****"
    echo "Usage: sh autoroute_xiaomi.sh add|del"
    echo "Example: sh autoroute_xiaomi.sh add"
    exit 1
fi

if [ "xadd" == "x"$1 ] ;then
    ipt_cmd="I"
    route_cmd="add"
fi
if [ "xdel" == "x"$1 ] ;then
    ipt_cmd="D"
    route_cmd="del"
fi

x=`grep -A 10 -i "config interface 'lan'" /data/etc/config/network |grep -i "option ipaddr " | head -n 1 |awk -F"'" '{print $2}'|cut -d"." -f1,2,3`
lan_range="${x}.0/24"
wan_ip=`ip address show eth0.2|grep -i " inet "|awk -F" " '{print $2}' |cut -d"/" -f1`
wan_gw=`ip route show |grep -i "^default" |grep -i "eth0.2" |head -n 1 |cut -d" " -f3`

EOF

grep 'CN|ipv4|' delegated-apnic-latest | cut -d"|" -f4,5 |sed -e 's/|/ /g'| while read ip cnt
do
    masknum=$(cat << EOF | bc |  tail -1
num=32;
define log2(x) {
if (x<=1) return (num);
num--;
return(log2(x/2));
}
log2($cnt)
EOF
)

if [ "$masknum"X == "32"X ];then
    echo "iptables -t nat -\${ipt_cmd} POSTROUTING -s \${lan_range} -d ${ip} -j SNAT --to \${wan_ip}" >> autoroute_xiaomi.sh
    echo "route \${route_cmd} -host ${ip} gw \${wan_gw}" >> autoroute_xiaomi.sh
else
    echo "iptables -t nat -\${ipt_cmd} POSTROUTING -s \${lan_range} -d ${ip}/${masknum} -j SNAT --to \${wan_ip}" >> autoroute_xiaomi.sh
    echo "route \${route_cmd} -net ${ip}/${masknum} gw \${wan_gw}" >> autoroute_xiaomi.sh
fi
done

chmod ug+x autoroute_xiaomi.sh 

mv autoroute_xiaomi.sh ${CurrentDir}/

_end_msg
############  Clean Cache  ############
rm -rf ${HomeDir}
