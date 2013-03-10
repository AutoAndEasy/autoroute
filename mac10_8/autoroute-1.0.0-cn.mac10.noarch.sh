#!/bin/bash

################ Script Info ################		

## Program: Add/Delete the China IPs to the gateway V1.0
## Author:Chier Xuefei
## Date: 2013-03-10
## Update:None


################ Env Define ################

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:~/sbin
LANG=C
export PATH
export LANG

################ Var Setting ################

HomeDir="/tmp/autoroute"
Mytype=$1
Mygw=$2

################ Func Define ################ 
function _info_msg() {
_header
echo " |                                                                |"
echo " |                 Thank you for use autoroute(cn)!               |"
echo " |                                                                |"
echo " |                         Version: 1.0                           |"
echo " |                                                                |"
echo " |                     http://www.idcsrv.com                      |"
echo " |                                                                |"
echo " |                   Author:翅儿学飞(chier xuefei)                |"
echo " |                      Email:myregs@126.com                      |"
echo " |                         QQ:1810836851                          |"
echo " |                         QQ群:61749648                          |"
echo " |                                                                |"
echo " |          Hit [ENTER] to continue or ctrl+c to exit             |"
echo " |                                                                |"
printf " o----------------------------------------------------------------o\n"	
 read entcs 
clear
}

function _end_msg() {
_header
echo " |                                                                |"
echo " |                 Thank you for use autoroute(cn)!               |"
echo " |                                                                |"
echo " |                    The route has been set!                     |"
echo " |                                                                |"
echo " |                     http://www.idcsrv.com                      |"
echo " |                                                                |"
echo " |                   Author:翅儿学飞(chier xuefei)                |"
echo " |                      Email:myregs@126.com                      |"
echo " |                         QQ:1810836851                          |"
echo " |                         QQ群:61749648                          |"
echo " |                                                                |"
printf " o----------------------------------------------------------------o\n"
}

function _header() {
	printf " o----------------------------------------------------------------o\n"
	printf " | ::Auto Route (CN)                          v1.0.0 (2013/03/10) |\n"
	printf " o----------------------------------------------------------------o\n"	
}

##Program Function

################ Main ################
clear
_info_msg

if [ `id -u` != "0" ]; then
echo "You need to be be the root user to run this script.\nWe also suggest you use a direct root login, not su -, sudo etc..."
exit 1
fi

if [ ! -d $HomeDir ]; then
	mkdir -p $HomeDir
fi

cd $HomeDir || exit 1

if [ "$Mytype"X == ""X ] || [ "$Mygw"X == ""X  ]; then
    echo "**** You must assign the type and gateway first! ****"
    echo "Usage: sh xxx.sh add/delete GatewayIP"
    echo "Example: sh autoroute.sh add 192.168.1.1"
    exit 1
fi

##File Get
curl -O http://ftp.apnic.net/stats/apnic/delegated-apnic-latest
curl -O http://ftp.apnic.net/stats/apnic/delegated-apnic-latest.md5
md5 delegated-apnic-latest|grep `cat delegated-apnic-latest.md5|cut -d" " -f4` || (echo 'MD5 Check Error!' ; exit 1)

##IP Analyze And Route Setting

echo "**** The route is setting,Please wait ... ****"
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
    route ${Mytype} -host ${ip} ${Mygw}
else
    route ${Mytype} -net ${ip}/${masknum} ${Mygw}
fi
done

_end_msg
############  Clean Cache  ############
rm -rf ${HomeDir}
