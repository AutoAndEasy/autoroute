@echo off
rem The script is used by add the China IP range to a specified gateway.(Use the cmroute.dll method)
setlocal enabledelayedexpansion

goto about

:about
cls
echo ***************************************************
echo *                                                 *
echo *             AutoRoute For Win7  V1.1            *
echo *	        author:翅儿学飞                   *
echo *           2013-03-17 ; QingDao of China         * 
echo *                                                 *
echo ***************************************************
echo.   
echo Warning:This script should be run by administrator!
echo.
echo 警告：此程序需要使用管理员权限运行!
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
echo. > cmdlist
echo ****  Route Table Adding ****
for /f %%a in (cn.iplist) do (
echo add %%a %gateway% METRIC default IF default >> cmdlist
)
rundll32.exe cmroute.dll,SetRoutes /STATIC_FILE_NAME cmdlist /DONT_REQUIRE_URL /IPHLPAPI_ACCESS_DENIED_OK
echo ****  Route Add Successfully! ****
timeout 3 > nul
goto menu

:delroute
echo. > cmdlist
echo ****  Route Table Deleting ****
for /f %%a in (cn.iplist) do (
echo delete %%a %gateway% METRIC default IF default >> cmdlist
) 
rundll32.exe cmroute.dll,SetRoutes /STATIC_FILE_NAME cmdlist /DONT_REQUIRE_URL /IPHLPAPI_ACCESS_DENIED_OK
echo ****  Route Delete Successfully! ****
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
echo *程序作者:翅儿学飞
echo *友情联系:myregs@126.com
echo *版权说明:此程序遵守GPL许可。可以任意使用，修改，发布！
echo *
echo ***************************************************
echo.
echo                                   Thank you !
echo.
echo.
echo                                    Byebye :)
timeout 2 > nul
exit