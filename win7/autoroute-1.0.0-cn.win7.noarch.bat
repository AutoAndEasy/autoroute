@echo off
rem The script is used by add the China IP range to a specified gateway.
setlocal enabledelayedexpansion

goto about

:about
cls
echo ***************************************************
echo *                                                 *
echo *             AutoRoute For Win7  V1.0            *
echo *	        author:���ѧ��                   *
echo *           2013-03-16 ; QingDao of China         * 
echo *                                                 *
echo ***************************************************
echo.   
echo Warning:This script should be run by administrator!
echo.
echo ���棺�˳�����Ҫʹ�ù���ԱȨ������!
echo.
echo.
echo.
timeout 10
goto menu

:menu
cls
echo ============    MEMU    ============
echo 1:add the China IPs to a specified gateway
echo 2:del the China IPs to a specified gateway
echo 3:Show the status of the route
echo 9:About this program
echo 0:Exit (default choice after 30seconds)
echo.
choice -T 30 /C 12390 -D 0 /M "Please Input Your Choice:"

if errorlevel 5 goto exit
if errorlevel 4 goto about
if errorlevel 3 goto showroute
if errorlevel 2 goto delroute
if errorlevel 1 goto addroute

:addroute
set /p gateway=Please Input Your GateWay:
for /f %%a in (cn.iplist) do (
route add %%a %gateway%
)
timeout 3 > nul
goto menu

:delroute
for /f %%a in (cn.iplist) do (
route delete %%a
) 
timeout 3 > nul
goto menu

:showroute
route print
timeout 30
goto menu

:exit
cls
echo ***************************************************
echo *
echo *��������:���ѧ��
echo *������ϵ:myregs@126.com
echo *��Ȩ˵��:�˳�������GPL��ɡ���������ʹ�ã��޸ģ�������
echo *
echo ***************************************************
echo.
echo                                   Thank you !
echo.
echo.
echo                                    Byebye :)
timeout 2 > nul
exit