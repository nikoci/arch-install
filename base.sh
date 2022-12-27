#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc
sed -i '171s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=sv-latin1" >> /etc/vconsole.conf
echo "archbtw" >> /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     archbtw.local archbtw" >> /etc/hosts

programs=(
    sudo
    efibootmgr
    networkmanager
    network-manager-applet
    dialog
    wpa_supplicant
    mtools
    dosfstools
    reflector
    base-devel
    linux-headers
    avahi
    xdg-user-dirs
    xdg-utils
    gvfs
    gvfs-smb
    nfs-utils
    inetutils
    dnsutils
    bluez
    bluez-utils
    cups
    hplip
    alsa-utils
    pulseaudio
    pavucontrol
    bash-completion
    openssh
    rsync
    acpi
    acpi_call
    tlp
    virt-manager
    qemu
    qemu-arch-extra
    edk2-ovmf
    bridge-utils
    dnsmasq
    vde2
    openbsd-netcat
    ipset
    firewalld
    flatpak
    sof-firmware
    nss-mdns
    acpid
    os-prober
    ntfs-3g
    terminus-font
)

pacman -S "${programs[@]}"

## Choose one
# pacman -S --noconfirm xf86-video-vmware
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

bootctl install
bootctl update

cp -f ./systemd-boot/loader.conf /boot/loader/loader.conf
cp -f ./systemd-boot/entries/arch.conf /boot/loader/entries/arch.conf

pacman -S --noconfirm intel-ucode

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

useradd -m nikoci
usermod -aG wheel libvirtd

sed -i '85s/.//' /etc/sudoers

printf "\e[1;34mDone! Set passwords for root and users. Type exit, umount -R /mnt and reboot.\n\e[0m"
