FROM debian:8
MAINTAINER Duzy Chan <code@duzy.info>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  libgl1-mesa-dri \
  net-tools \
  menu \
  sudo \
  gcc g++ \
  pkg-config \
  autoconf \
  xutils-dev \
  apt-utils \
  libpthread-stubs0-dev \
  libpciaccess-dev \
  bison flex \
  libtool \
  libffi-dev \
  libexpat1-dev \
  libxml2-dev \
  make \
  python \
  python-mako \
  x11proto-gl-dev \
  x11proto-dri2-dev \
  x11proto-dri3-dev \
  x11proto-present-dev \
  libxcb1-dev \
  libxcb-dri2-0-dev \
  libxcb-dri3-dev \
  libxcb-present-dev \
  libxcb-glx0-dev \
  libxshmfence-dev \
  libx11-xcb-dev \
  libxcb-glx0-dev \
  libxfixes-dev \
  libxdamage-dev \
  libxext-dev \
  libudev-dev \
  libomxil-bellagio-dev \
  libmtdev-dev \
  libevdev-dev \
  libxcb-composite0-dev \
  libxcursor-dev \
  libcairo-dev \
  libxkbcommon-dev \
  libjpeg-dev \
  libpng12-dev \
  libpangox-1.0-dev \
  libpam0g-dev

#  libwacom-dev

RUN useradd -m -s /bin/bash user

USER root
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

ENV PATH $PATH:/opt/wayland/bin
ENV LD_LIBRARY_PATH=/opt/wayland/lib
ENV PKG_CONFIG_PATH=/opt/wayland/lib/pkgconfig/:/opt/wayland/share/pkgconfig/
ENV ACLOCAL_PATH=/opt/wayland/share/aclocal
ENV ACLOCAL="aclocal -I $ACLOCAL_PATH"
RUN mkdir -p /opt/wayland/share/aclocal # needed by autotools
RUN mkdir -p /opt/wayland/source

WORKDIR /opt/wayland/source
RUN git clone --depth=1 git://anongit.freedesktop.org/wayland/libinput && \
    git clone --depth=1 git://anongit.freedesktop.org/wayland/wayland && \
    git clone --depth=1 git://anongit.freedesktop.org/wayland/wayland-protocols && \
    git clone --depth=1 git://anongit.freedesktop.org/wayland/weston && \
    git clone --depth=1 git://anongit.freedesktop.org/mesa/mesa && \
    git clone --depth=1 git://anongit.freedesktop.org/mesa/drm

RUN cd /opt/wayland/source/wayland \
    && ./autogen.sh --prefix=/opt/wayland --disable-documentation \
    && make && make install

RUN cd /opt/wayland/source/wayland-protocols \
    && ./autogen.sh --prefix=/opt/wayland \
    && make && make install

RUN cd /opt/wayland/source/drm \
    && ./autogen.sh --prefix=/opt/wayland \
    && make && make install

RUN cd /opt/wayland/source/mesa \
    && ./autogen.sh --prefix=/opt/wayland --disable-documentation \
       --enable-gles2--enable-gbm --enable-shared-glapi \
       --disable-gallium-egl \
       --with-egl-platforms=wayland,drm \
       --with-gallium-drivers=r300,r600,swrast,nouveau
    && make && make install
RUN cd /opt/libinput \
    && ./autogen.sh --prefix=/opt/wayland --disable-documentation --disable-libwacom \
    && make && make install
RUN cd /opt/wayland/source/weston \
    && ./autogen.sh --prefix=/opt/wayland --disable-documentation \
    && make && make install

ENV DISPLAY :0
ENV XDG_RUNTIME_DIR /var/lib/wayland
RUN mkdir -p /var/lib/wayland && chmod 0700 /var/lib/wayland

# The default VNC port is 5900
EXPOSE 5900

WORKDIR /root
CMD weston
