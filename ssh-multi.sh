#!/bin/bash
# a script to ssh multiple servers over multiple tmux panes
# -c is use ssh config file to provide user login info
starttmux() {
    if [ $config != "Y" ];then
    	tmux new-window "ssh -l $user -p $port $key -o StrictHostKeyChecking=no `sed -n '1p' $iplist`"
    else
    	tmux new-window "ssh -o StrictHostKeyChecking=no `sed -n '1p' $iplist`"
    fi
    unset hosts[0];
    for i in `sed -n '2,$p' $iplist`;
    do
    	if [ $config == "Y" ];then
            tmux split-window -h  "ssh -o StrictHostKeyChecking=no $i"
	else
            tmux split-window -h  "ssh -o StrictHostKeyChecking=no -l $user -p $port $key $i"
        fi    
        tmux select-layout tiled > /dev/null
    done
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}

FLAG=0
user=`whoami`
port=22

while getopts "hci:l:p:a:" Option
do
    case $Option in
	i) key="-i $OPTARG"             
		if [ $OPTARG == "NULL" ];then
			key=""
		fi
		;;
	p) port=$OPTARG;;                  
	l) user=$OPTARG;;                 
	c) config="Y";;                 
	a) iplist=$OPTARG
	   FLAG=1
		;;               
	h)
	   echo -e "\033[01;31mUsage:$0 [-c] [-l user] [-p port] [-i identify_key|NULL] -a ip_list_file \033[0m"	
	   exit 2
		;;
    esac
done
if [ $FLAG -eq 1 ]
then
	HOSTS=`cat $iplist`
else
	echo -e "please use \033[01;31m -a ip_list_file \033[0m to ip or hostname list"
	exit 1
fi
starttmux
