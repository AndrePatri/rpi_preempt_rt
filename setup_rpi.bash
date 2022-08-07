#!/bin/bash
path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

cd ~

set -e

github_mail=andreapatrizi1b6e6@gmail.com
ssh-keygen -t ed25519 -C "$github_mail"

echo "Ssh key generated."
echo "Add the following public key to your GitHub SSH keys and then insert \" OK \" to proceed with the setup."
while read line; do echo $line; done < .ssh/id_ed25519.pub

while read -n 1 -p "Input Selection:" user_input
do 
    if [ $user_input -eq "OK" ]; then
        
        break

    fi

done

git clone git@github.com:AndPatr/rpi_preempt_rt.git

cd $path

sudo apt update

sudo apt upgrade

#./install_kern.bash
