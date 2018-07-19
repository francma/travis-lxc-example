#!/bin/sh
set -eu

sudo add-apt-repository --yes ppa:ubuntu-lxc/stable
sudo apt-get -qq update
sudo apt-get install --yes lxc
sudo lxc-create -t download -n travis -- --dist "$LXC_DIST" --release "$LXC_RELEASE" --arch amd64  
echo "lxc.mount.entry = $PWD travis none bind,create=dir 0 0" | sudo tee --append "/var/lib/lxc/travis/config"
sudo lxc-start -dn travis
sudo lxc-wait -n travis -s RUNNING

for i in $(seq 100); do
  sudo lxc-attach -n travis ip route get 8.8.8.8 2>/dev/null | grep -v unreachable && break
  sleep 0.1
done
