#!/bin/bash

sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo reflector -c Sweden -a 12 --sort rate --protocol https --save /etc/pacman.d/mirrorlist
sudo pacman -Sy

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload

programs=(
    xorg-server
    xorg-xinit
    xorg-xrandr
    xorg-xauth
    xorg-xkbutils
    xorg-xsetroot
    xorg-xset
    firefox
    arc-gtk-theme
    arc-icon-theme
    vlc
    dina-font
    tamsyn-font
    ttf-bitstream-vera
    ttf-croscore
    ttf-dejavu
    ttf-droid
    gnu-free-fonts
    ttf-ibm-plex
    ttf-liberation
    ttf-linux-libertine
    noto-fonts
    ttf-roboto
    tex-gyre-fonts
    ttf-ubuntu-font-family
    ttf-anonymous-pro
    ttf-cascadia-code
    ttf-fantasque-sans-mono
    ttf-fira-mono
    ttf-hack
    ttf-fira-code
    ttf-inconsolata
    ttf-jetbrains-mono
    ttf-monofur
    adobe-source-code-pro-fonts
    cantarell-fonts
    inter-font
    ttf-opensans
    gentium-plus-font
    ttf-junicode
    adobe-source-han-sans-otc-fonts
    adobe-source-han-serif-otc-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    polkit-gnome
    nitrogen
    lxappearance
    thunar
)

sudo pacman -S "${programs[@]}"

## Choose one
# pacman -S --noconfirm xf86-video-vmware
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings xorg-server-devel opencl-nvidia

## Choose one
# sudo mkdir -p /etc/X11/xorg.conf.d/ && sudo cp ./xorg/xorg.conf.d/xorg.conf /etc/X11/xorg.conf.d/xorg.conf
# sudo mkdir -p /etc/X11/xorg.conf.d/ && sudo cp ./xorg/xorg.conf.d/10-nvidia-drm-outputclass.conf /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf

mkinitcpio -P

sudo mkdir -p /usr/share/xsessions
sudo cp ./xorg/xsessions/dwm.desktop /usr/share/xsessions/dwm.desktop
cp ./xorg/.xprofile ~/.xprofile

mkdir ~/.sources

git clone https://git.suckless.org/dwm ~/.sources/dwm
cd ~/.sources/dwm && sudo make clean install

git clone https://git.suckless.org/st ~/.sources/st
cd ~/.sources/st && sudo make clean install

git clone https://git.suckless.org/dmenu ~/.sources/dmenu
cd ~/.sources/dmenu && sudo make clean install

git clone https://aur.archlinux.org/ly ~/.sources/ly
cd ~/.sources/ly && makepkg -si

sudo systemctl enable ly

printf "\e[1;34mDone! Please reboot.\n\e[0m"
