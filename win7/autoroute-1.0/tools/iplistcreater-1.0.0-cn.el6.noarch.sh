#!/bin/bash

################ Script Info ################		

## Program: Create the China IPs List File V1.0
## Author:Chier Xuefei
## Date: 2013-03-16
## Update:None


################ Env Define ################

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:~/sbin
LANG=C
export PATH
export LANG

################ Var Setting ################

HomeDir="/tmp/iplistcreater"
BasePkg=" wget bc coreutils "

################ Func Define ################ 
function _info_msg() {
_header
echo -e " |                                                                |"
echo -e " |              Thank you for use IpListCreater(cn)!              |"
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
echo -e " |              Thank you for use iplistcreater(cn)!              |"
echo -e " |                                                                |"
echo -e " |           The file has been create in your home dir!           |"
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
	printf " | ::IP List Creater(CN)                      v1.0.0 (2013/03/16) |\n"
	printf " o----------------------------------------------------------------o\n"	
}

##Program Function

################ Main ################
clear
_info_msg

if [ ! -d $HomeDir ]; then
	mkdir -p $HomeDir
fi

cd $HomeDir || exit 1

##File Get
yum -y install $BasePkg
wget http://ftp.apnic.net/stats/apnic/delegated-apnic-latest
wget http://ftp.apnic.net/stats/apnic/delegated-apnic-latest.md5
md5sum delegated-apnic-latest|grep `cat delegated-apnic-latest.md5|cut -d" " -f4` || (echo 'MD5 Check Error!' ; exit 1)

##IP Analyze And File Create
> cn.iplist
echo "**** File Creating,Please wait ... ****"
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
echo ${ip}'/'${masknum} >> cn.iplist
done
\cp -a cn.iplist ~/cn.iplist

_end_msg
############  Clean Cache  ############
rm -rf ${HomeDir}
