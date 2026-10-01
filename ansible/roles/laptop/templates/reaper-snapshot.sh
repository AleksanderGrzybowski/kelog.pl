#!/bin/bash
set -e

TIMESTAMP=$(date '+%Y-%m-%d_%Hh%Mm%Ss')
BASEFOLDER="reaper-sdg2026-${TIMESTAMP}"
ARCHIVE="reaper-sdg2026-${TIMESTAMP}.tar.xz"
S3_TARGET="s3://kelog-backups/"

cd /tmp
echo "Using folder ${BASEFOLDER} as the temporary place to store files."
mkdir "${BASEFOLDER}"
trap 'rm -rf "/tmp/${BASEFOLDER}" "/tmp/${ARCHIVE}"' EXIT
cd "${BASEFOLDER}"

# Copy first and compress the copy, so the archive is a consistent snapshot
# even if the project changes in Reaper while compressing.
echo "SDG-2026..."
cp -ar /mnt/Shared/Reaper/SDG-2026 .
echo "Copy done."
cd ..

echo "Compressing..."
XZ_OPT="-6T0 --memlimit=10000Mi" tar cJf "${ARCHIVE}" "${BASEFOLDER}"
echo "Compression done."

echo "Copying to S3..."
s3cmd put --recursive --storage-class=ONEZONE_IA --multipart-chunk-size-mb=100 "${ARCHIVE}" "${S3_TARGET}"
echo "Copy finished."

