#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 2. Управление ПО"

# 2.1 обновление
dnf -y update

# 2.2 установка из репозиториев
dnf -y install nginx libcap-ng-utils

# 2.3 локальный RPM
cd /tmp
dnf -y download tcpdump
rpm -ivh tcpdump*.rpm

# 2.3 история транзакций
dnf history > "$WORKDIR/dnf.out"
log "dnf.out сохранён"