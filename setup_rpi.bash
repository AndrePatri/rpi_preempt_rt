#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

set -e

cd $path

# setup terminal so that git branches are shown
echo -e ""
echo -e "${BLUE} Setting up terminal for showing git branches...${NC}"
echo -e ""

cat > ~/.bashrc << EOF

##############################################

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

##############################################

EOF

echo -e ""
echo -e "${BLUE}Running a general update and upgrade...${NC}"
echo -e ""

# updating and upgrading system
sudo apt update

sudo apt upgrade

# installing fully preemptible kernel
echo -e ""
echo -e "${BLUE}Installing rt kernel...${NC}"
echo -e ""
sudo ./install_kern.bash

# installing stuff
echo -e ""
echo -e "${BLUE}Installing additional stuff...${NC}"
echo -e ""
sudo apt install python3 python3-pip can-utils

sudo pip3 install --upgrade odrive

pip3 install python-can cantools

# installing ROS2 Foxy
echo -e ""
echo -e"${BLUE}Installing ROS2 Foxy...${NC}"
echo -e ""

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