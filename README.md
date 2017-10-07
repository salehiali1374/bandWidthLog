# bandWidthLog

A bash script that saves bandWidth usage for users

#requirement

you have to install iptables first. to do that:

`$ sudo apt update`

`$ sudo apt install iptables`

#Installation

`$ git clone https://github.com/salehiali1374/bandWidthLog.git`

`$ cd bandWidthLog`

`$ chmod +x logger.sh`

`$ chmod +x bandWidthInfo.sh`


you can run logger.sh in system startup or using nohup!!

after running logger.sh if you want to check gathering data you have to use bandWidthLog.sh

for more information about how to usr bandWidthInfo.sh try this command:

`$ ./bandWidthLog.sh -h`
