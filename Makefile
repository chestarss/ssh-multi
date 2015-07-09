install: ssh-find-agent.sh ssh-multi.sh
	mkdir ~/.script
	cp ssh-find-agent.sh ~/.script/
	cp ssh-multi.sh ~/.script/
	ln -s ~/.script/ssh-multi.sh ~/ 
	echo ". ~/.script/ssh-find-agent.sh" >> ~/.bashrc
	echo "ssh-find-agent -a " >> ~/.bashrc
