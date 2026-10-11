#!/bin/bash
# общие настройки и функции

G='\033[0;32m'; R='\033[0;31m'; Y='\033[1;33m'; B='\033[0;34m'; N='\033[0m'

WORKDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ART="$WORKDIR/artifacts"

# данные студента
STUDENT_ID="${STUDENT_ID:-372718}"
HOSTNAME_FQDN="mephi-2026.domain.local"

# пользователи-разработчики
USER1="user1"; UID1=5501
USER2="user2"; UID2=5502
USER3="user3"; UID3=5503

# кураторы
CURATOR1="curator1"
CURATOR2="curator2"
CURATOR_GROUP="curators"
CURATOR_GID=4444

PROJECT_DIR="/data/mephi-2026"
WEB_DIR="/mephi-web"
WEB_LABEL="MEPHI_WEB"
DISK="/dev/sdb"

log()  { echo -e "${G}[+]${N} $1"; }
warn() { echo -e "${Y}[!]${N} $1"; }
err()  { echo -e "${R}[-]${N} $1"; }
info() { echo -e "${B}[i]${N} $1"; }

header() {
    echo ""
    echo -e "${B}───────────────────────────────────────────────${N}"
    echo -e "${B}  $1${N}"
    echo -e "${B}───────────────────────────────────────────────${N}"
}

need_root() {
    if [ "$(id -u)" -ne 0 ]; then
        err "запусти скрипт через sudo"
        exit 1
    fi
}

mkdir -p "$ART"