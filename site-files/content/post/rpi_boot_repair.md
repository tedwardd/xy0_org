+++
categories = ["Linux", "Raspberry Pi"]
date = "2018-02-26T18:08:28-05:00"
description = ""
draft = false
images = []
tags = ["Raspberry Pi", "Linux", "Filesystems"]
title = "Repairing a Raspberry Pi Boot Partition"
toc = false

+++

The power at my home went out the other day. When it came back on, my ADSB
receiver running on a Raspberry Pi, however, did not. It would flash green for a
moment and then stop all activity. Plugging it up to a monitor confirmed my
fear, it booted to the dreaded rainbow screen and no further. This meant the
filesystem was likely corrupt. This post will walk you through my
troubleshooting steps and ultimate resolution of this issue.

# Troubleshooting

The first thing you want to do with a corrupted SD image is isert it in a
working environment and run `fsck`. On a default Raspbian install there will be
two partitions on the SD card. One is formatted fat32, the other will likely be
ext4. The following steps assume you're running linux and you have the SD card
inserted in to your computer. I'll walk you through unmounting both partitions
but if you know how to do that, go ahead and do so now.

## Unmount the SD Card

You'll first want to unmount the card (but leave the card inserted) to do this,
run the following command:

```
sudo umount /dev/mmcblkp*
```

Once unmounted we can proceed to repairing the filesystem.

## Repair the est4 partition

Repairing the ext4 partition requires that we have e2fsck installed. Check your
package manager if you don't have the command available.

```
e2fsk -f -y /dev/mmcblkp2
```

Once complete, try removing the SD card and booting the Raspberry Pi. If it
still won't boot. Re-insert the card in your computer, unmount it like we did
earlier and proceed to the next section.

## Repair the boot partition

The boot partition is formatted in fat32. To repair this, we'll use the dosfsck
program. Again, check your package manager to find out what package provides
this tool on your system if you don't have the command available.

```
dosfsck -t -a -w /dev/mmcblkp1
```

Make note of any files that this commands reports as "unreadable". We'll need to
replace these a little later on. If you don't see this message, you should try
booting your card now. It should work. If it doesn't you may need to replace the
entire filesystem. The steps for doing so will be similar to the ones in the
next section but you'll replace every file instead of just the unreadable ones
you would have noted during the previous command.

# Replace Corrupted Files in /boot

The last repair step is replacing corrupted files in your /boot partition. If
you're here, something went very wrong. Thankfully, repairing things isn't as
bad as some might have you believe. We'll need to download a copy of the
raspbian image file, mount it to our local system and copy the corrupted files
from the known good image on to our SD card.

## Download Raspbian

The first thing you need to do is download a copy of Raspbian if you don't
already have a copy. You can download that
[here](https://www.raspberrypi.org/downloads/raspbian/).

## Mount the Image

Mounting an img file is a lot like mounting an ISO file if you've ever done
that. The difference is that we need to provide the partition offset manually to
the mount command.

First, we create a path to mount the img file to.

```
mkdir /tmp/raspbian
```

Next, we need to get some info about the file from fdisk. Replace
`<raspbian_image_path>` below with the actual path to your img file.

```
fdisk -l <raspbian_image_path>
```

You should see an output that looks similar to this:

```
$ fdisk -l 2017-11-29-raspbian-stretch-lite.img
Disk 2017-11-29-raspbian-stretch-lite.img: 1.7 GiB, 1858076672 bytes, 3629056 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x37665771

Device                                Boot Start     End Sectors  Size Id Type
2017-11-29-raspbian-stretch-lite.img1       8192   93236   85045 41.5M  c W95 FAT32 (LBA)
2017-11-29-raspbian-stretch-lite.img2      94208 3629055 3534848  1.7G 83 Linux
```

You want to multiply the Sector size by the start-block for img1. In the example
above this would be `512 * 8192 = 4194304`. 4194304 is our offset. Now we'll use
that to mount the img file to `/tmp/raspbian`. Once again, replacing
`<path_to_image>` with our actual file path.

```
mount -o loop,offset=4194304 <path_to_image> /tmp/raspbian
```

You should now be able to list the contents of the boot partition in the image
file with `ls /tmp/raspbian`. Now insert your SD card and copy the files from
the mounted image to the /boot partition on your SD card. Once you're done,
unmount the SD card and attempt to boot the Pi again.

One thing I noticed when copying the files over was that one of the dtb files
was missing from the image. I just skipped over this and replaced what I could.
For me, this was fine. YMMV.

Hopefully this helps anyone stuck with a corrupt SD card image get back up and
running again. I imagine this same method can be used to repair the ext4
partition as well. Just adjust your offset calculation to use the start-block
for the img2 partition instead in order to access the files.
