#!/bin/bash
# Ourge old kernel modules from Debian-based distros
# Created by Yevgeniy Goncharov, http://sys-adm.in

# Function to detect Linux distribution
function detect_linux_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" == "debian" ] || [ "$ID" == "ubuntu" ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

# Function to purge old kernel modules
function purge_old_kernel_modules() {
    
    dpkg --list | grep -v $(uname -r) | grep -E 'linux-image-[0-9]|linux-headers-[0-9]' | awk '{print $2" "$3}' | sort -k2,2 | head -n -2 | awk '{print $1}' | xargs sudo apt-get -y purge
    
}

# If the distribution is not Debian-based, then exit
if ! detect_linux_distribution; then
    echo "This script is only for Debian-based distributions"
    exit 1
else
    purge_old_kernel_modules
    echo "Old kernel modules have been purged! Done!"
fi
