#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"

qemu-system-aarch64 \
  -accel hvf \
  -machine virt,gic-version=3 \
  -cpu host \
  -smp 4 \
  -m 4G \
  -bios edk2-aarch64-code.fd \
  -drive file="$HERE/../../images/arm_pilotos.qcow2",format=qcow2,if=virtio \
  -cdrom "$HERE/../../iso/ubuntu-25.10-arm64.iso" \
  -boot d \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp:127.0.0.1:2222-:22 \
  -device virtio-gpu-pci \
  -display cocoa \
  -device qemu-xhci,id=usb \
  -device usb-kbd \
  -device usb-tablet \
  -audiodev coreaudio,id=snd0 \
  -device ich9-intel-hda \
  -device hda-output,audiodev=snd0