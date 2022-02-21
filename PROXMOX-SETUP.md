# Proxmox VE 7.1 Setup

### My Config

> i7 4790K + MSI Gaming 5 + Sapphire Pulse RX580 8GB + NVMe Samsung 960 EVO

### Common References

- [Simple Guide to Install HACKINTOSH with Proxmox](https://www.youtube.com/watch?v=IYrSyNwhfuk)
- [Installing MacOS 12 “Monterey” on Proxmox 7](https://www.nicksherlock.com/2021/10/installing-macos-12-monterey-on-proxmox-7/)

### Prepare Proxmox

⚪️ переключить видеовыход в BIOS на IGC (Integrated Graphic Card) и выполнить сетап с флешки proxmox.iso

⚪️ добавить "non-free" вхождения:

```
nano /etc/apt/sources.list
```

```bash
deb http://ftp.debian.org/debian bullseye main contrib non-free

deb http://ftp.debian.org/debian bullseye-updates main contrib non-free

# security updates
deb http://security.debian.org bullseye-security main contrib
```

⚪️ закомментировать:

```
nano /etc/apt/sources.list.d/pve-enterprise.list
```

```bash
# deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise
```

⚪️ обновить пакеты:

```
apt update && apt upgrade
```

⚪️ исправить "`[Firmware Bug]: TSC_DEADLINE`":

```
apt install intel-microcode
```

⚪️ защитить ssh от перебора:

```
apt install fail2ban
```

... можно "подработать напильником":

```
nano /etc/fail2ban/jail.conf
```

... и посмотреть отчёт:

```
fail2ban-client -v status sshd
```

⚪️ хочется (а надо ли?) поставить amdgpu для RX580 под Debian 11:

```
apt install xserver-xorg-video-amdgpu
```

⚪️ перезагрузить:

```
reboot
```

### Prepare ISOs

- [Create A macOS Monterey Installer ISO](https://www.youtube.com/watch?v=q9koLQSqrlc)

- [Upload OpenCore.iso & Monterey.iso](https://www.youtube.com/watch?v=IYrSyNwhfuk&t=713s)

### Create the VM

⚪️ добавить:

```
nano /etc/pve/qemu-server/100.conf
```

```
args: -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" -smbios type=2 -device usb-kbd,bus=ehci.0,port=2 -global nec-usb-xhci.msi=off -global ICH9-LPC.acpi-pci-hotplug-with-bridge-support=off -cpu host,kvm=on,vendor=GenuineIntel,+kvm_pv_unhalt,+kvm_pv_eoi,+hypervisor,+invtsc
agent: 1
balloon: 0
bios: ovmf
boot: order=ide2;virtio0;net0;ide0
cores: 4
cpu: Penryn
efidisk0: local-lvm:vm-101-disk-1,efitype=4m,size=4M
ide0: local:iso/Monterey.iso,cache=unsafe,size=16G
ide2: local:iso/OpenCore-v16.iso,cache=unsafe
machine: q35
memory: 8128
meta: creation-qemu=6.1.0,ctime=1645377801
name: macos-monterey
net0: virtio=66:8D:22:01:AD:C8,bridge=vmbr0,firewall=1
numa: 1
ostype: other
scsihw: virtio-scsi-pci
smbios1: uuid=ad3aff35-6ecd-4375-a5a7-6cc6f169ccf5
sockets: 1
vga: vmware
virtio0: local-lvm:vm-101-disk-0,cache=unsafe,discard=on,size=64G
vmgenid: 6af8c616-7604-4fda-adcb-9dfc1332fafb
```

### Start Setup

⚪️ команды внутри shell для загрузчика

```
fs0:
System\Library\CoreServices\boot.efi
```

### Make the OpenCore install permanent

Use “`sudo dd if=<source> of=<dest>`” to copy the “EFI” partition from the OpenCore CD and overwrite the EFI partition on the hard disk. The OpenCore CD is the small disk (~150MB) that only has an EFI partition on it, and the main hard disk is the one with the large (>30GB) Apple_APFS “Container” partition on it.

In my case these EFI partitions ended up being called disk1s1 and disk0s1 respectively, so I ran “`sudo dd if=/dev/disk2s1 of=/dev/disk0s1`” (note that if you get these names wrong, you will overwrite the wrong disk and you’ll have to start the installation over again!).

Now shut down the VM, and remove both the OpenCore and the Monterey installer drives from the Hardware tab. On the Options tab, edit the boot order to place your virtio0 disk as the first disk. Boot up. If everything went well, you should see the OpenCore boot menu, and you can select your “Main” disk to boot Monterey.

### Passthrough of PCIe

- [My MacOS Monterey / Proxmox setup](https://www.nicksherlock.com/2018/11/my-macos-vm-proxmox-setup/)
- [Configure Passthrough - Video](https://www.youtube.com/watch?v=IYrSyNwhfuk&t=1721s)
- [Pci passthrough - Official Doc](https://pve.proxmox.com/wiki/Pci_passthrough)

Hardware:

- USB devices (keyboard & mouse)
- PCI Device - GPU as Primary
- Display = none (но из-за этого не работает переключение на GPU)

⚪️ добавить `intel_iommu=on` и `pcie_acs_override=downstream` (оно надо?):

```
nano /etc/default/grub
```

```
...
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on pcie_acs_override=downstream rootdelay=10"
...
```

⚪️ добавить `intel_iommu=on` и `pcie_acs_override=downstream` (оно надо?):

```
nano /etc/kernel/cmdline
```

```
quiet intel_iommu=on pcie_acs_override=downstream rootdelay=10
```

⚪️ добавить:

```
nano /etc/modules
```

```
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

⚪️ добавить:

```
nano /etc/modprobe.d/blacklist.conf
```

```
blacklist nouveau
blacklist nvidia
blacklist nvidiafb
blacklist snd_hda_codec_hdmi
blacklist snd_hda_intel
blacklist snd_hda_codec
blacklist snd_hda_core
blacklist radeon
blacklist amdgpu
```

⚪️ добавить:

```
nano /etc/modprobe.d/kvm.conf
```

```
options kvm ignore_msrs=Y
```

⚪️ добавить:

```
nano /etc/modprobe.d/kvm-intel.conf
```

```bash
# Nested VM support
options kvm-intel nested=Y
```

⚪️ найти ids:

```
$ lspci -nnk
01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev e7)
        Subsystem: Sapphire Technology Limited Radeon RX 570 Pulse 4GB [1da2:e387]
        Kernel driver in use: amdgpu
        Kernel modules: amdgpu
01:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0]
        Subsystem: Sapphire Technology Limited Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1da2:aaf0]
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel
```

... или:

```
$ lspci -n -s 01:00
01:00.0 0300: 1002:67df (rev e7)
01:00.1 0403: 1002:aaf0 (rev a1)
```

... и добавить ids:

```
nano /etc/modprobe.d/vfio-pci.conf
```

```bash
options vfio-pci ids=1002:67df,1002:aaf0 disable_vga=1
# Note that adding disable_vga here will probably prevent guests from booting in SeaBIOS mode
```

⚪️ If your system doesn't support interrupt remapping, you can allow unsafe interrupts with:

```
echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf
```

⚪️ After editing those files you typically need to run `update-grub`, `update-initramfs -k all -u`, then reboot Proxmox.

---

😺 We love cats!
