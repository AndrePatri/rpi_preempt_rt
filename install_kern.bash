#!/bin/bash

path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

kern_vers=5.15.55
kern_spec=rt48
kern_full_name=$kern_vers-$kern_spec
cd $kern_vers-$kern_spec

sudo apt install ./linux-image-$kern_full_name-v8_$kern_full_name-v8-1_arm64.deb

KERN=$kern_full_name-v8

mkdir -p /boot/firmware/$KERN/overlays/
cp -d /usr/lib/linux-image-$KERN/overlays/* /boot/firmware/$KERN/overlays/
cp -dr /usr/lib/linux-image-$KERN/* /boot/firmware/$KERN/
[[ -d /usr/lib/linux-image-$KERN/broadcom ]] && cp -d /usr/lib/linux-image-$KERN/broadcom/* /boot/firmware/$KERN/

touch /boot/firmware/$KERN/overlays/README

cp /boot/vmlinuz-$KERN /boot/firmware/$KERN/
cp /boot/System.map-$KERN /boot/firmware/$KERN/
cp /boot/config-$KERN /boot/firmware/$KERN/
cp /boot/initrd.img-$KERN /boot/firmware/$KERN/
cp /boot/firmware/config.txt{,.bak}
cp /boot/cmdline.txt /boot/firmware/$KERN/
cat > /boot/firmware/config.txt << EOF

[pi4]
max_framebuffers=2

[all]
cmdline=cmdline.txt

# Enable the audio output, I2C and SPI interfaces on the GPIO header
dtparam=audio=on
dtparam=i2c_arm=on
dtparam=spi=on

# Enable the serial pins
enable_uart=1

# Comment out the following line if the edges of the desktop appear outside
# the edges of your display
disable_overscan=1

# If you have issues with audio, you may try uncommenting the following line
# which forces the HDMI output into HDMI mode instead of DVI (which doesn't
# support audio output)
#hdmi_drive=2

# If you have a CM4, uncomment the following line to enable the USB2 outputs
# on the IO board (assuming your CM4 is plugged into such a board)
#dtoverlay=dwc2,dr_mode=host

[all]
kernel=vmlinuz-$KERN
initramfs initrd.img-$KERN
os_prefix=$KERN/
overlay_prefix=overlays/$(if [[ "$KERN" =~ 'v8' ]]; then echo -e "\narm_64bit=1"; fi)
[all]

EOF