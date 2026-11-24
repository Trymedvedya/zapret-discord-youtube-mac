# ZapretMac для Discord и YouTube

[Скачайте ZapretMac 1.1.2 для macOS 14 и новее](https://github.com/Flowseal/zapret-mac-discord-youtube/releases/download/1.1.2/ZapretMac-macOS-universal.zip). В архиве одно приложение `ZapretMac.app` для Apple Silicon и Intel. Оно обрабатывает TCP и UDP на уровне сети macOS, поэтому прокси в браузере или Discord настраивать не нужно. [Проект Flowseal для macOS](https://github.com/Flowseal/zapret-mac-discord-youtube/tree/1.1.2)

## Запуск

1. Распакуйте ZIP на Mac и откройте `ZapretMac.app` двойным щелчком в Finder.
2. Нажмите значок ZapretMac в строке меню macOS, выберите стратегию `general` и нажмите **Запустить**. При запросе подтвердите запуск системной службы от имени администратора. Если знаете, какая стратегия работает у вас на Windows, начните с одноимённой, если она есть в меню.
3. Откройте Discord Desktop, войдите в голосовой канал и проверьте звук в обе стороны. Для остановки выберите **Остановить** в меню ZapretMac.

Приложение использует системную маршрутизацию. Если на Mac включён другой VPN с туннелированием, отключите его на время проверки. Если macOS запрашивает разрешение на открытие приложения, проверьте источник архива и воспользуйтесь настройками «Конфиденциальность и безопасность» для разрешения именно этого приложения. [Инструкция Flowseal](https://github.com/Flowseal/zapret-mac-discord-youtube/tree/1.1.2) · [Инструкция Apple](https://support.apple.com/en-us/102445)

## Как работает голос Discord

Когда вы нажимаете **Запустить**, приложение запускает системную службу. Правила `pf` направляют выбранные исходящие IPv4-пакеты TCP и UDP в локальный интерфейс `utun`. Движок `utunws` применяет выбранную стратегию и отправляет пакеты через физический сетевой интерфейс с помощью BPF. Соединения идут к исходным адресатам. [Маршрутизация](https://github.com/Flowseal/zapret-mac-discord-youtube/blob/1.1.2/macos/Payload/run.sh) · [Движок](https://github.com/Flowseal/zapret-mac-discord-youtube/blob/1.1.2/nfq/nfqws.c)

Discord использует отдельное UDP-соединение для звука. Профиль `general` распознаёт пакеты установления этого соединения и отправляет дополнительные пакеты, чтобы помешать DPI распознать соединение. Аудио передаётся по штатному зашифрованному протоколу Discord. [Голосовой профиль ZapretMac](https://github.com/Flowseal/zapret-mac-discord-youtube/blob/1.1.2/macos/Payload/strategies/general.conf.in) · [Документация Discord](https://docs.discord.com/developers/topics/voice-connections)

## Списки и проверка

Голосовой профиль `general` в ZapretMac использует тот же файл `ACTIVE_DISCORD_UDP.bin`, что и эта Windows-сборка. В приложении есть собственные стартовые списки, и некоторые из них отличаются по ревизии от списков в этом репозитории. После первого запуска приложение создаёт папку `~/Library/Application Support/ZapretMac/lists` для редактирования списков. [Профиль general](https://github.com/Flowseal/zapret-mac-discord-youtube/blob/1.1.2/macos/Payload/strategies/general.conf.in)

Проверены контрольная сумма архива, наличие сборок для двух архитектур и профиль UDP. Реальный звонок на Mac нужно проверить на вашей сети.

Предыдущая [сборка с SOCKS5](SOCKS.md) предназначена для браузера и поддерживает только TCP.
