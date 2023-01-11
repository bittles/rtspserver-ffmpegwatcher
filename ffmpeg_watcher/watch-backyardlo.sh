#!/bin/sh

/tmp/start-$RTSPUSER2$RTSPPATH2.sh &
sleep 60
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH2.pid
    backyardlopid=$(tail /tmp/$RTSPUSER2$RTSPPATH2.pid)

    $TAILCMD1 /tmp/$RTSPUSER2$RTSPPATH2.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER2${RTSPPATH2}frameA
#    logtailA=$(${TAILCMD1} /tmp/$RTSPUSER2$RTSPPATH2.log | ${TAILCMD2})
#    echo "$logtailA" > /tmp/$RTSPUSER2${RTSPPATH2}frameA
#    logtailA=$(${TAILCMD3} -e "s/\r//g" /tmp/$RTSPUSER2${RTSPPATH2}frameA)
#    echo "$logtailA" > /tmp/$RTSPUSER2${RTSPPATH2}frameA
#    logtailA=$(${TAILCMD4} -o '.{90}$' /tmp/$RTSPUSER2${RTSPPATH2}frameA | ${TAILCMD5})
#    echo "$logtailA" > /tmp/$RTSPUSER2${RTSPPATH2}frameA
    sleep 10
    $TAILCMD2 /tmp/$RTSPUSER2$RTSPPATH2.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER2${RTSPPATH2}frameB
#    logtailB=$(${TAILCMD1} /tmp/$RTSPUSER2$RTSPPATH2.log | ${TAILCMD2})
#    echo "$logtailB" > /tmp/$RTSPUSER2${RTSPPATH2}frameB
#    logtailB=$(${TAILCMD3} -e "s/\r//g" /tmp/$RTSPUSER2${RTSPPATH2}frameB)
#    echo "$logtailB" > /tmp/$RTSPUSER2${RTSPPATH2}frameB
#    logtailB=$(${TAILCMD4} -o '.{90}$' /tmp/$RTSPUSER2${RTSPPATH2}frameB | ${TAILCMD5})
#    echo "$logtailB" > /tmp/$RTSPUSER2${RTSPPATH2}frameB
#    frameA=$(tail -n 5 /tmp/$RTSPUSER2$RTSPPATH2.log | head -3)
#    frameB=$(tail -n 5 /tmp/$RTSPUSER2$RTSPPATH2.log | head -3)
#grep -oP -m 1 'frame=\s*\K\d+'
#    echo "$frameA" > /tmp/$RTSPUSER2${RTSPPATH2}frameA
#    echo "$frameB" > /tmp/$RTSPUSER2${RTSPPATH2}frameB

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
        echo "$now : ${RTSPUSER2}_$RTSPPATH2 Waiting 60 secs before rechecking..."
        backyardlopid=$(tail /tmp/$RTSPUSER2$RTSPPATH2.pid)
        sleep 60
        ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH2.pid
        backyardlopid=$(tail /tmp/$RTSPUSER2$RTSPPATH2.pid)
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
