#!/bin/bash

YELLOW='\033[01;33m'
BLUE='\033[01;34m'
REGULAR='\033[0m'

THREAD="-j5"
KERNEL="Image.gz-dtb"
DEFCONFIG="moonshine_defconfig"

BASE_MS_VER="Moonshine"
VER="-r1.0"
MS_VER="$BASE_MS_VER$VER"

KERNEL_DIR=`pwd`
REPACK_DIR="${HOME}/Kernel/AnyKernel"
ZIP_MOVE="${HOME}/Kernel/ZIPs"
OUTPUT_DIR="${HOME}/Kernel/Moonshine/arch/arm64/boot"

export LOCALVERSION=-`echo $MS_VER`
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=../Toolchain/BloodTC/bin/aarch64-linux-android-

function clean_all {
		rm -rf $REPACK_DIR/zImage
		rm -rf $REPACK_DIR/modules/*.ko
		rm -rf $OUTPUT_DIR/$KERNEL
		make clean && make mrproper
		echo
}

function make_kernel {
		make $DEFCONFIG
		echo
		make $THREAD
		echo
		cp -vr $OUTPUT_DIR/$KERNEL $REPACK_DIR/zImage
		echo
		find ./ -type f -name '*.ko' -exec cp -f {} $REPACK_DIR/modules/ \;
}

function make_zip {
		cd $REPACK_DIR
		zip -9 -r `echo $MS_VER`.zip . -x *.git*
		mv  `echo $MS_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

clear

DATE_START=$(date +"%s")

echo -e "${BLUE}"
echo
echo "• ▌ ▄ ·.              ▐ ▄ .▄▄ ·  ▄ .▄▪   ▐ ▄ ▄▄▄ ."
echo "·██ ▐███▪▪     ▪     •█▌▐█▐█ ▀. ██▪▐███ •█▌▐█▀▄.▀·"
echo "▐█ ▌▐▌▐█· ▄█▀▄  ▄█▀▄ ▐█▐▐▌▄▀▀▀█▄██▀▐█▐█·▐█▐▐▌▐▀▀▪▄"
echo "██ ██▌▐█▌▐█▌.▐▌▐█▌.▐▌██▐█▌▐█▄▪▐███▌▐▀▐█▌██▐█▌▐█▄▄▌"
echo "▀▀  █▪▀▀▀ ▀█▄▀▪ ▀█▄▀▪▀▀ █▪ ▀▀▀▀ ▀▀▀ ·▀▀▀▀▀ █▪ ▀▀▀ "
echo "▄ •▄ ▄▄▄ .▄▄▄   ▐ ▄ ▄▄▄ .▄▄▌                      "
echo "█▌▄▌▪▀▄.▀·▀▄ █·•█▌▐█▀▄.▀·██•                      "
echo "▐▀▀▄·▐▀▀▪▄▐▀▀▄ ▐█▐▐▌▐▀▀▪▄██▪                      "
echo "▐█.█▌▐█▄▄▌▐█•█▌██▐█▌▐█▄▄▌▐█▌▐▌                    "
echo "·▀  ▀ ▀▀▀ .▀  ▀▀▀ █▪ ▀▀▀ .▀▀▀                     "
echo
                                                          
echo -e "${YELLOW}"
echo
echo "Version: "; echo "$MS_VER";
echo
echo -e "${REGULAR}";
echo

echo -e "${BLUE}"
echo "Options: "
echo "1 - Clean Build"
echo "2 - Dirty Build"
echo "3 - Abort"
echo

while read -p "Please choose one of available options: " cchoice
do
case "$cchoice" in
	1 )
		echo -e "${BLUE}"
		echo
		echo "Cleaning up"
		echo
		echo -e "${REGULAR}"
		clean_all
		echo -e "${BLUE}"
		echo
		echo "Building `echo $MS_VER`"
		echo
		echo -e "${REGULAR}"
		make_kernel
		echo -e "${BLUE}"
		echo
		echo "Making `echo $MS_VER`.zip"
		echo
		echo -e "${REGULAR}"
		make_zip
		break
		;;
	2 )
		echo -e "${BLUE}"
		echo
		echo "Building `echo $MS_VER`"
		echo
		echo -e "${REGULAR}"
		make_kernel
		echo -e "${BLUE}"
		echo
		echo "Making `echo $MS_VER`.zip"
		echo
		echo -e "${REGULAR}"
		make_zip
		break
		;;
	3 )
		break
		;;
	* )
		echo -e "${BLUE}"
		echo
		echo "The option you entered is not available."
		echo "Please try again"
		echo
		echo -e "${REGULAR}"
		;;
esac
done

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo -e "${YELLOW}"
echo
echo "This build took: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
echo -e "${REGULAR}"