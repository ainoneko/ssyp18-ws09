REM SET UTF-8
chcp 65001
ECHO ON
spin -a %1
gcc  -DBFS  -w -o pan.exe pan.c
pan.exe
spin -t %1

