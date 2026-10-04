#!/bin/bash

#wget https://ftp.debian.org/debian/pool/main/v/virglrenderer/libvirglrenderer1_1.3.0-1_amd64.deb

# Install libvirglrenderer-dev package from debian (testing/unstable) repository
wget https://ftp.debian.org/debian/pool/main/v/virglrenderer/libvirglrenderer-dev_1.3.0-1_amd64.deb
apt-get install ./libvirglrenderer-dev_1.3.0-1_amd64.deb

# Install libproxmox-backup-qemu0 and libproxmox-backup-qemu0-dev from proxmox repository
wget http://download.proxmox.com/debian/pve/dists/trixie/pve-no-subscription/binary-amd64/libproxmox-backup-qemu0_2.0.3_amd64.deb
wget http://download.proxmox.com/debian/pve/dists/trixie/pve-no-subscription/binary-amd64/libproxmox-backup-qemu0-dev_2.0.3_amd64.deb
apt-get install ./libproxmox-backup-qemu0*

# Install remaining build dependencies
apt-get install git build-essential libacl1-dev libaio-dev libasound2-dev libattr1-dev libcap-ng-dev libcurl4-gnutls-dev libdrm-dev libepoxy-dev libfdt-dev libfuse3-dev libgbm-dev libglib2.0-dev libgnutls28-dev libiscsi-dev libjpeg-dev libjson-perl libnuma-dev libpci-dev libpixman-1-dev libpng-dev libpulse-dev librbd-dev libseccomp-dev libslirp-dev libsndio-dev libspice-protocol-dev libspice-server-dev libsystemd-dev liburing-dev libusb-1.0-0-dev libusbredirparser-dev libxkbcommon-dev libzstd-dev meson python3-sphinx python3-sphinx-rtd-theme python3-venv python3-wheel quilt uuid-dev xfslibs-dev debhelper check lintian

# Prepare pve-qemu for building
git clone https://github.com/proxmox/pve-qemu.git
cd pve-qemu
git submodule update --init --recursive
cd qemu
meson subprojects download

# Add patch to pve-qemu
cp 9999-nineball-patch.patch pve-qemu/debian/patches/extra
echo "extra/9999-nineball-patch.patch" >> pve-qemu/debian/patches/series
# patch -p1 < ../../patch

# Make deb package
cd ..
make deb