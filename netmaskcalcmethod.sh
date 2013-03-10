#!/bin/bash


####RUN Like    "sh a.sh 256"
cnt=$1
####Format the xx of 1.2.3.0/xx
masknum=$(cat << EOF | bc |  tail -1
pow=32;
define log2(x) {
if (x<=1) return (pow);
pow--;
return(log2(x/2));
}
log2($cnt)
EOF
)

####Format 255.255.255.255####
mask255num=`echo "$masknum/8"|bc`
masklastnum=`echo "$masknum%8"|bc`
masknot255=`echo "256-2^(8-$masklastnum)"|bc`
case "$mask255num" in
    0)
        maskten="${masknot255}.0.0.0"
        ;;
    1)
        maskten="255.${masknot255}.0.0"
        ;;
    2)
        maskten="255.255.${masknot255}.0"
        ;;
    3)
        maskten="255.255.255.${masknot255}"
        ;;
    4)
        maskten="255.255.255.255"
        ;;
    *)
        echo "Mask ERROR!" && exit 1
        ;;
esac
echo "IP|$masknum|$maskten|$cnt"
