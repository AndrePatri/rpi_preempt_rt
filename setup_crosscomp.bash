#!/bin/bash
path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

sudo apt install gcc make gcc-arm-linux-gnueabi binutils-arm-linux-gnueabi

sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf fakeroot

sudo apt-get install libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf
sudo apt-get build-dep linux

cd path

# git clone git@github.com:AndPatr/rpi_preempt_rt.git

wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.55.tar.gz .

wget https://cdn.kernel.org/pub/linux/kernel/projects/rt/5.15/patch-5.15.55-rt48.patch.gz .

tar -xzf linux-5.15.55.tar.gz
gunzip patch-5.15.55-rt48.patch.gz

cd linux-5.15.55

cp config-5.15.0-1012-raspi .config

patch -p1 < ../patch-5.15.55-rt48.patch

yes '' | make oldconfig

make menuconfig


###

# # Enable CONFIG_PREEMPT_RT
#  -> General Setup
#   -> Preemption Model (Fully Preemptible Kernel (Real-Time))
#    (X) Fully Preemptible Kernel (Real-Time)

# # Enable CONFIG_HIGH_RES_TIMERS
#  -> General setup
#   -> Timers subsystem
#    [*] High Resolution Timer Support

# # Enable CONFIG_NO_HZ_FULL
#  -> General setup
#   -> Timers subsystem
#    -> Timer tick handling (Full dynticks system (tickless))
#     (X) Full dynticks system (tickless)

# # Set CONFIG_HZ_1000 (note: this is no longer in the General Setup menu, go back twice)
#  -> Processor type and features
#   -> Timer frequency (1000 HZ)
#    (X) 1000 HZ

# # Set CPU_FREQ_DEFAULT_GOV_PERFORMANCE [=y]
#  ->  Power management and ACPI options
#   -> CPU Frequency scaling
#    -> CPU Frequency scaling (CPU_FREQ [=y])
#     -> Default CPUFreq governor (<choice> [=y])
#      (X) performance


# ###
# make -j4 ARCH=arm64 CROSS_COMPILE=gcc-aarch64-linux-gnu- deb-pkg

make -j `nproc` deb-pkg