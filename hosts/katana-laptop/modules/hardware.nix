{ ... }:

{
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.brillo.enable = true;

  services.upower.enable = true;
}
