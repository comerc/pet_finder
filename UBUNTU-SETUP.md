# Ubuntu 20.04 Setup

### Change displays order

`1 3 4 2`

### Fix microphone

```bash
sudo nano /etc/pulse/default.pa

# set-default-sink alsa_output.usb-RODE_Microphones_RODE_NT-USB-00.analog-stereo
# set-default-source alsa_input.usb-RODE_Microphones_RODE_NT-USB-00.analog-stereo
```

### Midnight Commander

```bash
sudo apt install mc
```

### FiraCode Fonts

```bash
sudo apt install fonts-firacode
```

then change font in terminal profile

### Flutter

```bash
sudo snap install flutter --classic
flutter doctor -v
which flutter
flutter doctor --android-licenses
flutter sdk-path
cd common/flutter/packages/flutter_tools/gradle/
code flutter.gradle # change minSDKVersion to 21

sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
kvm-ok
```

### Git

```bash
sudo apt install git
git config --global user.name "John Doe"
git config --global user.email john.doe@example.com
```

### Login to GitHub

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
gh auth login
```

### Swapfile

```bash
# fix "/dev/sdc: open failed: No medium found" for "sudo update-grub"
# sudo nano /etc/lvm/lvm.conf # global_filter = [ "r|/dev/sdc|" ]

# https://askubuntu.com/questions/1240123/how-to-enable-the-hibernate-option-in-ubuntu-20-04

# Close the existing swap Space
sudo swapoff -a
# Remove swapfile
sudo rm /swapfile
# Refer to the table below for space size
# https://help.ubuntu.com/community/SwapFaq
# Allocate contiguous disk space via fallocate
# Than dd Commands are safer and faster
# sudo dd if=/dev/zero of=/swapfile bs=1M count=30720 # 16384
sudo fallocate -l 30G /swapfile
# Modify the permissions
sudo chmod 600 /swapfile
# Enable swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# Confirm the result
sudo swapon --show
free
```

### Hibernate

does not work ((

```bash
# see swapfile of UUID and swap offset
sudo findmnt -no UUID -T /swapfile && sudo swap-offset /swapfile
# edit grub file
sudo nano /etc/default/grub
# take grub in file GRUB_CMDLINE_LINUX_DEFAULT the parameter is changed to the following form among UUID and resume_offset replace the value of with the output of the above two commands
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=51f8eab4-d775-4020-aace-0e411ef5b8ed resume_offset=34816"
# Save and exit, and then update grub to configure
sudo update-grub
# edit initramfs
sudo nano /etc/initramfs-tools/conf.d/resume
# Add the following line, UUID replace with actual value
resume=UUID=51f8eab4-d775-4020-aace-0e411ef5b8ed resume_offset=34816
# Save and exit, and then update initramfs to configure
sudo update-initramfs -u -k all
# restart
reboot
# After restart
sudo systemctl hibernate

# see also about [suspend-then-hibernate](https://www.lorenzobettini.it/2020/07/enabling-hibernation-on-ubuntu-20-04/)
```

### Mount apfs

```bash
lsblk -f
sudo apt install libfsapfs-utils
sudo fusermount -u /mnt
sudo fsapfsmount -f 1 /dev/sda2 /mnt
```

### NodeJS tools

```bash
https://github.com/nvm-sh/nvm#installing-and-updating
nvm install --lts
npm install -g apollo
npm install -g firebase-tools
```

### Docker via snap

```bash
sudo addgroup --system docker
sudo adduser $USER docker
newgrp docker
sudo snap disable docker
sudo snap enable docker
```

### Hasura

```bash
https://hasura.io/docs/latest/graphql/core/getting-started/docker-simple.html
```

### Go

```bash
https://go.dev/doc/install
```
