# Test data for the Linux Disk Editor.

Scripts
=======
* test.sh = test script to verify builds

Sample small images
===================
* test.ext2  = small image of ext2fs
* test.ext3  = small image of ext3fs
* test.ext4  = small image of ext4fs
* test.iso9660j  = small image of ISO9660 CDROM filesystem with joliet extensions
* test.minix = small image of MINIX file system
* test.vfat  = small image of windows/msdos VFAT system
* test.xiafs = small image of XIAFS file system
* testd      = some binary test data, no associated file system

Folders
=======
* expected/ = normal output from test scripts
* results/  = temporary directory for storing results, set RETAIN=1 to prevent autocleanup after each test
* search/   = files with some binary signatures

Creation Notes
==============

Replicating ext2 data (on ./mnt) to new filesystems

mkisofs -o test.iso9660j -cache-inodes -J -T -R -V 'lde-test-isofs' /mnt/

dd if=/dev/zero bs=1k count=200 of=./test.ext3
mkfs.ext3 ./test.ext3
mount ./test.ext3 /mnt2
( cd /mnt ; tar cf - . ) | ( cd /mnt2 ; tar xf - )
umount /mnt2

dd if=/dev/zero bs=1k count=100 of=./test.vfat
mkfs.vfat -n LDE-FAT ./test.vfat
mount ./test.vfat /mnt2
( cd /mnt ; tar cf - . ) | ( cd /mnt2 ; tar xf - )
cd /mnt2/dir3.100entries/
cp /mnt/dir3.100entries/* .
umount  /mnt2

# FAT16 has warnings about needing mount flags if we're smaller than 16MB
dd if=/dev/zero bs=1M count=16 of=./test.fat16
mkfs.vfat -v -f2 -n LDEFAT16 -r224 -F16 ./test.fat16

mkfs.vfat -v -f2 -n LDEFAT32 -r224 -F32 -S512 ./test.vfat32




