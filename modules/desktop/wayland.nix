{ pkgs, ... }:

{
  programs.niri.enable = true;

  services.displayManager.ly.enable = true;

  services.accounts-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bibata-cursors
  ];
}
