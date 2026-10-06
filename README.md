# Background

The provided `build.sh` script will:
* Build the Debian-provided `libvirglrenderer` packages (both as a dependency for `pve-qemu` and for installing on the Proxmox host)
* Download the `libproxmox-backup-qemu0` packages from the Proxmox _pve-no-subscription_ repository (dependency for `pve-qemu`)
* Build the Proxmox-provided `pve-qemu-kvm` package with patched video support for installing on the Proxmox host

# Compiling pve-qemu-kvm with video hardware acceleration support

1. I recommend creating a LXC container using a Debian template to use as the build environment.

2. Install `git` and clone this repository:
```
apt update
apt install git
git clone https://github.com/corncobble/pve-qemu-hw-accel.git
```

3. Run `build.sh`:
```
cd pve-qemu-hw-accel
./build.sh
```

4. If there are any prompts to clean files, just quit (type 5).

5. Once complete, copy the `libvirglrenderer1_1.3.0-1_amd64.deb` and `pve-qemu-kvm_11.1.1-2_amd64.deb` packages to the Proxmox host, then install them on the Proxmox host:
```
apt install ./libvirglrenderer1_1.3.0-1_amd64.deb
apt install ./pve-qemu-kvm_11.1.1-2_amd64.deb
```

6. To use the `virtio-gl` GPU with a virtual machine, `libgl1` and `libegl1` packages must be installed on the Proxmox host.

## Testing drivers
From here, you will need to ensure that the Proxmox host has the drivers for your GPU installed.

If your GPU is AMD, install `mesa-va-drivers` and `vainfo`. Use `vainfo` (in both the Proxmox host and any VM using a `virtio-gl` GPU) to confirm that your drivers are loaded and working.

## More information

I could not have done this without the help of the [VirGL hardware accelerated h264/h265](https://forum.proxmox.com/threads/virgl-hardware-accelerated-h264-h265.137023/) thread on the Proxmox forums, and specifically [this](https://forum.proxmox.com/threads/virgl-hardware-accelerated-h264-h265.137023/post-843041) post by NineBall. All credit goes to them.