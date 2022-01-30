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