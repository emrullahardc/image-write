#!/bin/bash

function find_disk() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "To find the disk name on macOS:"
        echo "1. Open Terminal."
        echo "2. Run the command: diskutil list"
        echo "3. Identify your disk (e.g., /dev/disk6) from the list."
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "To find the disk name on Ubuntu:"
        echo "1. Open Terminal."
        echo "2. Run the command: lsblk"
        echo "3. Identify your disk (e.g., /dev/sdb) from the list."
    else
        echo "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

find_disk

read -p "Please enter the disk name you want to write to (e.g., /dev/disk6 or /dev/sdb): " disk_name
img_path="img.img"

echo "Using default image file: $img_path"

if lsof | grep -q "$disk_name"; then
    echo "Disk $disk_name is in use. You need to unmount it first."
    exit 1
fi

echo "Unmounting disk $disk_name..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    diskutil unmountDisk "$disk_name"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo umount "$disk_name"
fi

echo "Writing image file $img_path..."
sudo dd if="$img_path" of="$disk_name" bs=4M status=progress

sync
echo "Write operation completed. You can safely eject the disk."

