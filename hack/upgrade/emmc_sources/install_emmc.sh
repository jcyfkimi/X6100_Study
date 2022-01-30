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
