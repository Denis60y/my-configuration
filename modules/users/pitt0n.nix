{ pkgs, ... }:

{
  users.users."pitt0n" = {
    isNormalUser = true;
    description = "Pitt0n";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.fish;
    packages = with pkgs; [ ];
  };
}
