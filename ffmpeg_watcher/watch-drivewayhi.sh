#!/bin/sh

/tmp/start-$RTSPUSER1$RTSPPATH1.sh &
sleep 60
x=0
while true
do
    ps | grep -m 1 "${RTSPUSER1}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER1$RTSPPATH1.pid
    drivewayhipid=$(tail /tmp/$RTSPUSER1$RTSPPATH1.pid)

    $TAILCMD1 /tmp/$RTSPUSER1$RTSPPATH1.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER1${RTSPPATH1}frameA
#    logtailA=$(${TAILCMD1} /tmp/$RTSPUSER1$RTSPPATH1.log | ${TAILCMD2})
#    echo "$logtailA" > /tmp/$RTSPUSER1${RTSPPATH1}frameA
#    logtailA=$(${TAILCMD3} -e "s/\r//g" /tmp/$RTSPUSER1${RTSPPATH1}frameA)
#    echo "$logtailA" > /tmp/$RTSPUSER1${RTSPPATH1}frameA
#    logtailA=$(${TAILCMD4} -o '.{90}$' /tmp/$RTSPUSER1${RTSPPATH1}frameA | ${TAILCMD5})
#    echo "$logtailA" > /tmp/$RTSPUSER1${RTSPPATH1}frameA
    sleep 10
    $TAILCMD1 /tmp/$RTSPUSER1$RTSPPATH1.log | $TAILCMD2 | $TAILCMD3 -o '.{88}$' | $TAILCMD4 > /tmp/$RTSPUSER1${RTSPPATH1}frameB
#    logtailB=$(${TAILCMD1} /tmp/$RTSPUSER1$RTSPPATH1.log | ${TAILCMD2})
#    echo "$logtailB" > /tmp/$RTSPUSER1${RTSPPATH1}frameB
#    logtailB=$(${TAILCMD3} -e "s/\r//g" /tmp/$RTSPUSER1${RTSPPATH1}frameB)
#    echo "$logtailB" > /tmp/$RTSPUSER1${RTSPPATH1}frameB
#    logtailB=$(${TAILCMD4} -o '.{90}$' /tmp/$RTSPUSER1${RTSPPATH1}frameB | ${TAILCMD5})
#    echo "$logtailB" > /tmp/$RTSPUSER1${RTSPPATH1}frameB
#grep -oP -m 1 'frame=\s*\K\d+'
# | grep info | tac | grep -oP -m 1 'frame=\s*\K\d+' | head -10
#    frameB=$(tail -n 1 /tmp/$RTSPUSER1$RTSPPATH1.log)
#    echo "$frameA" > /tmp/$RTSPUSER1${RTSPPATH1}frameA
#    echo "$frameB" > /tmp/$RTSPUSER1${RTSPPATH1}frameB

    if cmp -s /tmp/$RTSPUSER1${RTSPPATH1}frameA /tmp/$RTSPUSER1${RTSPPATH1}frameB
    then
        x=0
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH1 Stream has hung."
        kill -9 $drivewayhipid
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH1 Killed ffmpeg.."
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH1 Waiting 5 secs before restarting..."
        sleep 5
        now=$(date)
        /tmp/start-$RTSPUSER1$RTSPPATH1.sh &
        echo "$now : ${RTSPUSER1}_$RTSPPATH1 Started ffpmeg.."
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH1 Waiting 60 secs before rechecking..."
        sleep 60
        ps | grep -m 1 "${RTSPUSER1}_$RTSPPATH1" | awk '{ print $1 }' > /tmp/$RTSPUSER1$RTSPPATH1.pid
        drivewayhipid=$(tail /tmp/$RTSPUSER1$RTSPPATH1.pid)
    else
       if [ $x -eq 0 ]
       then
        now=$(date)
        echo "$now : ${RTSPUSER1}_$RTSPPATH1 Stream is running..."
        drivewayhipid=$(tail /tmp/$RTSPUSER1$RTSPPATH1.pid)
        x=1
       else
           :
       fi
    fi

    sleep 2
done
