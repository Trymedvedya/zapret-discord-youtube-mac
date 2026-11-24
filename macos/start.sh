#!/bin/sh
set -eu

case "$#:${1-}" in
    0:|1:--check) ;;
    *)
        printf '%s\n' 'Использование: sh macos/start.sh [--check]' >&2
        exit 2
        ;;
esac

if [ "$(uname -s)" != Darwin ]; then
    printf '%s\n' 'Этот скрипт запускается на macOS.' >&2
    exit 1
fi

check=${1-}
macos_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
lists_dir="$macos_dir/../lists"
tpws="$macos_dir/bin/tpws"

if [ ! -f "$tpws" ]; then
    printf 'Не найден %s. Распакуйте сборку полностью.\n' "$tpws" >&2
    exit 1
fi
if [ ! -x "$tpws" ]; then
    chmod u+x "$tpws"
fi

set -- --socks --bind-addr=127.0.0.1 --port=9876 \
    --filter-tcp=80,443,2053,2083,2087,2096,8443 \
    --split-pos=1,midsld \
    "--hostlist=$lists_dir/list-general.txt" \
    "--hostlist=$lists_dir/list-google.txt" \
    "--hostlist-exclude=$lists_dir/list-exclude.txt" \
    "--ipset-exclude=$lists_dir/ipset-exclude.txt"

if [ -f "$lists_dir/list-general-user.txt" ]; then
    set -- "$@" "--hostlist=$lists_dir/list-general-user.txt"
fi
if [ -f "$lists_dir/list-exclude-user.txt" ]; then
    set -- "$@" "--hostlist-exclude=$lists_dir/list-exclude-user.txt"
fi
if [ -f "$lists_dir/ipset-exclude-user.txt" ]; then
    set -- "$@" "--ipset-exclude=$lists_dir/ipset-exclude-user.txt"
fi

if [ "$check" = --check ]; then
    exec "$tpws" --dry-run "$@"
fi

printf '%s\n' 'Zapret для macOS. SOCKS5 127.0.0.1:9876. Для остановки нажмите Ctrl+C.'
exec "$tpws" "$@"
