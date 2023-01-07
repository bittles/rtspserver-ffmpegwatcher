#!/bin/sh

now=$(date)
echo "$now : Starting ffmpeg"
ffmpeg -loglevel verbose \
-hide_banner -avoid_negative_ts make_zero -rtsp_transport tcp -timeout 5000000 -use_wallclock_as_timestamps 1 \
-i "rtsp://$RTSPUSER:$RTSPPASS@$RTSPIP:$RTSPPORT/$HILOUNICAST" \
-vcodec copy -acodec libopus -filter:a "volume=1.5" \
-b:a 128k -vbr off -frame_duration 60 -compression_level 8 -application lowdelay -rtsp_transport tcp -f rtsp \
rtsp://rtsp-simple-server:8554/$RTSPPATH 2> /tmp/ffmpeg.log
