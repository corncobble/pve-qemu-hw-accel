#!/bin/bash

VIRGLRENDERER_BRANCH="debian/1.3.0-1"
LIBPROXMOXBACKUPQEMU0_VERSION="2.0.3"
PATCH_FILE="9999-nineball-pve-qemu-kvm-11.1.1-2.patch"

set -e

# Update apt sources
apt-get update

# Install git
apt-get -y install git

# Install virglrenderer build dependencies
apt-get -y install meson debhelper check libdrm-dev libegl1-mesa-dev libepoxy-dev libgbm-dev libva-dev libvulkan-dev python3-yaml pkgconf dh-exec

# Clone virglrenderer debian repository
git clone https://salsa.debian.org/debian/virglrenderer.git --branch ${VIRGLRENDERER_BRANCH}
cd virglrenderer

# Add 'drm-renderers=amdgpu-experimental' and 'unstable-apis=true' build flags
echo 'configure-opts += -Ddrm-renderers=amdgpu-experimental -Dunstable-apis=true' >> debian/rules
# Build debian packages (binaries)
dpkg-buildpackage -us -uc -b
# Install resulting libvirglrenderer packages
cd ..
apt-get -y install ./libvirglrenderer1_* ./libvirglrenderer-dev*

# Install libproxmox-backup-qemu0 and libproxmox-backup-qemu0-dev from proxmox repository (pve-qemu dependency)
wget http://download.proxmox.com/debian/pve/dists/trixie/pve-no-subscription/binary-amd64/libproxmox-backup-qemu0_${LIBPROXMOXBACKUPQEMU0_VERSION}_amd64.deb
wget http://download.proxmox.com/debian/pve/dists/trixie/pve-no-subscription/binary-amd64/libproxmox-backup-qemu0-dev_${LIBPROXMOXBACKUPQEMU0_VERSION}_amd64.deb
apt-get -y install ./libproxmox-backup-qemu0*

# Install pve-qemu build dependencies
apt-get -y install build-essential libacl1-dev libaio-dev libasound2-dev libattr1-dev libcap-ng-dev libcurl4-gnutls-dev libdrm-dev libepoxy-dev libfdt-dev libfuse3-dev libgbm-dev libglib2.0-dev libgnutls28-dev libiscsi-dev libjpeg-dev libjson-perl libnuma-dev libpci-dev libpixman-1-dev libpng-dev libpulse-dev librbd-dev libseccomp-dev libslirp-dev libsndio-dev libspice-protocol-dev libspice-server-dev libsystemd-dev liburing-dev libusb-1.0-0-dev libusbredirparser-dev libxkbcommon-dev libzstd-dev meson python3-sphinx python3-sphinx-rtd-theme python3-venv python3-wheel quilt uuid-dev xfslibs-dev debhelper check lintian

# Clone pve-qemu proxmox repository
git clone https://github.com/proxmox/pve-qemu.git

# Add patch to pve-qemu
cp ${PATCH_FILE} pve-qemu/debian/patches/extra
echo "extra/${PATCH_FILE}" >> pve-qemu/debian/patches/series

# Make deb package
cd pve-qemu
make

# Move desired packages to separate folder
cd ..
mkdir deb
mv pve-qemu/pve-qemu-kvm_*.deb deb
mv libvirglrenderer1_*.deb deb
echo "Done. Install packages in deb directory to Proxmox host."