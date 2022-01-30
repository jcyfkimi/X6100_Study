# Upgrade Scripts

We can found a shell script called "update" under [ROOTFS]/usr/share/support, this script shows how to upgrade the FW to X6100, so let's looking into it. 


## [ROOTFS]/usr/share/support/update

script source code:

```
#!/bin/sh

source /etc/profile
cd /usr/share/emmc_sources
./install_emmc.sh 1>&/dev/tty0
echo "update finished!" 1>&/dev/tty0
echo "power off in 3" 1>&/dev/tty0
sleep 1
echo "power off in 2" 1>&/dev/tty0
sleep 1
echo "power off in 1" 1>&/dev/tty0
sleep 1
echo "power off in 0" 1>&/dev/tty0
poweroff
```


From this script we can clearly see the actual update function is done by /usr/share/emmc_sources/install_emmc.sh, so let's redirect to this install_emmc.sh script.

## [ROOTFS]/usr/share/emmc_sources/install_emmc.sh

script source code:
```
_EMMC_SRC="."
_UPDATE_DIR="/mnt/update"

# fdisk emmc
./fmt_emmc.sh
if [ $? -ne 0 ]; then
    echo -e "can't fdisk and format built-in emmc"
    exit $?
fi

# write uboot to emmc's head space
echo "writing uboot..."
dd if=${_EMMC_SRC}/u-boot-sunxi-with-spl.bin of=/dev/mmcblk2 bs=1024 seek=8
sync

# mount emmc p1/p2 and copy files to them
echo "preparing..."
mkdir -p /mnt/emmc_p1
mkdir -p /mnt/emmc_p2
mount /dev/mmcblk2p1  /mnt/emmc_p1
mount /dev/mmcblk2p2  /mnt/emmc_p2
if [ $? -ne 0 ]; then
    echo -e "can't mount built-in emmc"
    exit $?
fi

mkdir -p ${_UPDATE_DIR}
mount /dev/mmcblk0p3  ${_UPDATE_DIR}
if [ $? -ne 0 ]; then
    echo -e "can't mount tf/sd card"
    exit $?
fi

echo "copying kernel files..."
cp -f ${_EMMC_SRC}/zImage               /mnt/emmc_p1
cp -f ${_EMMC_SRC}/sun8i-r16-x6100.dtb  /mnt/emmc_p1
cp -f ${_EMMC_SRC}/boot.scr             /mnt/emmc_p1
sync

echo "building rootfs..."
# tar -xf ${_UPDATE_DIR}/rootfs.tar -C /mnt/emmc_p2
pv -p --timer --rate --bytes ${_UPDATE_DIR}/rootfs.tar | tar xf - -C /mnt/emmc_p2
echo "copying config files..."
cp -rfa  /mnt/emmc_p2/usr/share/emmc_sources/etc/* /mnt/emmc_p2/etc
sync
echo "finished!"
exit 0
```

This script is a bit longer than previous one, but it's also easy to read, it did below 5 steps:

- Step1: Calling <ROOTFS>/usr/share/emmc_sources/fmt_emmc.sh to format the eMMC
- Step2: Writing uboot image to the head of eMMC, offset 8K
- Step3: Mount the partitions, both eMMC and SD card partitions, mmcblk2 is eMMC, mmcblk0 is SD card
- Step4: Copy kernel image, dtb and boot script into 1st partition of eMMC
- Step5: Extract rootfs into 2nd partition of eMMC

Let's take a look of how the eMMC is formatted. 

## [ROOTFS]/usr/share/emmc_sources/fmt_emmc.sh

script source code:
```
# fdisk emmc
echo "preparing built-in emmc..." 1>&/dev/tty0
umount /dev/mmcblk2p*
fdisk /dev/mmcblk2 <<EOF
o
n
p
1
32768
131071
n
p
2
131072

w
EOF
sync
if [ $? -ne 0 ]; then
	echo -e "err in fdisk" 1>&/dev/tty0
	exit $?
fi

# format emmc.p1 to fat32
mkfs.vfat /dev/mmcblk2p1
if [ $? -ne 0 ]; then
    echo -e "err in mkfs p1" 1>&/dev/tty0
    exit $?
fi
echo y | mkfs.ext4 /dev/mmcblk2p2
if [ $? -ne 0 ]; then
    echo -e "err in mkfs p2" 1>&/dev/tty0
    exit $?
fi

echo "ok." 1>&/dev/tty0
exit 0
```

It uses fdisk to format the eMMC, the 1st partition is created as a new empty DOS patition table, with the start sector of 32768 and end secotr of 131071, the sector size for eMMC is 512 bytes, so the actual start offset is 32768 * 512B = 1677216B = 16384KB = 16MB, and the end offset is 64MB. The 2nd partition is created as default linux partition table, with start offset of 64MB, it uses all the space left. 

After the partitioning is done, it uses mkfs to format the 1st partition to fat32 and 2nd to ext4, that's all. 

## Conclusion

With all the information we got, we can come out below eMMC partition layout table. 

### eMMC partition layout table

|Offset|Format|Files|Description|
|:----:|:----:|:----:|:----:|
| 0 | RAW | N/A | N/A|
| 8KB | RAW | u-boot-sunxi-with-spl.bin | RAW format partition for u-boot image|
| 16MB | FAT32 | zImage/boot.scr/sun8i-r16-x6100.dtb | FAT32 format partition for kernel, dtb and boot script|
| 64MB | EXT4 | rootfs.tar | EXT4 format partition for rootfs |