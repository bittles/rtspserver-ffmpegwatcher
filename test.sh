#!/bin/sh

CMD1='tail -n 1'
CMD2='grep frame'
CMD3='egrep'

${CMD1} /home/odn2/wyze_rtsp_server/test | ${CMD2} | ${CMD3} -o '.{88}$' > testyes

