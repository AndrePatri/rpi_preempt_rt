#!/bin/bash
path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

set -e

cd $path

# setup terminal so that git branches are shown
echo "Setting up terminal for showing git branches..."
echo ""

cat > ~/.bashrc << EOF

##############################################

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

##############################################

EOF

# updating and upgrading system
sudo apt update

sudo apt upgrade

# installing fully preemptible kernel
echo ""
echo "Installing rt kernel..."
echo ""
./install_kern.bash

# installing stuff
echo ""
echo "Installing additional stuff..."
echo ""
sudo apt install python3 python3-pip can-utils python-can cantools

sudo pip3 install --upgrade odrive

# installing ROS2 Foxy
echo ""
echo "Installing ROS2 Foxy..."
echo ""

locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

apt-cache policy | grep universe

sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl gnupg2 lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update

sudo apt upgrade

sudo apt install ros-foxy-ros-base

cat > ~/.bashrc << EOF

##############################################

. /opt/ros/foxy/setup.bash

EOF

# rebooting to apply new kernel