#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 4. Сервисы"

# 4.1 nginx
systemctl enable --now nginx
log "nginx запущен и добавлен в автозагрузку"

# 4.2 журнал
journalctl -u nginx -b > "$WORKDIR/journalctl.out"
log "journalctl.out сохранён"