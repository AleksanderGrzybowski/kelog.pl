#! /bin/bash
set -e
whoami
grub-reboot "$(grep -i windows /boot/grub/grub.cfg|cut -d"'" -f2)" && reboot
