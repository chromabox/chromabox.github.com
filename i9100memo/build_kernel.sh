#!/bin/bash

#
# SGS2 (GT-I9100) kernel and initramfs build script. 
# written by chroma
#

# kernel default config name
KCONFIGNAME="c1_rev02_jpn_ntt_defconfig"

# set your env
TAR_NAME="/opt/android/sgs2/build_kernel/GT-I9100_Kernel_Gingerbread-chromabox.tar"
INITRAMFS_DIR="/opt/android/sgs2/build_kernel/initramfs"
KMODPATH="/opt/android/sgs2/build_kernel/driverpack"
KERNELPATH="/opt/android/sgs2/build_kernel/kernel"
TOOLCHAINPATH="/opt/android/sgs2/toolchains/arm-2009q3/bin"

export PATH=$TOOLCHAINPATH:$PATH
export ARCH=arm
export CROSS_COMPILE=arm-none-eabi-
export INSTALL_MOD_PATH=$KMODPATH

# (optional)
export LOCALVERSION="-rootedjp"
export KBUILD_BUILD_VERSION="chromabox"

# start it

rm -rf $INITRAMFS_DIR.cpio
rm -rf $TAR_NAME
rm -rf $KMODPATH/*

set -e

echo "SGS2 (GT-I9100) kernel and initramfs build script."
echo "choose:"
echo "1: default jpn config kernel and build"
echo "2: default jpn config and reconfig kernel and build"
echo "3: reconfig kernel and build"
echo "4: no config kernel and build"
RANSWER=""
read RANSWER

cd $KERNELPATH
case $RANSWER in
1)
	make clean
	make $KCONFIGNAME
	make -j2
	make modules
	make modules_install
	;;
2)
	make clean
	make $KCONFIGNAME
	make menuconfig
	make -j2
	make modules
	make modules_install
	;;
3)
	make clean
	make menuconfig
	make -j2
	make modules
	make modules_install
	;;
4)
	make clean
	make -j2
	make modules
	make modules_install
	;;
*)
	echo "error..." 
	exit 1
	;;
esac

echo "kernel build done."
echo "build initramfs....."

cd $KMODPATH
find -name '*.ko' -exec cp -av {} $INITRAMFS_DIR/lib/modules/ \;

cd $INITRAMFS_DIR
find | fakeroot cpio -H newc -o > $INITRAMFS_DIR.cpio 2>/dev/null
ls -lh $INITRAMFS_DIR.cpio
cd $KERNELPATH

nice -n 10 make -j2 zImage  CONFIG_INITRAMFS_SOURCE="$INITRAMFS_DIR.cpio" || exit 1
cd arch/arm/boot
tar cf $TAR_NAME zImage && ls -lh $TAR_NAME

echo "done."
