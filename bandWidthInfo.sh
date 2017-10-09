#!/bin/bash
# Author	: Ali Salehi
# github	: https://github.com/salehiali1374/bandWidthLog
# Email		: salehiali1374@gmail.com
#

clear

clear

while getopts "hu:a" options; do
	case "$options" in
		h)
			echo -e "##########################################"
			echo -e "######## welcome to bandWidthInfo ########"
			echo -e "##########################################"
			echo -e "\t -h  :: gives you more help if you want to!!!"
			echo -e "\t -a  :: show you all users bandWidth usage."
			echo -e "\t -u  :: show specific user bandWidth usage."
		;;
		u)
			username="$OPTARG"
			echo -e "user\tbandwidth(MB)"
			IFS='|'
			result=$(sqlite3 bandWidth "SELECT user, data, mysum FROM log WHERE user='$username'")
			k=0
			for i in ${result[@]} ; do
				if [ "$k" == 0 ];then
					user="$i"
				elif [ "$k" == 1 ];then
					data="$i"
				elif [ "$k" == 2 ];then
					sum="$i"
					data=$((data + sum))
					echo -e "$user\t$data"
				fi
				((k++))
			done
			unset IFS
		;;
		a)
			echo -e "user\tbandWidth(MB)"
			IFS='|'
			result=$(sqlite3 bandWidth "SELECT user,data,mysum FROM log")
			k=0
			for i in ${result[@]}; do
				if [ "$k" == 0 ]; then
					user="$i"
				elif [ "$k" == 1 ]; then
					data="$i"
				elif [ "$k" = 2 ]; then
					sum="$i"
					data=$((data + sum))
					echo -e "$user\t$data"
					k=0
				fi
				((k++))
			done
		;;
		*)
			echo -e "incorrect input. use -h for more information"
		;;

	esac
done
