#!/bin/sh

/tmp/start-$RTSPUSER2$RTSPPATH2.sh &
sleep 15
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH2.pid
    frameA=$(tail -n 5 /tmp/$RTSPUSER2$RTSPPATH2.log | head -4)
    sleep 10
    frameB=$(tail -n 5 /tmp/$RTSPUSER2$RTSPPATH2.log | head -4)

    backyardlopid=$(tail /tmp/$RTSPUSER2$RTSPPATH2.pid)

    echo "$frameA" > /tmp/$RTSPUSER2${RTSPPATH2}frameA
    echo "$frameB" > /tmp/$RTSPUSER2${RTSPPATH2}frameB

    if cmp -s /tmp/$RTSPUSER2${RTSPPATH2}frameA /tmp/$RTSPUSER2${RTSPPATH2}frameB
    then
        x=0
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH2 Stream has hung."
        kill -9 $backyardlopid
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH2 Killed ffmpeg.."
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH2 Waiting 5 secs before restarting..."
        sleep 5
        now=$(date)
        /tmp/start-$RTSPUSER2$RTSPPATH2.sh &
        echo "$now : ${RTSPUSER2}_$RTSPPATH2 Started ffpmeg.."
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH2 Waiting 15 secs before rechecking..."
        sleep 15
        ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH2.pid
    else
       if [ $x -eq 0 ]
       then
        now=$(date)
        echo "$now : ${RTSPUSER2}_$RTSPPATH2 Stream is running..."
        x=1
       else
           :
       fi
    fi

    sleep 2
done
