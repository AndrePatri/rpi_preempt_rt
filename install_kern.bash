#!/bin/bash

path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

set -e # stop, should any of the commands throw errors

kern_vers=5.15.56
rt_kern_spec=rt48+
kern_full_name=$kern_vers-$rt_kern_spec

UBUNTU_MAJOR_FULL=$(lsb_release -rs)
kernel_dir=$kern_vers-$rt_kern_spec-$UBUNTU_MAJOR_FULL

can_hat_name=seeed-can-fd-hat-v2

cd $kernel_dir
KERN=$kern_full_name-v8

# apt install ./linux-image-$kern_full_name-v8_$kern_full_name-v8-1_arm64.deb
echo -e ""
echo -e "${BLUE}--> Installing image...${NC}"
echo -e ""
dpkg -i linux-image-"$KERN"_"$KERN"-1_arm64.deb

echo -e ""
echo -e "${BLUE}--> Installing headers...${NC}"
echo -e ""
dpkg -i linux-headers-$KERN_$KERN-1_arm64.deb

echo -e ""
echo -e "${BLUE}--> Installing libc...${NC}"
echo -e ""
dpkg -i linux-libc-dev_$KERN-1_arm64.deb

echo -e ""
echo -e "${BLUE}--> Setting up kernel...${NC}"
echo -e ""
mkdir -p /boot/firmware/$KERN/overlays/
cp -d /usr/lib/linux-image-$KERN/overlays/* /boot/firmware/$KERN/overlays/
cp -dr /usr/lib/linux-image-$KERN/* /boot/firmware/$KERN/
[[ -d /usr/lib/linux-image-$KERN/broadcom ]] && cp -d /usr/lib/linux-image-$KERN/broadcom/* /boot/firmware/$KERN/

touch /boot/firmware/$KERN/overlays/README

cp /boot/vmlinuz-$KERN /boot/firmware/$KERN/
cp /boot/System.map-$KERN /boot/firmware/$KERN/
cp /boot/config-$KERN /boot/firmware/$KERN/
cp /boot/initrd.img-$KERN /boot/firmware/$KERN/
cp /boot/firmware/config.txt /boot/firmware/config.bak

cp /boot/firmware/cmdline.txt /boot/firmware/$KERN/

cat > /boot/firmware/usercfg.txt << EOF

[pi4]
kernel=vmlinuz-$KERN
initramfs initrd.img-$KERN
os_prefix=$KERN/

[pi4]
dtoverlay=$can_hat_name

EOF

echo -e ""
echo -e "${BLUE}--> Done.${NC}"
echo -e ""