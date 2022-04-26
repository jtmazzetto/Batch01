@echo off
set tnspath=C:\instantclient_12_1\Network\ADMIN\tnsnames.ora
echo f | xcopy /f /y C:\instantclient_12_1\Network\ADMIN\tnsnames.ora C:\instantclient_12_1\Network\ADMIN\tnsnames.ora_backup

echo ############################[ MARTÍ ]#############################																							   >> %tnspath%
echo #[ PRD ]##                                                                                                                                                    >> %tnspath%
echo MARTI.MOMPRD= (DESCRIPTION = (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.43) (PORT=1521)) (CONNECT_DATA=(SERVER=DEDICATED) (SERVICE_NAME=MTMOMPRD)))             >> %tnspath%
echo MARTI.MOMPRD= (DESCRIPTION = (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.47) (PORT=1521)) (CONNECT_DATA=(SERVER=DEDICATED) (SERVICE_NAME=MTMOMPRD)))             >> %tnspath%
echo MARTI.MOMPRD =                                                                                                                                                 >> %tnspath%
echo DESCRIPTION =                                                                                                                                                 >> %tnspath%
echo  (ADDRESS = (PROTOCOL = TCP)(HOST = 172.19.214.47)(PORT = 1521))                                                                                              >> %tnspath%
echo  (ADDRESS = (PROTOCOL = TCP)(HOST = 172.19.214.48)(PORT = 1521))                                                                                              >> %tnspath%
echo  (ADDRESS = (PROTOCOL = TCP)(HOST = 172.19.214.49)(PORT = 1521))                                                                                              >> %tnspath%
echo   (CONNECT_DATA =                                                                                                                                             >> %tnspath%
echo      (SERVER = DEDICATED)                                                                                                                                     >> %tnspath%
echo      (SERVICE_NAME = MTMOMPRD)                                                                                                                                >> %tnspath%
echo   )                                                                                                                                                           >> %tnspath%
echo MARTI.SIMPRD= (DESCRIPTION = (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.9) (PORT=1521)) (CONNECT_DATA=(SERVER=DEDICATED) (SERVICE_NAME=MTSIMPRD)))               >> %tnspath%
echo MARTI.RIBPRD= (DESCRIPTION = (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.8) (PORT=1521)) (CONNECT_DATA=(SERVER=DEDICATED) (SERVICE_NAME=MTRIBPRD)))               >> %tnspath%
echo #[ TST ]##                                                                                                                                                    >> %tnspath%
echo MARTI.MOMTST= (DESCRIPTION = (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.21) (PORT = 1521)) (CONNECT_DATA =(SERVER=DEDICATED) (SERVICE_NAME = MTMOMTST)))         >> %tnspath%
echo MARTI.SIMTST= (DESCRIPTION = (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.25)(PORT = 1521)) (CONNECT_DATA = (SERVER=DEDICATED) (SERVICE_NAME=MTSIMTST)))           >> %tnspath%
echo MARTI.RIBTST= (DESCRIPTION = (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.24)(PORT = 1521)) (CONNECT_DATA = (SERVER=DEDICATED) (SERVICE_NAME=MTRIBTST)))           >> %tnspath%
echo MARTI.IDSTST= (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 172.19.214.24)(PORT = 1521))) (CONNECT_DATA = (SERVICE_NAME = MTRIBTST)))      >> %tnspath%
echo #[ DEV ]##                                                                                                                                                    >> %tnspath%
echo MARTI.RMSDEV = (DESCRIPTION =                                                                                                                                  >> %tnspath%
echo    (ADDRESS = (PROTOCOL = TCP)(HOST = 172.19.214.27)(PORT = 1521))                                                                                            >> %tnspath%
echo    (CONNECT_DATA =                                                                                                                                            >> %tnspath%
echo      (SERVER = DEDICATED)                                                                                                                                     >> %tnspath%
echo      (SERVICE_NAME = MTMOMDES)                                                                                                                                >> %tnspath%
echo    )                                                                                                                                                          >> %tnspath%
echo  )                                                                                                                                                            >> %tnspath%
echo #[ JOE ]##                                                                                                                                                    >> %tnspath%
echo MARTI.PRD.JOBSCH= (DESCRIPTION = (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.47) (PORT=1521)) (CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=MTMOMPRD)))           >> %tnspath%
echo MARTI.JOB.TST= (DESCRIPTION= (ADDRESS=(PROTOCOL=TCP) (HOST=172.19.214.21)(PORT=1521)) (CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=MTMOMTST)))                >> %tnspath%
exit