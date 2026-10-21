{ pkgs, unstable, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # RTX 4060 Laptop. Без этого CUDA собирается под все архитектуры сразу.
  nixpkgs.config.cudaCapabilities = [ "8.9" ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gh
    curl
    htop
    btop
    ncdu
    duf
    fastfetch

    firefox
    telegram-desktop
    libreoffice
    tor-browser
    discord
    obsidian

    go
    kotlin
    jdk
    (python3.withPackages (ps: with ps; [ pip ]))
    vscode
    # В 26.05 собран на Electron 41, помеченном insecure (EOL).
    unstable.opencode-desktop
    unstable.antigravity-cli # бинарь называется agy
    neovim
    jetbrains.idea
    jetbrains.pycharm
    android-studio

    kitty
    ranger
    claude-code
    # CUDA unfree и не лежит в бинарном кеше — собирается локально.
    (llama-cpp.override { cudaSupport = true; })
    krabby

    nemo-with-extensions

    noctalia
    xwayland
    xwayland-satellite

    throne
  ];

  environment.etc."xdg/kitty/kitty.conf".text = ''
    background #222222
    background_opacity 0.85

    shell fish

    confirm_os_window_close 0
    hide_window_decorations yes

    foreground #d8d8d2

    # pastel palette
    color0  #3a3a3a
    color8  #5c5c5c
    color1  #e89a9a
    color9  #f2b3b3
    color2  #a8cfa0
    color10 #c0e0b8
    color3  #e6cd96
    color11 #f0ddb0
    color4  #9fbbdb
    color12 #b8cfe8
    color5  #c5a8d4
    color13 #d9c2e4
    color6  #9ccfc9
    color14 #b8e0da
    color7  #d8d8d2
    color15 #efefe9
  '';

  # Trash, removable media and network mounts for nemo.
  services.gvfs.enable = true;

  programs.steam.enable = true;

  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}
