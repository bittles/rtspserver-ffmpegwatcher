#!/bin/sh

now=$(date)
echo "$now : ${RTSPUSER2}_$RTSPPATH2 Starting ffmpeg"
ffmpeg -loglevel info -thread_queue_size 64 -re -r 20 \
-hide_banner -avoid_negative_ts make_zero -rtsp_transport tcp -use_wallclock_as_timestamps 1 \
-i "rtsp://$RTSPUSER2:$RTSPPASS2@$RTSPIP2:$RTSPPORT2/$HILOUNICAST2" \
-vcodec copy -acodec libopus -filter:a "volume=1.5" \
-b:a 96k -vbr off -frame_duration 60 -compression_level 5 -application lowdelay -rtsp_transport tcp -f rtsp \
rtsp://rtsp-simple-server:8554/${RTSPUSER2}_$RTSPPATH2 2> /tmp/$RTSPUSER2$RTSPPATH2.log
