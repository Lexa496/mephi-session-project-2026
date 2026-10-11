#!/bin/bash
# запуск всех этапов по порядку
set -e
cd "$(dirname "$0")"

REQUIRED=(
    lib.sh
    01_install.sh
    02_packages.sh
    03_fs.sh
    04_services.sh
    05_access.sh
    06_auth.sh
    07_web.sh
    08_artifacts.sh
    09_push.sh
)

MISSING=()
for f in "${REQUIRED[@]}"; do
    [ -f "$f" ] || MISSING+=("$f")
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "не хватает:"
    printf '    %s\n' "${MISSING[@]}"
    exit 1
fi

chmod +x "${REQUIRED[@]}"

# всё кроме пуша — под root
for script in 01_install.sh 02_packages.sh 03_fs.sh 04_services.sh 05_access.sh 06_auth.sh 07_web.sh 08_artifacts.sh; do
    echo ""
    echo -e "\033[1;33m>>> $script\033[0m"
    sudo ./"$script"
done

# пуш от обычного пользователя (там git под своим аккаунтом)
echo ""
echo -e "\033[1;33m>>> 09_push.sh\033[0m"
./09_push.sh || echo -e "\033[0;31mпуш не выполнен (проверь доступ к GitHub)\033[0m"

echo ""
echo -e "\033[0;32mвсе этапы выполнены\033[0m"
ls -la "$PWD"/*.out "$PWD"/mephi-screenshot.png 2>/dev/null || true