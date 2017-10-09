#!/bin/bash
# Author	: Ali Salehi
# github	: https://github.com/salehiali1374/bandWidthLog
# Email		: salehiali1374@gmail.com
#
# requirement	:  iptables
# chmod +x logger.sh
# sudo ./logger.sh
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
clear
IFS='|'
trap Finish EXIT
confDB(){
	result=$(sqlite3 bandWidth "SELECT * FROM log")
	k=0
	for i in ${result[@]}; do
		if [ k == 0 ];then
			id="$i"
		elif [ $k == 1 ];then
			user="$i"
		elif [ $k == 2 ];then
			time="$i"
		elif [ $k == 3 ]; then
			sum="$i"
			sum=$((sum + time))
			time=0
			sqlite3 bandWidth "UPDATE log SET mysum='$sum' , data='$time' WHERE user='$user'"
		fi
		
		((k++))
		k=$((k%4))
	done
	unset IFS
	sleep 1
}
Start(){
	#add something for udpating DB
	echo -e "configuring DataBase"
	confDB
	#starts iptables
	myUsers=$(`echo users`)
	for login in ${myUsers[@]};do
		iptables -N out_user_$login
		iptables -A OUTPUT -m owner --uid-owner $(id -u $login) -j out_user_$login
	done
}
Finish(){
	iptables --flush
        rules=$(` iptables --list | grep Chain | grep -Eo "ufw-[a-z-]+" | xargs echo `)
        for i in "${rules[@]}"
        do
                `sudo iptables --delete-chain $i `
        done
        echo -e "iptables delete done."
}
saveData(){
	k=0
	#echo -e "in save data ${output[@]}"
	for i in ${output[@]};do
		if [ "$k" == 1 ];then
			Kbytes="$i"
			Kbytes=$((Kbytes/2048))
		elif [ "$k" == 2 ];then
			user=`echo $i | cut -d "_" -f3`
			result=$(sqlite3 bandWidth "SELECT user from log WHERE user='$user'")
			if [ -z "${result[@]}" ]; then
				#echo -e "in if"
				sqlite3 bandWidth "INSERT INTO log (user, data,mysum) VALUES ('$user', '$Kbytes', 0)"
			else
				#echo -e "in else"
                                sqlite3 bandWidth "UPDATE log SET data='$Kbytes' WHERE user='$user'"
			fi	
		fi
		((k++))
		k=$((k%21))
		
	done
#	echo -e "k is $k"
}
#count=0
flag=0
while true; do
	#starting
	if [ $flag == 0 ];then
		Start
		flag=1
	fi
	# gets each user transfered bytes
	output=$(sudo iptables -L OUTPUT -n -v | grep "out_")
	#echo -e "${output[@]}"
	saveData
	sleep 1
	((count++))
#	if [ $count == 100 ];then
#		break;
#	fi
	clear
done

