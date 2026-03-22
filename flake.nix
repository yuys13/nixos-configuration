{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#your-hostname'
        nixosConfigurations = {
          # FIXME replace with your hostname
          hyper-nixos = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              outputs = self.outputs;
            };
            # > Our main nixos configuration file <
            modules = [
              ./nixos/configuration.nix

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users.yuys13 = {
                  imports = [
                    ./home-manager/sway.nix
                    ./home-manager/home.nix
                  ];
                };
              }
            ];
          };
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager --flake .#your-username@your-hostname'
        homeConfigurations = {
          # FIXME replace with your username@hostname
          "yuys13" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = {
              inherit inputs;
              outputs = self.outputs;
            };
            # > Our main home-manager configuration file <
            modules = [ ./home-manager/home.nix ];
          };
        };
      };

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          # ... your perSystem configuration here ...
        };
    };
}
