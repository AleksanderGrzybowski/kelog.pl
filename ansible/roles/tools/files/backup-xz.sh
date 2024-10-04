#! /bin/bash
set -e

TIMESTAMP=$(date '+%Y-%m-%d_%Hh%Mm%Ss')
BASEFOLDER="backup-${TIMESTAMP}"
EXTERNAL="/media/kelog/SAMSUNG-EXT4/kelog-backups/"
S3_TARGET="s3://kelog-backups/"

echo "Using folder ${BASEFOLDER} as the temporary place to store files."
mkdir ${BASEFOLDER}
cd ${BASEFOLDER}

echo "Thunderbird..."
tar cJf "dot_thunderbird-${TIMESTAMP}.tar.xz" -C /mnt/Dysk dot_thunderbird

echo "Chrome..."
tar cJf "dot_config_google-chrome-${TIMESTAMP}.tar.xz" -C /mnt/Dysk dot_config_google-chrome

echo "Kodzenie..."
tar cJf "Kodzenie-${TIMESTAMP}.tar.xz" -C /mnt/Dysk/ --exclude=node_modules --exclude=.gradle --exclude=build Kodzenie

echo "stuff..."
tar cJf "stuff-${TIMESTAMP}.tar.xz" -C /mnt/Dysk/ stuff

echo "Dropbox..."
tar cJf "dropbox-${TIMESTAMP}.tar.xz" -C /mnt/Dysk/ Dropbox

echo "MuseScore..."
tar cJf "musescore-${TIMESTAMP}.tar.xz" -C /mnt/Shared/ MuseScore2

echo "SSH keys..."
tar cJf "dot_ssh-${TIMESTAMP}.tar.xz" -C /home/kelog .ssh 

echo "Done."
cd ..

echo "Copying to external disk..."
cp -r ${BASEFOLDER} "${EXTERNAL}"
echo "Copying finished."
ls -l "${EXTERNAL}/${BASEFOLDER}"
du -sh "${EXTERNAL}/${BASEFOLDER}"

echo "Copying to S3..."
s3cmd put --recursive --storage-class=ONEZONE_IA ${BASEFOLDER} ${S3_TARGET} 
echo "Copy finished."

