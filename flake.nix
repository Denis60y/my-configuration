{
  description = "NixOS configuration(s)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Отдельные пакеты, которых ещё нет в стабильной ветке, берутся отсюда.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }: {
    nixosConfigurations.katana-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        # nixpkgs.config.allowUnfree не распространяется на этот набор —
        # unfree разрешается для него отдельно.
        unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
      modules = [
        ./hosts/katana-laptop/configuration.nix
      ];
    };
  };
}
