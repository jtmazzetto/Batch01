@echo off
set hostspath=%windir%\System32\drivers\etc\hosts
echo f | xcopy /f /y %windir%\System32\drivers\etc\hosts %windir%\System32\drivers\etc\hosts_backup
echo #Marti >> %hostspath%
echo 172.19.214.13 zprrpmap.lombardi.com.mx >> %hostspath%
echo 172.19.214.16 zproidap.lombardi.com.mx >> %hostspath%
echo 172.19.214.21 ztrmsdb1.lombardi.com.mx >> %hostspath%
echo 172.19.214.37 ztribapp.lombardi.com.mx >> %hostspath%
echo 172.19.214.19 zprbipap.lombardi.com.mx >> %hostspath%
echo 172.19.214.38 ztsinapp.lombardi.com.mx >> %hostspath%
echo 172.19.214.31 zdstinap.lombardi.com.mx >> %hostspath%
echo 172.19.214.18 zprstinv.lombardi.com.mx >> %hostspath%
echo 172.19.214.36 ztoidapp.lombardi.com.mx >> %hostspath%
echo 172.19.214.32 ztrmsapp.lombardi.com.mx >> %hostspath%
exit