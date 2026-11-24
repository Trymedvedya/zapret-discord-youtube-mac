# Zapret для macOS

Эта пробная сборка использует `tpws` из официального релиза Zapret v72.13 для Apple Silicon и Intel. Она рассчитана на YouTube и веб-Discord в браузере через локальный SOCKS5. Запуску не нужны права администратора. Настройки сети macOS, DNS и PF остаются прежними. [Документация Zapret для macOS](https://github.com/bol-van/zapret/blob/v72.13/docs/bsd.md)

## Запуск

1. Распакуйте архив на Mac. В Терминале перейдите в папку `zapret-macos`, где лежат подпапки `macos` и `lists`. Если запускаете из Git, перейдите в корень репозитория.
2. Запустите прокси и оставьте окно Терминала открытым.

   ```sh
   sh macos/start.sh
   ```

3. В другом окне Терминала выполните команду ниже, если установлен Google Chrome. Она откроет YouTube и Discord в отдельном профиле Chrome с этим прокси.

   ```sh
   open -na "Google Chrome" --args \
     --user-data-dir="$HOME/Library/Application Support/Chrome Zapret" \
     --proxy-server=socks5://127.0.0.1:9876 \
     https://www.youtube.com/ https://discord.com/app
   ```

   Для Firefox можно включить ручную настройку прокси, указать только SOCKS v5 `127.0.0.1`, порт `9876`, и включить проксирование DNS через SOCKS v5. [Как Chrome использует SOCKS5](https://chromium.googlesource.com/chromium/src/+/HEAD/net/docs/proxy.md#SOCKSv5-proxy-scheme)

4. На YouTube запустите видео. В Discord проверьте, загружается ли список каналов и можно ли отправить текстовое сообщение. Закройте отдельное окно Chrome и нажмите `Ctrl+C` в окне с прокси, чтобы закончить работу.

## Проверка

```sh
sh macos/start.sh --check
```

Команда проверяет запуск бинарника, параметры и чтение списков. Оставьте прокси запущенным и проверьте соединение следующими командами в другом окне Терминала.

```sh
curl --noproxy "" --proxy socks5h://127.0.0.1:9876 -I --max-time 15 https://www.youtube.com/
curl --noproxy "" --proxy socks5h://127.0.0.1:9876 -I --max-time 15 https://discord.com/
```

Ответ HTTP означает, что запрос дошёл до сервера, но воспроизведение видео и вход в Discord проверяются в браузере. Если соединение с `127.0.0.1:9876` отклонено, посмотрите вывод в окне запуска. При ошибке разрешения имени проверьте системный DNS macOS. В этом режиме `tpws` использует резолвер системы.

## Списки и совместимость

- К каким доменам применять обработку TCP, задают `lists/list-general.txt` и `lists/list-google.txt`. Исключения читаются из `lists/list-exclude.txt` и `lists/ipset-exclude.txt`. Если рядом есть соответствующие файлы `*-user.txt`, они тоже загружаются.
- Голосовые каналы Discord и QUIC работают по UDP. В этой сборке YouTube использует HTTPS по TCP. Совместимость с приложением Discord Desktop не проверялась.
- Бинарник `macos/bin/tpws` взят из `binaries/mac64/tpws` официального архива v72.13. Его SHA-256 — `441524a76f52597a0e5c816d25ed1adfd93e5c34cc56c56e0dc00533929d1761`. [Релиз bol-van/zapret v72.13](https://github.com/bol-van/zapret/releases/tag/v72.13)
