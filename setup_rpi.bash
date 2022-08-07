#!/bin/bash
path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

set -e

cd $path

sudo apt update

sudo apt upgrade

./install_kern.bash
