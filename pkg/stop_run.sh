#! /bin/sh

./dbuscontrol.sh stop
pn=`ps aux | grep run_v5 | wc -l`
if [ "$pn" -gt "1" ]; then
	pid=`ps aux | grep run_v5 | grep '/bin/sh' | awk '{print $2}'`
	sudo kill -9 $pid
fi
