#!/bin/bash
cat /etc/hosts | grep $1 &> /dev/null;
if [ $? == 0 ]; then
	echo "Host writted";
else
	echo "Writting host name to /etc/hosts";
	sudo sh -c "echo '127.0.0.1   $1' >> /etc/hosts";
fi

# docker network ls | grep nginx-net &> /dev/null
# if [ $? == 1 ]; then
# 	docker network create nginx-net
# fi

