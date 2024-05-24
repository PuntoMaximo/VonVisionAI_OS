# Von VisionAI OS

Initially based from flatmax's buildroot.rockchip repo ( https://github.com/flatmax/buildroot.rockchip ) , there are heavy modifications to accomodate for the different Hardware peripherals on Von VisionAI, alongside more external packages to enable Hardware components like MPP, NPU, RKAIQ, GPU acceleration on desktop, Linux kernel patches for touchscreen and camera, etc.

We want to support Buildroot first and foremost, because it allows a great amount of customization, only matched by Yocto. However, Yocto is a lot more difficult and less novice friendly to use than Buildroot. 

To users foreign to Buildroot: This repo is an external tree, it's meant to customize the main tree without forking it, so that we can apply all our customizations to any Buildroot version or commit we want. You will see how it's handled on the instructions section. At the moment the only tested Buildroot version is 2022.08.2

We will eventually try to port other images like Manjaro OS or Ubuntu. Right now however, we believe Buildroot is the most powerful alternative for our users, as they will be able to tailor make their own image to their own needs, removing any bloat, switching Kernel versions to their liking, optimizing for space or for boot time by removing packages, implementing custom programs and packages as required. The possibilities are endless.

We will offer readily made image files for download for our users who, understandably so, don't want to go the trouble of compiling the entire image from source. 

Instructions for building start below, they are kind of similar to the instructions on flatmax's repo



# RK3308, RK3328, RK356X, RK3588 buildroot system

Now builds for rk3308, rk3328, RK3566 and RK3588

This repo generates a bootable sdcard image for the RK3xxx platform.
It is a 64 bit image. Based on buildroot, this directory is an external buildroot tree - it integrates into the main buildroot tree seamlessly.

# Initial setup

Clone buildroot. For example :

```
cd yourPath
git clone git://git.busybox.net/buildroot buildroot

# tested with version : git checkout 2022.08.2

```

Make sure you have requirements :
```
sudo apt-get install -y build-essential gcc g++ autoconf automake libtool bison flex gettext
sudo apt-get install -y patch texinfo wget git gawk curl lzma bc quilt
sudo apt install python2
```

If building in a minimal Docker image, you will also require :
```
sudo apt-get install -y cpio unzip rsync python3
```


***The above instructions apply to Debian-based distros.  Buildroot works on other distros, but installing the above dependencies is beyond the scope of this README; check your distro's package manager documentation.  Additionally the dash shell is required on distros where it is not the default.***

Clone the external buildroot tree :
```
git clone https://github.com/PuntoMaximo/VonVisionAI_OS buildroot.von.ext
```

# To make the system

# for the Radxa rock cm3 io board
source buildroot.von.ext/setup.von.sh yourPath/buildroot


Make sure you have the buildroot downloads directory present (when you are in the yourPath/buildroot directory execute the following) :

```
mkdir ../buildroot.dl
```

# build the system

```
make
```

# installing

Insert your sdcard into your drive and make sure it isn't mounted. Write the image to the disk.

NOTE: The following command will overwrite any disk attached to $OF. Don't overwrite your root.

```
OF=/dev/sdf; rootDrive=`mount | grep " / " | grep $OF`; if [ -z $rootDrive ]; then sudo umount $OF[123456789]; sudo dd if=output/images/sdcard.img of=$OF; else echo you are trying to overwrite your root drive; fi
```

# using

Connect to the console debug uart with a serial cable. Or, add the openssh-server pacakge to the buildsystem, then ssh in as user root, no pass.

## ssh RSA keys

To use ssh, put your id_rsa.pub into the authorized_keys in the overlays directory. This will autoload your public RSA key to the embedded system so that you can login.
```
$ mkdir -p overlays/root/.ssh; chmod go-rwx overlays/root/.ssh
$ ls -ld overlays/root/.ssh
drwx------ 2 me me 4096 Aug  3  2016 overlays/root/.ssh
$ cat ~/.ssh/id_rsa.pub > overlays/root/.ssh/authorized_keys
$ ls -l overlays/root/.ssh/authorized_keys
-rw-r--r-- 1 me me 748 Feb 24 11:17 overlays/root/.ssh/authorized_keys
```

