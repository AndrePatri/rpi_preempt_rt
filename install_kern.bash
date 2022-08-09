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

#### Modify the following two lines according to the kernel name ####
kern_vers=5.15.56
rt_kern_spec=rt48+
#####################################################################

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
dpkg -i linux-image-"$kern_full_name"_"$kern_full_name"-1_arm64.deb

echo -e ""
echo -e "${BLUE}--> Installing headers...${NC}"
echo -e ""
dpkg -i linux-headers-"$kern_full_name"_"$kern_full_name"-1_arm64.deb

echo -e ""
echo -e "${BLUE}--> Installing libc...${NC}"
echo -e ""
dpkg -i linux-libc-dev_"$kern_full_name"-1_arm64.deb

echo -e ""
echo -e "${BLUE}--> Setting up kernel...${NC}"
echo -e ""
mkdir -p /boot/firmware/$kern_full_name/overlays/
cp -d /usr/lib/linux-image-$kern_full_name/overlays/* /boot/firmware/$kern_full_name/overlays/
cp -dr /usr/lib/linux-image-$kern_full_name/* /boot/firmware/$kern_full_name/
[[ -d /usr/lib/linux-image-$kern_full_name/broadcom ]] && cp -d /usr/lib/linux-image-$kern_full_name/broadcom/* /boot/firmware/$kern_full_name/

touch /boot/firmware/$kern_full_name/overlays/README

cp /boot/vmlinuz-$kern_full_name /boot/firmware/$kern_full_name/
cp /boot/System.map-$kern_full_name /boot/firmware/$kern_full_name/
cp /boot/config-$kern_full_name /boot/firmware/$kern_full_name/
cp /boot/initrd.img-$kern_full_name /boot/firmware/$kern_full_name/
cp /boot/firmware/config.txt /boot/firmware/config.bak

cp /boot/firmware/cmdline.txt /boot/firmware/$kern_full_name/

cat > /boot/firmware/usercfg.txt << EOF

[pi4]
kernel=vmlinuz-$kern_full_name
initramfs initrd.img-$kern_full_name
os_prefix=$kern_full_name/

[pi4]
dtoverlay=$can_hat_name

EOF

echo -e ""
echo -e "${BLUE}--> Done.${NC}"
echo -e ""