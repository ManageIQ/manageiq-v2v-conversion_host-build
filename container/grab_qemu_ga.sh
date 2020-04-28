#!/bin/bash -x
set -e

# Define the locations to search inside for "qemu-guest-agent"
declare -A location=(
    ['el6']='http://vault.centos.org/6.9/os/x86_64/Packages/'
    ['el7']='http://vault.centos.org/7.6.1810/os/x86_64/Packages/'
    ['el8']='http://mirror.centos.org/centos-8/8/AppStream/x86_64/os/Packages/'
    ['fc28']='http://ftp.fi.muni.cz/pub/linux/fedora/linux/releases/30/Everything/x86_64/os/Packages/q/'
    ['lp151']='http://download.opensuse.org/distribution/leap/15.1/repo/oss/x86_64/'
    )
save_dir="/usr/share/virtio-win/linux"

# get_package <location> <name> <target_dir>
get_package() {
    location="$1"
    name="$2"
    target_dir="$3"

    file=$(curl "$location" 2>/dev/null| grep -Po '(?<=href=")'"$name"'-[0-9][^"]*.rpm' | tail -1)
    if [ -z "$file" ] ; then
        echo "Cannot find package '$name' in repo '$location'"
        exit 1
    fi
    curl "$location$file" -o "$target_dir/$file"
}


for version in "${!location[@]}"
    do
        mkdir -p $save_dir/$version
        get_package "${location[$version]}" "qemu-guest-agent" "$save_dir/$version"
        # RHBZ#1811670
        if [ "$version" == "el8" ] ; then
            get_package "${location[$version]}" "pixman" "$save_dir/$version"
        fi
        # RHBZ#1811940
        mkdir -p /linux
        ln -s $save_dir/$version /linux/$version
    done

#
# Unpack everything from the virtio-win ISO so that we can remove it.
#

cd /usr/share/virtio-win
pwd
# Remove the driver directory to avoid duplicates
rm -frv drivers
# Extract the ISO
ISO="/usr/share/virtio-win/virtio-win.iso"
echo "Extracting $ISO"
# First create directories
for f in `isoinfo -i "$ISO" -f -J` ; do
    mkdir -p ./`dirname "$f"`
done
# Then extract files
for f in ` isoinfo -i "$ISO" -f -J`; do
    if [ ! -d "./$f" ] ; then
      isoinfo -i "$ISO" -J -x "$f" > "./$f"
    fi
done
# Remove the ISO(s)
rm -fv *.iso
ls -lR
