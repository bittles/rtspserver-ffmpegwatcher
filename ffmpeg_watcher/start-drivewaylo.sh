#!/bin/sh

echo "312314324234123123123123123123123123" > /tmp/$RTSPUSER1${RTSPPATH2}frameA
echo "12312312312341541254125125124" > /tmp/$RTSPUSER1${RTSPPATH2}frameB

echo "$(date) : ${RTSPUSER1}_$RTSPPATH2 Starting ffmpeg"

ffmpeg \
${FFMPEG_IN_OPT2} \
-i "rtsp://$RTSPUSER1:$RTSPPASS1@$RTSPIP1:$RTSPPORT1/$HILOUNICAST2" \
${FFMPEG_OUT_OPT2} \
rtsp://rtsp-simple-server:8554/${RTSPUSER1}_$RTSPPATH2 2> /tmp/$RTSPUSER1$RTSPPATH2.log
