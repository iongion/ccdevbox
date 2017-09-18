#!/bin/bash
set -e
#set -o
#set -x
USER=ubuntu
GROUP=ubuntu
HOME=/home/ubuntu
export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
mkdir -p $HOME/Workspace/ethereum
# rm -vf /var/lib/apt/lists/*
apt-get update
apt-get upgrade -y
apt-get install -y language-pack-en-base
apt-get install -y software-properties-common
apt-get install -y apt-utils apt-transport-https ca-certificates
apt-get install -y build-essential libssl-dev
# Other
apt-get install -y vim git curl wget unzip mc
# Golang dev env
if [[ ! -f /usr/lib/go-1.8/bin/go ]]; then
  add-apt-repository -y ppa:gophers/archive
  apt-get update
  apt-get install -y golang-1.8-go
  [ -f $HOME/.profile ] || touch $HOME/.profile
  [ -f $HOME/.bash_profile ] || touch $HOME/.bash_profile
  grep 'PATH=/usr/lib/go-1.8/bin' $HOME/.profile || echo 'export PATH=/usr/lib/go-1.8/bin:$PATH' | tee -a ~/.profile
  grep 'PATH=/usr/lib/go-1.8/bin' $HOME/.bash_profile || echo 'export PATH=/usr/lib/go-1.8/bin:$PATH' | tee -a ~/.bash_profile
  . $HOME/.profile
  . $HOME/.bash_profile
fi
# Rust dev env
if [[ ! -f /usr/local/bin/rustc ]]; then
  wget -O - https://static.rust-lang.org/rustup.sh | bash
fi
# Ethereum dev env
if [[ ! -f /usr/bin/evm ]]; then
  add-apt-repository -y ppa:ethereum/ethereum
  apt-get update
  apt-get install -y ethereum
fi
# Ethereum Parity client(rust based) - binary
if [[ ! -f /usr/bin/parity ]]; then
  rm -f $HOME/Workspace/ethereum/parity_1.7.0_amd64.deb
  wget "http://d1h4xl4cr1h0mo.cloudfront.net/v1.7.0/x86_64-unknown-linux-gnu/parity_1.7.0_amd64.deb" \
    -O $HOME/Workspace/ethereum/parity_1.7.0_amd64.deb
  dpkg -i $HOME/Workspace/ethereum/parity_1.7.0_amd64.deb
fi
# NodeJS dev env
if [[ ! -d $HOME/.nvm ]]; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
  . $HOME/.bashrc
  nvm install 6.11.3
  nvm use 6.11.3
  npm install -g truffle
fi
# Ensure .profile is loaded at log-in
grep '. $HOME/.profile' $HOME/.bash_profile || echo '. $HOME/.profile' | tee -a ~/.bash_profile
. $HOME/.profile
# Clean-up
apt-get autoremove -y
