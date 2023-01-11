#!/bin/sh

/tmp/start-$RTSPUSER1$RTSPPATH2.sh &
sleep 60
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER1}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER1$RTSPPATH2.pid
    drivewaylopid=$(tail /tmp/$RTSPUSER1$RTSPPATH2.pid)

    $TAILCMD1 /tmp/$RTSPUSER1$RTSPPATH2.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER1${RTSPPATH2}frameA
#    logtailA=$(${TAILCMD1} /tmp/$RTSPUSER1$RTSPPATH2.log | ${TAILCMD2})
#    echo "$logtailA" > /tmp/$RTSPUSER1${RTSPPATH2}frameA
#    logtailA=$(${TAILCMD3} -e "s/\r//g" /tmp/$RTSPUSER1${RTSPPATH2}frameA)
#    echo "$logtailA" > /tmp/$RTSPUSER1${RTSPPATH2}frameA
#    logtailA=$(${TAILCMD4} -o '.{90}$' /tmp/$RTSPUSER1${RTSPPATH2}frameA | ${TAILCMD5})
#    echo "$logtailA" > /tmp/$RTSPUSER1${RTSPPATH2}frameA
    sleep 10
    $TAILCMD1 /tmp/$RTSPUSER1$RTSPPATH2.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER1${RTSPPATH2}frameB
#    logtailB=$(${TAILCMD1} /tmp/$RTSPUSER1$RTSPPATH2.log | ${TAILCMD2})
#    echo "$logtailB" > /tmp/$RTSPUSER1${RTSPPATH2}frameB
#    logtailB=$(${TAILCMD3} -e "s/\r//g" /tmp/$RTSPUSER1${RTSPPATH2}frameB)
#    echo "$logtailB" > /tmp/$RTSPUSER1${RTSPPATH2}frameB
#    logtailB=$(${TAILCMD4} -o '.{90}$' /tmp/$RTSPUSER1${RTSPPATH2}frameB | ${TAILCMD5})
#    echo "$logtailB" > /tmp/$RTSPUSER1${RTSPPATH2}frameB
#    frameA=$(tail -n 5 /tmp/$RTSPUSER1$RTSPPATH2.log | head -3)
#    tail -n 50 /tmp/$RTSPUSER1$RTSPPATH2.log | grep info | tac | grep -oP -m 1 'frame=\s*\K\d+' | head -10 > /tmp/$RTSPUSER1${RTSPPATH2}frameA
#    frameB=$(tail -n 5 /tmp/$RTSPUSER1$RTSPPATH2.log | head -3)
#    echo "$frameA" > /tmp/$RTSPUSER1${RTSPPATH2}frameA
#    echo "$frameB" > /tmp/$RTSPUSER1${RTSPPATH2}frameB

    if cmp -s /tmp/$RTSPUSER1${RTSPPATH2}frameA /tmp/$RTSPUSER1${RTSPPATH2}frameB
    then
        x=0
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH2 Stream has hung."
        kill -9 $drivewaylopid
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH2 Killed ffmpeg.."
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH2 Waiting 5 secs before restarting..."
        sleep 5
        now=$(date)
        /tmp/start-$RTSPUSER1$RTSPPATH2.sh &
        echo "$now : ${RTSPUSER1}_$RTSPPATH2 Started ffpmeg.."
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH2 Waiting 60 secs before rechecking..."
        sleep 60
        ps | grep -m 1 "${RTSPUSER1}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER1$RTSPPATH2.pid
    else
       if [ $x -eq 0 ]
       then
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH2 Stream is running..."
        x=1
       else
           :
       fi
    fi

    sleep 2
done
