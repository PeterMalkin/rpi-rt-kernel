#!/bin/sh

mount -t ext4 -o loop,offset=$((532480*512)) 2021-05-07-raspios-buster-armhf-lite.img /raspios/mnt/disk
mount -t vfat -o loop,offset=$((8192*512)),sizelimit=$((524288*512)) 2021-05-07-raspios-buster-armhf-lite.img /raspios/mnt/boot

cd /rpi-kernel/linux/
make INSTALL_MOD_PATH=/raspios/mnt/disk modules_install
make INSTALL_DTBS_PATH=/raspios/mnt/boot dtbs_install
cd -

cp /raspios/mnt/boot/$KERNEL.img /raspios/mnt/boot/$KERNEL_orig.img
cp /rpi-kernel/linux/arch/arm/boot/Image /raspios/mnt/boot/$KERNEL\_rt.img
cp /rpi-kernel/linux/arch/arm/boot/Image /raspios/mnt/boot/$KERNEL.img
cp /rpi-kernel/linux/arch/arm/boot/dts/overlays/*.dtb* /raspios/mnt/boot/overlays/
cp /rpi-kernel/linux/arch/arm/boot/dts/overlays/README /raspios/mnt/boot/overlays/

cp /raspios/config.txt /raspios/mnt/boot/
touch /raspios/mnt/boot/ssh

umount /raspios/mnt/disk
umount /raspios/mnt/boot
