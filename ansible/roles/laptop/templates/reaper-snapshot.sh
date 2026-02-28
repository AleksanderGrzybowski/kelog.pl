#! /bin/bash
set -e

TIMESTAMP=$(date '+%Y-%m-%d_%Hh%Mm%Ss')
BASEFOLDER="reaper-sdg2024-${TIMESTAMP}"
ARCHIVE="reaper-sdg2024-${TIMESTAMP}.tar.xz"
S3_TARGET="s3://kelog-backups/"

cd /tmp
echo "Using folder ${BASEFOLDER} as the temporary place to store files."
mkdir ${BASEFOLDER}
cd ${BASEFOLDER}

echo "SDG-2024..."
cp -ar /mnt/Shared/Reaper/SDG-2024 .
echo "Copy done."
cd ..

echo "Compressing..."
XZ_OPT="-6T0 --memlimit=10000Mi" tar cJf ${ARCHIVE} ${BASEFOLDER}
echo "Compression done."

echo "Copying to S3..."
s3cmd put --recursive --storage-class=ONEZONE_IA --multipart-chunk-size-mb=100 ${ARCHIVE} ${S3_TARGET} 
echo "Copy finished."

