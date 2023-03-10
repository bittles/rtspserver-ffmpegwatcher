FROM alpine:latest

ARG BUILD_DATE
ARG VCS_REF

CMD         ["--help"]
ENTRYPOINT  ["/tmp/ffmpeg-watcher.sh"]
WORKDIR     /tmp/ffmpeg

LABEL org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.name="ffmpeg" \
      org.label-schema.description="Small ffmpeg Docker images for Alpine Linux" \
      org.label-schema.vendor="aersaud" \
      org.label-schema.version="1.0" \
      maintainer="https://github.com/aersaud"

ENV SOFTWARE_VERSION="5.1.2"
ENV SOFTWARE_VERSION_URL="http://ffmpeg.org/releases/ffmpeg-${SOFTWARE_VERSION}.tar.bz2"
ENV BIN="/usr/bin"

RUN cd && \
apk update && \
apk upgrade && \
apk add \
  freetype-dev \
  pcre-tools \
  gnutls-dev \
  lame-dev \
  libass-dev \
  libogg-dev \
  libtheora-dev \
  libvorbis-dev \
  libvpx-dev \
  libwebp-dev \
  libssh2 \
  opus-dev \
  rtmpdump-dev \
  x264-dev \
  x265-dev \
  yasm-dev && \
apk add --no-cache --virtual \
  .build-dependencies \
  build-base \
  bzip2 \
  coreutils \
  gnutls \
  nasm \
  tar \
  x264 && \
# Install fdk-aac from testing.
echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
apk add --update fdk-aac-dev && \
# ----------------------------
DIR=$(mktemp -d) && \
cd "${DIR}" && \
wget "${SOFTWARE_VERSION_URL}" && \
tar xjvf "ffmpeg-${SOFTWARE_VERSION}.tar.bz2" && \
cd ffmpeg* && \
PATH="$BIN:$PATH" && \
./configure --help && \
./configure --bindir="$BIN" --disable-debug \
  --disable-doc \
  --disable-ffplay \
  # CRASHES--enable-avresample \
  --enable-gnutls \
  --enable-gpl \
  --enable-libass \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-librtmp \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libwebp \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --enable-postproc \
  --enable-small \
  --enable-libfdk-aac \
  --enable-version3  \
  --enable-parser=h264 \
  --enable-parser=acc \
  --extra-cflags="-I${PREFIX}/include" \
  --extra-ldflags="-L${PREFIX}/lib" \
  --extra-libs="-lpthread -lm" \
  --prefix="${PREFIX}" && \
make -j4 && \
make install && \
make distclean && \
rm -rf "${DIR}"  && \
apk del --purge .build-dependencies && \
rm -rf /var/cache/apk/*
#COPY ./ffmpeg-start.sh /tmp
COPY ./start-drivewayhi.sh /tmp
COPY ./start-drivewaylo.sh /tmp
COPY ./start-backyardhi.sh /tmp
COPY ./start-backyardlo.sh /tmp
COPY ./ffmpeg-watcher.sh /tmp
COPY ./watch-drivewayhi.sh /tmp
COPY ./watch-drivewaylo.sh /tmp
COPY ./watch-backyardhi.sh /tmp
COPY ./watch-backyardlo.sh /tmp
