此版本主要针对小米路由设置国内的路由段通过默认网关出去  

1.优化了拨入VPN之后的国内访问速度  
主要用于拨入vpn后自动设置IP段，以便于加速某个地区的访问（目前仅对中国区域加速配置）

2.使用说明  
2.1 上传autoroute_xiaomi.sh到路由器的任意目录下  
2.2 执行sh autoroute_xiaomi.sh add 完成路由添加  
2.3 若希望取消路由配置，则执行sh autoroute_xiaomi.sh del 即可取消  

3.生成小米路由的脚本  
如觉得IP库太旧，可自行生成小米路由的脚本，方法如下：  
3.1 在centos系统上，下载工具autoroute-version-xiaomiroute-cn.el6.noarch.sh  
3.2 执行脚本  
sh autoroute-version-xiaomiroute-cn.el6.noarch.sh  
完成后生成的autoroute_xiaomi.sh直接按照章节2中的说明使用即可.  

4.注意事项  
该程序应当在vpn已经拨入完成，且网络配置也完成的条件下执行(如SNAT)。  
请勿先执行，否则会因顺序问题导致策略实效。  

