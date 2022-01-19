# Extracted Rootfs

Here is a ext4 formatted rootfs image file which extracted from original X6100 firmware .img file. Depends on the plugins or tool sets that you've installed in your local machine, this can be different. It can be a file that called 1100000.ext(here in this repo I just rename it to rootfs.ext), or maybe fully extracted in to a rootfs folder. 

## How to get the contents of rootfs?
### Windows:
```
With windows, this .ext file can be opened with decompress tools such like 7-Zip, then you can copy everything into your local disk.
```

### Linux/Mac
```
With Linux or Mac, this .ext file can be directly mounted into a folder using mount command as below:

# mkdir <MOUNT_FOLDER>
# sudo mount -o loop rootfs.ext <MOUNT_FOLDER>
```
