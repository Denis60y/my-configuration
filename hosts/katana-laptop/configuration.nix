{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hardware.nix
    ./modules/applications.nix

    ../../modules/core.nix
    ../../modules/desktop/wayland.nix
    ../../modules/desktop/x11.nix
    ../../modules/users/pitt0n.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "katana-laptop";

  system.stateVersion = "26.05";
}
