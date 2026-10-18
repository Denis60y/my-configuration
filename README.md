# my-configuration

NixOS-конфигурация в виде флейка. Сейчас описан один хост — `katana-laptop`, но структура
рассчитана на несколько машин (планируются сервер и второй ноутбук).

## Как применять

```sh
sudo nixos-rebuild switch --flake ~/my-configuration#katana-laptop
```

Проверить сборку без переключения системы:

```sh
sudo nixos-rebuild build --flake ~/my-configuration#katana-laptop
```

Обновить версии из `flake.lock`:

```sh
nix flake update
```

## Структура

```
flake.nix                      вход: входные каналы и список хостов
flake.lock                     зафиксированные ревизии входов
hosts/
  katana-laptop/
    configuration.nix          что входит в этот хост + настройки самого хоста
    hardware-configuration.nix сгенерировано nixos-generate-config, руками не править
    modules/
      hardware.nix             железо именно этой машины
      applications.nix         софт, установленный на этой машине
modules/                       общие модули, подключаемые любым хостом
  core.nix                     базовые системные настройки
  desktop/
    wayland.nix                niri, display manager, темы
    x11.nix                    xserver и раскладка клавиатуры
  users/
    pitt0n.nix                 учётная запись пользователя
```

### flake.nix

Входы: `nixpkgs` с ветки `nixos-26.05`. Выход: `nixosConfigurations.katana-laptop`, который
собирается из одного импорта — `hosts/katana-laptop/configuration.nix`. Новый хост добавляется
новой записью в `nixosConfigurations`.

### hosts/katana-laptop/configuration.nix

Точка сборки хоста. В `imports` перечислено всё, что в него входит: локальные модули хоста и
нужные общие модули из корневого `modules/`. Здесь же лежат настройки, которые бессмысленны вне
этой машины: загрузчик (`systemd-boot`), `networking.hostName` и `system.stateVersion`.

### hosts/katana-laptop/modules/hardware.nix

Графика (NVIDIA), bluetooth, `brillo` для яркости, `upower`. Все настройки железа, написанные
руками, живут здесь — не в `hardware-configuration.nix`.

### hosts/katana-laptop/modules/applications.nix

`environment.systemPackages` и `allowUnfree`. Пакеты, установленные системно на этой машине.
Пакеты, привязанные к пользователю, а не к машине, идут в `modules/users/pitt0n.nix`.

### modules/

Модули, не привязанные к конкретному железу. Хост сам решает, что из них импортировать: если
второму ноутбуку или серверу какой-то модуль не нужен, он просто его не подключает.

## Принятые решения

**Хост — отдельная директория.** Даже при одном хосте layout сделан на вырост: сервер и второй
ноутбук получат свои `hosts/<имя>/`, но будут переиспользовать корневой `modules/`.

**`hardware-configuration.nix` не редактируется.** Он генерируется `nixos-generate-config` и
перезапись файла затрёт любые ручные правки. Всё написанное руками — в `modules/hardware.nix`
рядом.

**PRIME/Optimus не настраивается — и это намеренно.** Ноутбук переведён в discrete-only режим:
RTX 4060 Mobile на `0000:01:00.0` — единственная видеокарта, Intel iGPU в PCI не появляется
вовсе, и все выходы, включая внутренний `eDP-1`, висят на NVIDIA. Практическое следствие:
сломанный драйвер NVIDIA — это чёрный экран без запасной видеокарты, поэтому к изменениям в
`hardware.nvidia` стоит относиться осторожно и держать под рукой предыдущую генерацию в меню
загрузчика.

**Конфиг niri не в репозитории.** Он лежит в `~/.config/niri/config.kdl` и правится вручную.
`programs.niri` из nixpkgs умеет только `enable`/`package`/`useNautilus`, так что управлять
содержимым конфига можно было бы только через сторонний `niri-flake`
(`programs.niri.settings`), `environment.etc` или home-manager. Решено оставить вручную; вернуться
к вопросу, когда появится второй хост и шаринг настроек niri станет полезен.

**`core.nix` остаётся общим, а не переезжает в хост.** Почти всё его содержимое — flakes,
таймзона, локали — одинаково на любой машине, и дублировать это по хостам смысла нет. Единственная
строка, которая реально разойдётся, — `networking.networkmanager.enable`: на сервере будет
`systemd-networkd`. Переносить её в хост имеет смысл тогда, когда сервер действительно появится.
