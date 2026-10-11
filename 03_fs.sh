#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 3. Файловые системы"

# 3.1 раздел на всём диске + ext4 с меткой
parted -s "$DISK" mklabel gpt
parted -s "$DISK" mkpart primary ext4 0% 100%
sleep 2
PART="${DISK}1"
mkfs.ext4 -L "$WEB_LABEL" "$PART"
log "создан $PART с меткой $WEB_LABEL"

# 3.2 точка монтирования
mkdir -p "$WEB_DIR"

# монтирование по метке
FSTAB_LINE="LABEL=$WEB_LABEL  $WEB_DIR  ext4  defaults  0 0"
grep -q "$WEB_LABEL" /etc/fstab || echo "$FSTAB_LINE" >> /etc/fstab
log "запись в /etc/fstab добавлена"

mount -a
log "раздел смонтирован в $WEB_DIR"