# qemu-image-builder
qemu-image-builder is a cross-platform image build repository that provides reusable batch scripts for creating QEMU disk images on Windows, and MacOS, supporting both x86_64 (AMD64) and ARM64 architectures.

## Layout
- `win/x86/` — Windows host, x86_64 guest (WHPX). Uses `iso/ubuntu-25.10-amd64.iso` and `images/amd_pilotos.qcow2`.
- `macos/arm/` — macOS host, ARM64 guest (HVF). Uses `iso/ubuntu-25.10-arm64.iso` and `images/arm_pilotos.qcow2`.

In each directory: `bake` runs the installer ISO, `boot` runs the installed image with SPICE compression on, `boot-compressed` runs it with all SPICE compression disabled.

## Usage

Before running `bake`, create the target qcow2 image. Default size is **50G**.

### Windows (x86_64 guest)
```cmd
qemu-img create -f qcow2 images\amd_pilotos.qcow2 50G
win\x86\bake.bat
```

### macOS (ARM64 guest)
```sh
qemu-img create -f qcow2 images/arm_pilotos.qcow2 50G
./macos/arm/bake.sh
```

Drop the matching ISO into `iso/` first (`ubuntu-25.10-amd64.iso` for x86, `ubuntu-25.10-arm64.iso` for ARM).

### Installer walk-through

1. `bake` opens a QEMU window and lands on the GRUB menu — select **Try or Install Ubuntu** (the default top entry).
2. Once the live desktop loads, launch **Install Ubuntu** and step through the installer, using the whole virtio disk as the target.
3. When the installer prompts to restart, **shut down** instead — `bake` keeps the ISO attached with `-boot d`, so a reboot lands you back in the installer.
4. From the next run onward, use `boot` (or `boot-compressed`) instead of `bake`.