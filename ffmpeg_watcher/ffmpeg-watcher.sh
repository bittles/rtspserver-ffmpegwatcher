#!/bin/sh

/tmp/watch-drivewayhi.sh &
/tmp/watch-drivewaylo.sh &
/tmp/watch-backyardhi.sh &
/tmp/watch-backyardlo.sh &
sleep 5
z=0
while true
do
    sleep 5
done

