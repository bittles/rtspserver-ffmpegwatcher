#!/bin/sh

echo "312314324234123123123123123123123123" > /tmp/$RTSPUSER2${RTSPPATH2}frameA
echo "12312312312341541254125125124" > /tmp/$RTSPUSER2${RTSPPATH2}frameB

now=$(date)
echo "$now : ${RTSPUSER2}_$RTSPPATH2 Starting ffmpeg"

ffmpeg \
${FFMPEG_IN_OPT2} \
-i "rtsp://$RTSPUSER2:$RTSPPASS2@$RTSPIP2:$RTSPPORT2/$HILOUNICAST2" \
${FFMPEG_OUT_OPT2} \
rtsp://rtsp-simple-server:8554/${RTSPUSER2}_$RTSPPATH2 2> /tmp/$RTSPUSER2$RTSPPATH2.log


#ffmpeg -loglevel info -thread_queue_size 64 -re -r 20 \
#-hide_banner -avoid_negative_ts make_zero -rtsp_transport tcp \
#-i "rtsp://$RTSPUSER2:$RTSPPASS2@$RTSPIP2:$RTSPPORT2/$HILOUNICAST2" \
#-vcodec copy -acodec libopus -filter:a "volume=1.5" \
#-b:a 96k -vbr off -frame_duration 60 -compression_level 5 -application lowdelay -rtsp_transport tcp -f rtsp \
#rtsp://rtsp-simple-server:8554/${RTSPUSER2}_$RTSPPATH2 2> /tmp/$RTSPUSER2$RTSPPATH2.log
