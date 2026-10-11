#!/bin/bash
source "$(dirname "$0")/lib.sh"
need_root

header "РАЗДЕЛ 7. Web-страница"

# создаём страницу
echo "Hello from Student: $STUDENT_ID" > "$WEB_DIR/index.html"
chmod 755 "$WEB_DIR"
chmod 644 "$WEB_DIR/index.html"

# убираем дефолтный конфиг nginx
rm -f /etc/nginx/conf.d/default.conf

# конфиг nginx на нашу директорию
cat > /etc/nginx/conf.d/mephi.conf <<EOF
server {
    listen 80;
    server_name localhost;
    root $WEB_DIR;
    index index.html;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# комментируем встроенный server {...} в nginx.conf
if grep -q "^[[:space:]]*server[[:space:]]*{" /etc/nginx/nginx.conf; then
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    awk '
        BEGIN{depth=0; skip=0}
        /^[[:space:]]*server[[:space:]]*\{/ {skip=1; depth=1; print "# " $0; next}
        skip==1 {
            print "# " $0
            n=gsub(/\{/,"{"); m=gsub(/\}/,"}")
            depth+=n-m
            if (depth==0) skip=0
            next
        }
        {print}
    ' /etc/nginx/nginx.conf.bak > /etc/nginx/nginx.conf
fi

# проверяем конфиг и перезапускаем
nginx -t || { err "nginx -t не прошёл"; exit 1; }
systemctl restart nginx
log "nginx перезапущен с $WEB_DIR"

# проверка доступности
curl -s http://localhost/ > "$WORKDIR/curl.out"
cat "$WORKDIR/curl.out"