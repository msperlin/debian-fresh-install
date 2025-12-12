# https://wiki.debian.org/NvidiaGraphicsDrivers#Version_550.163.01

sudo apt install linux-headers-$(dpkg --print-architecture)

sudo apt install nvidia-kernel-dkms nvidia-driver firmware-misc-nonfree
