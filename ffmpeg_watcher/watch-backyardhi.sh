#!/bin/sh

/tmp/start-$RTSPUSER2$RTSPPATH1.sh &
sleep 60
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH1.pid
    backyardhipid=$(tail /tmp/$RTSPUSER2$RTSPPATH1.pid)
    
    $TAILCMD1 /tmp/$RTSPUSER2$RTSPPATH1.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER2${RTSPPATH1}frameA
#    logtailA=$(${TAILCMD1} /tmp/$RTSPUSER2$RTSPPATH1.log | ${TAILCMD2})
#    echo "$logtailA" > /tmp/$RTSPUSER2${RTSPPATH1}frameA
#    logtailA=$(${TAILCMD3} -e "s/\r//g" /tmp/$RTSPUSER2${RTSPPATH1}frameA)
#    echo "$logtailA" > /tmp/$RTSPUSER2${RTSPPATH1}frameA
#    logtailA=$(${TAILCMD4} -o '.{90}$' /tmp/$RTSPUSER2${RTSPPATH1}frameA | ${TAILCMD5})
#    echo "$logtailA" > /tmp/$RTSPUSER2${RTSPPATH1}frameA
    sleep 10
    $TAILCMD1 /tmp/$RTSPUSER2$RTSPPATH1.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER2${RTSPPATH1}frameB
#    logtailB=$(${TAILCMD1} /tmp/$RTSPUSER2$RTSPPATH1.log | ${TAILCMD2})
#    echo "$logtailB" > /tmp/$RTSPUSER2${RTSPPATH1}frameB
#    logtailB=$(${TAILCMD3} -e "s/\r//g" /tmp/$RTSPUSER2${RTSPPATH1}frameB)
#    echo "$logtailB" > /tmp/$RTSPUSER2${RTSPPATH1}frameB
#    logtailB=$(${TAILCMD4} -o '.{90}$' /tmp/$RTSPUSER2${RTSPPATH1}frameB | ${TAILCMD5})
#    echo "$logtailB" > /tmp/$RTSPUSER2${RTSPPATH1}frameB

#    frameA=$(tail -n 5 /tmp/$RTSPUSER2$RTSPPATH1.log | head -3)
#    frameB=$(tail -n 5 /tmp/$RTSPUSER2$RTSPPATH1.log | head -3)
#    echo "$frameA" > /tmp/$RTSPUSER2${RTSPPATH1}frameA
#    echo "$frameB" > /tmp/$RTSPUSER2${RTSPPATH1}frameB

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
        echo "$now : ${RTSPUSER2}_$RTSPPATH1 Waiting 60 secs before rechecking..."
        ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH1.pid
        backyardhipid=$(tail /tmp/$RTSPUSER2$RTSPPATH1.pid)
        sleep 60
        ps | grep -m 1 "${RTSPUSER2}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER2$RTSPPATH1.pid
        backyardhipid=$(tail /tmp/$RTSPUSER2$RTSPPATH1.pid)
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
