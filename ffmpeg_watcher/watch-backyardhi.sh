#!/bin/sh

/tmp/start-$RTSPUSER2$RTSPPATH1.sh &
ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH1.pid
backyardhipid=$(tail /tmp/$RTSPUSER2$RTSPPATH1.pid)
sleep 40
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH1.pid
    backyardhipid=$(tail /tmp/$RTSPUSER2$RTSPPATH1.pid)
    echo "${RTSPUSER2}$RTSPPATH1 PID file tail is $(tail /tmp/${RTSPUSER2}$RTSPPATH1.pid)"
    echo "${RTSPUSER2}$RTSPPATH1 PID variable is ${backyardhipid} PID JUST CREATED"

    $TAILCMD1 /tmp/$RTSPUSER2$RTSPPATH1.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER2${RTSPPATH1}frameA
    sleep 5
    $TAILCMD1 /tmp/$RTSPUSER2$RTSPPATH1.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER2${RTSPPATH1}frameB

    if cmp -s /tmp/$RTSPUSER2${RTSPPATH1}frameA /tmp/$RTSPUSER2${RTSPPATH1}frameB
    then
        x=0
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH1 Stream has hung."
        echo "${RTSPUSER2}$RTSPPATH1 PID file tail is $(tail /tmp/${RTSPUSER2}$RTSPPATH1.pid)"
        echo "${RTSPUSER2}$RTSPPATH1 PID variable is ${backyardhipid} PID ABOUT TO BE KILLED"

        kill -9 $backyardhipid
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH1 Killed ffmpeg.."
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH1 Waiting 5 secs before restarting..."
        sleep 5

        /tmp/start-$RTSPUSER2$RTSPPATH1.sh &
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH1 Started ffpmeg.."
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH1 Waiting 40 secs before rechecking..."

        ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH1.pid
        backyardhipid=$(tail /tmp/$RTSPUSER2$RTSPPATH1.pid)
        echo "${RTSPUSER2}$RTSPPATH1 PID file tail is $(tail /tmp/${RTSPUSER2}$RTSPPATH1.pid)"
        echo "${RTSPUSER2}$RTSPPATH1 PID variable is ${backyardhipid} PID JUST CREATED"

        sleep 40
    else
       if [ $x -eq 0 ]
       then
        echo "$(date) : ${RTSPUSER2}_$RTSPPATH1 Stream is running..."
        x=1
       else
           :
       fi
    fi

    sleep 2
done
