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
RUN git clone git://anongit.freedesktop.org/wayland/libinput && \
    git clone git://anongit.freedesktop.org/wayland/wayland && \
    git clone git://anongit.freedesktop.org/wayland/wayland-protocols && \
    git clone git://anongit.freedesktop.org/wayland/weston && \
    git clone git://anongit.freedesktop.org/mesa/mesa && \
    git clone git://anongit.freedesktop.org/mesa/drm

RUN cd /opt/wayland/source/wayland \
    && ./autogen.sh --prefix=/opt/wayland \
    && make && make install
RUN cd /opt/wayland/source/wayland-protocols \
    && ./autogen.sh --prefix=/opt/wayland \
    && make && make install
RUN cd /opt/wayland/source/drm \
    && ./autogen.sh --prefix=/opt/wayland \
    && make && make install
RUN cd /opt/wayland/source/mesa \
    && ./autogen.sh --prefix=/opt/wayland \
       --enable-gles2--enable-gbm --enable-shared-glapi \
       --disable-gallium-egl \
       --with-egl-platforms=wayland,drm \
       --with-gallium-drivers=r300,r600,swrast,nouveau
    && make && make install
RUN cd /opt/libinput \
    && ./configure --prefix=/opt/wayland \
    && make && make install
RUN cd /opt/wayland/source/weston \
    && ./autogen.sh --prefix=/opt/wayland \
    && make && make install

ENV DISPLAY :0
ENV XDG_RUNTIME_DIR /var/lib/wayland
RUN mkdir -p /var/lib/wayland && chmod 0700 /var/lib/wayland

# The default VNC port is 5900
EXPOSE 5900

WORKDIR /root
CMD weston
