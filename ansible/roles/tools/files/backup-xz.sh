#! /bin/bash
set -e

TIMESTAMP=$(date '+%Y-%m-%d_%Hh%Mm%Ss')
BASEFOLDER="backup-${TIMESTAMP}"
ARCHIVE="backup-${TIMESTAMP}.tar.xz"
EXTERNAL="/media/kelog/SAMSUNG-EXT4/kelog-backups/"
S3_TARGET="s3://kelog-backups/"

cd /tmp

echo "Using folder ${BASEFOLDER} as the temporary place to store files."
mkdir ${BASEFOLDER}
cd ${BASEFOLDER}

echo "Thunderbird..."
cp -ar /mnt/Dysk/dot_thunderbird .

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
cp -a /mnt/Shared/Reaper .

echo "Done."
cd ..

XZ_OPT="-6T0 --memlimit=10000Mi" tar cJf ${ARCHIVE} ${BASEFOLDER}
echo "Copying to external disk..."
cp -r ${ARCHIVE} ${EXTERNAL}
echo "Copying finished."
ls -l "${EXTERNAL}/${ARCHIVE}"
du -sh "${EXTERNAL}/${ARCHIVE}"

echo "Copying to S3..."
s3cmd put --recursive --storage-class=ONEZONE_IA --multipart-chunk-size-mb=500 ${ARCHIVE} ${S3_TARGET} 
echo "Copy finished."

