FROM ubuntu:20.04

ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y git make gcc bison flex libssl-dev bc ncurses-dev kmod
RUN apt-get install -y wget zip unzip fdisk nano

WORKDIR /rpi-kernel
RUN git clone https://github.com/raspberrypi/linux.git -b rpi-5.10.y --depth=1
RUN wget https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/5.10/patch-5.10.73-rt54.patch.gz
RUN wget https://github.com/Pro/raspi-toolchain/releases/download/v1.0.2/raspi-toolchain.tar.gz
RUN tar xfz raspi-toolchain.tar.gz --strip-components=1 -C /opt
RUN ls -la /opt/cross-pi-gcc


WORKDIR /rpi-kernel/linux/
ENV KERNEL=kernel
ENV ARCH=arm
ENV CROSS_COMPILE=/opt/cross-pi-gcc/bin/arm-linux-gnueabihf-

RUN gzip -cd ../patch-5.10.73-rt54.patch.gz | patch -p1 --verbose
RUN make bcmrpi_defconfig
ADD .config ./
RUN make zImage modules dtbs

WORKDIR /raspios
RUN wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip
RUN unzip 2021-05-07-raspios-buster-armhf-lite.zip && rm 2021-05-07-raspios-buster-armhf-lite.zip
RUN mkdir /raspios/mnt && mkdir /raspios/mnt/disk && mkdir /raspios/mnt/boot
ADD build.sh ./
ADD config.txt ./
