# BandwidthLog

A bash script to show and log bandwidth usage of users

Requirement
---
In order to run this package you need to install `iptables` first:

```
$ sudo apt update
$ sudo apt install iptables
```

Installation
---
```
$ git clone https://github.com/salehiali1374/bandWidthLog.git
$ cd bandWidthLog
$ chmod +x logger.sh
$ chmod +x bandWidthInfo.sh
```

You can run logger.sh in system startup or use nohup!!    
After running logger.sh if you want to check gathering data you have to use bandWidthLog.sh    
For more information about how to usr bandWidthInfo.sh try this command:   

`$ ./bandWidthLog.sh -h`



**Are you a developer?**

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## License

GNU General Public License v3



