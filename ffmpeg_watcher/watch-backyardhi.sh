#!/bin/sh

/tmp/start-$RTSPUSER2$RTSPPATH1.sh &
sleep 15
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH1.pid
    frameA=$(tail -n 5 /tmp/$RTSPUSER2$RTSPPATH1.log | head -4)
    sleep 10
    frameB=$(tail -n 5 /tmp/$RTSPUSER2$RTSPPATH1.log | head -4)

    backyardhipid=$(tail /tmp/$RTSPUSER2$RTSPPATH1.pid)

    echo "$frameA" > /tmp/$RTSPUSER2${RTSPPATH1}frameA
    echo "$frameB" > /tmp/$RTSPUSER2${RTSPPATH1}frameB

    if cmp -s /tmp/$RTSPUSER2${RTSPPATH1}frameA /tmp/$RTSPUSER2${RTSPPATH1}frameB
    then
        x=0
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH1 Stream has hung."
        kill -9 $backyardhipid
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH1 Killed ffmpeg.."
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH1 Waiting 5 secs before restarting..."
        sleep 5
        now=$(date)
        /tmp/start-$RTSPUSER2$RTSPPATH1.sh &
        echo "$now : ${RTSPUSER2}_$RTSPPATH1 Started ffpmeg.."
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH1 Waiting 15 secs before rechecking..."
        sleep 15
        ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH1.pid
    else
       if [ $x -eq 0 ]
       then
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH1 Stream is running..."
        x=1
       else
           :
       fi
    fi

    sleep 2
done
