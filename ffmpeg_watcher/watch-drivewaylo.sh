#!/bin/sh

/tmp/start-$RTSPUSER1$RTSPPATH2.sh &
ps | grep -m 1 "${RTSPUSER1}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER1$RTSPPATH2.pid
drivewaylopid=$(tail /tmp/$RTSPUSER1$RTSPPATH2.pid)
sleep 40
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER1}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER1$RTSPPATH2.pid
    drivewaylopid=$(tail /tmp/$RTSPUSER1$RTSPPATH2.pid)
    echo "${RTSPUSER1}$RTSPPATH2 PID file tail is $(tail /tmp/${RTSPUSER1}$RTSPPATH2.pid)"
    echo "${RTSPUSER1}$RTSPPATH2 PID variable is ${drivewaylopid} JUST CREATED"

    $TAILCMD1 /tmp/$RTSPUSER1$RTSPPATH2.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER1${RTSPPATH2}frameA
    sleep 5
    $TAILCMD1 /tmp/$RTSPUSER1$RTSPPATH2.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER1${RTSPPATH2}frameB

    if cmp -s /tmp/$RTSPUSER1${RTSPPATH2}frameA /tmp/$RTSPUSER1${RTSPPATH2}frameB
    then
        x=0
        echo "$(date) : ${RTSPUSER1}_$RTSPPATH2 Stream has hung."
        echo "${RTSPUSER1}$RTSPPATH2 PID file tail is $(tail /tmp/${RTSPUSER1}$RTSPPATH2.pid)"
        echo "${RTSPUSER1}$RTSPPATH2 PID variable is ${drivewaylopid} ABOUT TO KILL"

        kill -9 $drivewaylopid
        echo "$(date) : ${RTSPUSER1}_$RTSPPATH2 Killed ffmpeg.."
        echo "$(date) : ${RTSPUSER1}_$RTSPPATH2 Waiting 5 secs before restarting..."
        sleep 5

        /tmp/start-$RTSPUSER1$RTSPPATH2.sh &
        echo "$(date) : ${RTSPUSER1}_$RTSPPATH2 Started ffpmeg.."
        echo "$(date) : ${RTSPUSER1}_$RTSPPATH2 Waiting 40 secs before rechecking..."

        ps | grep -m 1 "${RTSPUSER1}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER1$RTSPPATH2.pid
        drivewaylopid=$(tail /tmp/$RTSPUSER1$RTSPPATH2.pid)
        echo "${RTSPUSER1}$RTSPPATH2 PID file tail is $(tail /tmp/${RTSPUSER1}$RTSPPATH2.pid)"
        echo "${RTSPUSER1}$RTSPPATH2 PID variable is ${drivewaylopid} JUST CREATED"

        sleep 40
    else
       if [ $x -eq 0 ]
       then
        echo "$(date) : ${RTSPUSER1}_$RTSPPATH2 Stream is running..."
        x=1
       else
           :
       fi
    fi

    sleep 2
done
