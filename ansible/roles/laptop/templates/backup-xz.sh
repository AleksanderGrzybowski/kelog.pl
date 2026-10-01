#!/bin/bash
set -e

TIMESTAMP=$(date '+%Y-%m-%d_%Hh%Mm%Ss')
BASEFOLDER="backup-${TIMESTAMP}"
ARCHIVE="backup-${TIMESTAMP}.tar.xz"
EXTERNAL="/media/kelog/SAMSUNG-EXT4/kelog-backups"
S3_TARGET="s3://kelog-backups/"

if [[ ! -d "${EXTERNAL}" ]]; then
  echo "External disk is not mounted: ${EXTERNAL} not found." >&2
  exit 1
fi

cd /tmp

echo "Using folder ${BASEFOLDER} as the temporary place to store files."
mkdir "${BASEFOLDER}"
trap 'rm -rf "/tmp/${BASEFOLDER}" "/tmp/${ARCHIVE}"' EXIT
cd "${BASEFOLDER}"

echo "Thunderbird..."
cp -a /mnt/Dysk/dot_thunderbird .

echo "Chrome..."
cp -a /mnt/Dysk/dot_config_google-chrome .

echo "Kodzenie..."
cp -a /mnt/Dysk/Kodzenie .

echo "stuff..."
cp -a /mnt/Dysk/stuff .

echo "Dropbox..."
cp -a /mnt/Dysk/Dropbox .

echo "MuseScore..."
cp -a /mnt/Shared/MuseScore .

echo "SSH keys..."
cp -a /home/kelog/.ssh dot_ssh

echo "Reaper projects..."
cp -a /mnt/Shared/Reaper/SDG-2026 .

echo "Done."
cd ..

XZ_OPT="-6T0 --memlimit=10000Mi" tar cJf "${ARCHIVE}" "${BASEFOLDER}"
echo "Copying to external disk..."
cp "${ARCHIVE}" "${EXTERNAL}/"
echo "Copying finished."
ls -l "${EXTERNAL}/${ARCHIVE}"
du -sh "${EXTERNAL}/${ARCHIVE}"

echo "Copying to S3..."
s3cmd put --storage-class=ONEZONE_IA --multipart-chunk-size-mb=100 "${ARCHIVE}" "${S3_TARGET}"
echo "Copy finished."

