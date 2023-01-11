#!/bin/sh

echo "312314324234123123123123123123123123" > /tmp/$RTSPUSER1${RTSPPATH1}frameA
echo "12312312312341541254125125124" > /tmp/$RTSPUSER1${RTSPPATH1}frameB

now=$(date)
echo "$now : ${RTSPUSER1}_$RTSPPATH1 Starting ffmpeg"

ffmpeg \
${FFMPEG_IN_OPT1} \
-i "rtsp://$RTSPUSER1:$RTSPPASS1@$RTSPIP1:$RTSPPORT1/$HILOUNICAST1" \
${FFMPEG_OUT_OPT1} \
rtsp://rtsp-simple-server:8554/${RTSPUSER1}_$RTSPPATH1 2> /tmp/$RTSPUSER1$RTSPPATH1.log

#-frame_duration 60
#-i "rtsp://$RTSPUSER1:$RTSPPASS1@$RTSPIP1:$RTSPPORT1/$HILOUNICAST1" \
#-thread_queue_size 400 -hide_banner -rtsp_transport tcp \

#
# -ac 1 
#-avoid_negative_ts make_zero 
#-vbr off
# -frame_duration 60
# -async 20
#aresample=48000
