#!/bin/sh

/tmp/start-$RTSPUSER2$RTSPPATH2.sh &
ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH2.pid
backyardlopid=$(tail /tmp/$RTSPUSER2$RTSPPATH2.pid)
sleep 40
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH2.pid
    backyardlopid=$(tail /tmp/$RTSPUSER2$RTSPPATH2.pid)
    echo "${RTSPUSER2}$RTSPPATH2 PID file tail is $(tail /tmp/${RTSPUSER2}$RTSPPATH2.pid)"
    echo "${RTSPUSER2}$RTSPPATH2 PID variable is ${backyardlopid} PID JUST CREATED"

    $TAILCMD1 /tmp/$RTSPUSER2$RTSPPATH2.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER2${RTSPPATH2}frameA
    sleep 5
    $TAILCMD2 /tmp/$RTSPUSER2$RTSPPATH2.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER2${RTSPPATH2}frameB

    if cmp -s /tmp/$RTSPUSER2${RTSPPATH2}frameA /tmp/$RTSPUSER2${RTSPPATH2}frameB
    then
        x=0
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH2 Stream has hung."
        echo "${RTSPUSER2}$RTSPPATH2 PID file tail is $(tail /tmp/${RTSPUSER2}$RTSPPATH2.pid)"
        echo "${RTSPUSER2}$RTSPPATH2 PID variable is ${backyardlopid} PID ABOUT TO BE KILLED"

        kill -9 $backyardlopid
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH2 Killed ffmpeg.."
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH2 Waiting 5 secs before restarting..."
        sleep 5

        /tmp/start-$RTSPUSER2$RTSPPATH2.sh &
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH2 Started ffpmeg.."
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH2 Waiting 40 secs before rechecking..."

        ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH2" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH2.pid
        backyardlopid=$(tail /tmp/$RTSPUSER2$RTSPPATH2.pid)
        echo "${RTSPUSER2}$RTSPPATH2 PID file tail is $(tail /tmp/${RTSPUSER2}$RTSPPATH2.pid)"
        echo "${RTSPUSER2}$RTSPPATH2 PID variable is ${backyardlopid} JUST CREATED"

        sleep 40
    else
       if [ $x -eq 0 ]
       then
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH2 Stream is running..."
        x=1
       else
           :
       fi
    fi

    sleep 2
done
