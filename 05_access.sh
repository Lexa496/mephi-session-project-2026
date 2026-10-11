#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 5. Управление доступом"

# ---- 5.1 DAC ----
groupadd -g "$CURATOR_GID" "$CURATOR_GROUP" 2>/dev/null

useradd -u "$UID1" -m -s /bin/bash "$USER1"
useradd -u "$UID2" -m -s /bin/bash "$USER2"
useradd -u "$UID3" -m -s /bin/bash "$USER3"
useradd -g "$CURATOR_GROUP" -m -s /bin/bash "$CURATOR1"
useradd -g "$CURATOR_GROUP" -m -s /bin/bash "$CURATOR2"

# общая группа для разработчиков
groupadd devs 2>/dev/null
usermod -aG devs "$USER1"
usermod -aG devs "$USER2"
usermod -aG devs "$USER3"

# директория проекта
mkdir -p "$PROJECT_DIR"
chown root:devs "$PROJECT_DIR"
chmod 2770 "$PROJECT_DIR"    # setgid + rwx для devs, ничего остальным

setfacl -m g:devs:rwx "$PROJECT_DIR"
setfacl -m g:"$CURATOR_GROUP":r-x "$PROJECT_DIR"
setfacl -m o::--- "$PROJECT_DIR"

# наследование ACL на новые файлы
setfacl -d -m g:devs:rwx "$PROJECT_DIR"
setfacl -d -m g:"$CURATOR_GROUP":r-x "$PROJECT_DIR"
setfacl -d -m o::--- "$PROJECT_DIR"

log "DAC настроен для $PROJECT_DIR"

# ---- 5.2 привилегии tcpdump ----
TCPDUMP=$(command -v tcpdump)
setcap cap_net_raw,cap_net_admin+eip "$TCPDUMP"
chmod u-s "$TCPDUMP"
log "tcpdump: setcap выставлен, set-UID снят"

# проверка
sudo -u "$USER1" "$TCPDUMP" -c 1 -i lo >/dev/null 2>&1 && log "user1 может запускать tcpdump" || warn "проверь tcpdump"

# ---- 5.3 SELinux ----
setenforce 1
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

# разрешить nginx отдавать файлы из /mephi-web
semanage fcontext -a -t httpd_sys_content_t "$WEB_DIR(/.*)?"
restorecon -Rv "$WEB_DIR"

log "SELinux enforcing, контекст для $WEB_DIR настроен"