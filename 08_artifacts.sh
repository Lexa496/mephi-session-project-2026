#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 8. Артефакты и GitHub"

# собираем все нужные .out
history > "$WORKDIR/history.out" 2>/dev/null || cp ~/.bash_history "$WORKDIR/history.out"
ping -c 4 8.8.8.8 > "$WORKDIR/ping.out"
stat "$PROJECT_DIR" > "$WORKDIR/stat.out"
stat "$WEB_DIR" >> "$WORKDIR/stat.out"
getcap "$(command -v tcpdump)" > "$WORKDIR/getcap.out"
dnf history > "$WORKDIR/dnf.out"
journalctl -u nginx -b > "$WORKDIR/journalctl.out"
getenforce > "$WORKDIR/getenforce.out"
curl http://localhost/ > "$WORKDIR/curl.out"

# системные файлы
cp /etc/fstab                       "$WORKDIR/fstab"
cp /etc/passwd                      "$WORKDIR/passwd"
cp /etc/shadow                      "$WORKDIR/shadow"
cp /etc/group                       "$WORKDIR/group"
cp /etc/security/pwquality.conf     "$WORKDIR/pwquality.conf"

log "все артефакты собраны"
ls -la "$WORKDIR"