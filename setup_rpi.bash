#!/bin/bash
path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

set -e

cd $path

cat > ~/.bashrc << EOF

##############################################

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

##############################################

EOF

sudo apt update

sudo apt upgrade

./install_kern.bash
