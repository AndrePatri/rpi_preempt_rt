#!/bin/bash
sudo apt install gcc make gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi

sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf fakeroot

sudo apt-get install libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf

cd ~
mkdir kernel_ws2
cd kernel_ws2

wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.55.tar.gz

wget https://cdn.kernel.org/pub/linux/kernel/projects/rt/5.15/patch-5.15.55-rt48.patch.gz

tar -xzf linux-5.15.55.tar.gz

cd linux-5.15.55

patch -p1 < ../patch-5.15.55-rt48