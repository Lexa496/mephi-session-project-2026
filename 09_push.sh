#!/bin/bash
source "$(dirname "$0")/lib.sh"

GITHUB_USER="${GITHUB_USER:-Lexa496}"
REPO="mephi-session-project-2026"

header "РАЗДЕЛ 8. Публикация на GitHub"

cd "$WORKDIR"

[ -f mephi-screenshot.png ] || warn "нет mephi-screenshot.png — сделай скриншот вручную"

git init
git branch -M main
git add .
git commit -m "Add MEPHI session project 2026 files" || warn "нечего коммитить"

git remote remove origin 2>/dev/null
git remote add origin "https://github.com/$GITHUB_USER/$REPO.git"
git push -u origin main

info "https://github.com/$GITHUB_USER/$REPO"