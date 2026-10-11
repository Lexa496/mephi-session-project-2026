#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 6. Аутентификация"

# 6.1 кураторам запретить локальный вход
for u in "$CURATOR1" "$CURATOR2"; do
    usermod -s /sbin/nologin "$u"
done
log "кураторам запрещён локальный вход"

# 6.2 пароли
# каждые 90 дней
for u in "$USER1" "$USER2" "$USER3" "$CURATOR1" "$CURATOR2"; do
    chage -M 90 "$u"
done

# минимальная длина 12
sed -i 's/^#\?minlen.*/minlen = 12/' /etc/security/pwquality.conf
grep -q '^minlen' /etc/security/pwquality.conf || echo 'minlen = 12' >> /etc/security/pwquality.conf

log "срок пароля 90 дней, minlen=12"