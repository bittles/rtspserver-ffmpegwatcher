#!/bin/sh

echo "312314324234123123123123123123123123" > /tmp/$RTSPUSER2${RTSPPATH1}frameA
echo "12312312312341541254125125124" > /tmp/$RTSPUSER2${RTSPPATH1}frameB

echo "$(date) : ${RTSPUSER2}_$RTSPPATH1 Starting ffmpeg"

ffmpeg \
${FFMPEG_IN_OPT1} \
-i "rtsp://$RTSPUSER2:$RTSPPASS2@$RTSPIP2:$RTSPPORT2/$HILOUNICAST1" \
${FFMPEG_OUT_OPT1} \
rtsp://rtsp-simple-server:8554/${RTSPUSER2}_$RTSPPATH1 2> /tmp/$RTSPUSER2$RTSPPATH1.log

