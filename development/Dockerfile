FROM debian:8
MAINTAINER Duzy Chan <code@duzy.info>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  libgl1-mesa-dri \
  net-tools \
  menu \
  sudo \
  gcc

RUN useradd -m -s /bin/bash user

USER root
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

RUN mkdir -p /opt/wayland/source
WORKDIR /opt/wayland/source
RUN git clone --depth=1 git://anongit.freedesktop.org/wayland/libinput && \
    git clone --depth=1 git://anongit.freedesktop.org/wayland/wayland && \
    git clone --depth=1 git://anongit.freedesktop.org/wayland/wayland-protocols && \
    git clone --depth=1 git://anongit.freedesktop.org/wayland/weston && \
    git clone --depth=1 git://anongit.freedesktop.org/mesa/mesa && \
    git clone --depth=1 git://anongit.freedesktop.org/mesa/drm

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    pkg-config autoconf

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libtool
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libffi-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libexpat1-dev libxml2-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y gettext
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y make

RUN cd /opt/wayland/source/wayland \
    && ./autogen.sh --prefix=/opt/wayland --disable-documentation \
    && make && make install

ENV PATH $PATH:/opt/wayland/bin
ENV LD_LIBRARY_PATH=/opt/wayland/lib
ENV PKG_CONFIG_PATH=/opt/wayland/lib/pkgconfig/:/opt/wayland/share/pkgconfig/
ENV ACLOCAL_PATH=/opt/wayland/share/aclocal
ENV ACLOCAL="aclocal -I $ACLOCAL_PATH"
ENV mkdir -p /opt/wayland/share/aclocal # needed by autotools

RUN cd /opt/wayland/source/wayland-protocols \
    && ./autogen.sh --prefix=/opt/wayland \
    && make && make install

# For xorg-macros
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xutils-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libpthread-stubs0-dev
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libpthread-workqueue-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libpciaccess-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y bison
RUN cd /opt/wayland/source/drm \
    && ./autogen.sh --prefix=/opt/wayland \
    && make && make install

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y flex
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-mako
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y x11proto-gl-dev # for glproto
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y x11proto-dri2-dev # for dir2proto
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y x11proto-dri3-dev # for dir3proto
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y x11proto-present-dev # for presentproto
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxcb1-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxcb-dri2-0-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxcb-dri3-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxcb-present-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxshmfence-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libx11-xcb-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxcb-glx0-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxfixes-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxdamage-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxext-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libudev-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libomxil-bellagio-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y g++
RUN cd /opt/wayland/source/mesa \
    && ./autogen.sh --prefix=/opt/wayland \
       --enable-shared-glapi \
       --with-egl-platforms=wayland,drm \
       --with-gallium-drivers=swrast,nouveau \
    && make && make install

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libmtdev-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libevdev-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libwacom-dev
RUN cd /opt/wayland/source/libinput \
    && ./autogen.sh --prefix=/opt/wayland --disable-documentation --disable-libwacom \
    && make && make install

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxcb-composite0-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxcursor-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libcairo-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libxkbcommon-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libjpeg-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libpng12-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libpangox-1.0-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libpam0g-dev
RUN cd /opt/wayland/source/weston \
    && ./autogen.sh --prefix=/opt/wayland --disable-documentation \
    && make && make install

ENV DISPLAY :0
ENV XDG_RUNTIME_DIR /var/lib/wayland
RUN mkdir -p /var/lib/wayland && chmod 0700 /var/lib/wayland

# The default VNC port is 5900
EXPOSE 5900

WORKDIR /root
CMD which weston && sleep 100000
