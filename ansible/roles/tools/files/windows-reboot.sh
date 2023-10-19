#! /bin/bash
set -e
grub-reboot "$(grep -i windows /boot/grub/grub.cfg|cut -d"'" -f2)" && reboot
