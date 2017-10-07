#!/bin/bash
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
		k=$((k%17))
		
	done
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

