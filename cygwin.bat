@echo off

C:
chdir C:\cygroot\bin

bash --login -c "cd ""$(/bin/cygpath '%~dp0')""; /bin/bash -i"
