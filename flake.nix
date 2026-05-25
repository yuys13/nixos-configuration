{
  description = "Paradise";

  nixConfig = {
    extra-substituters = [
      "https://yuys13.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "yuys13.cachix.org-1:t6ghTZgSjyY/d4310E7ZxICuAAOLWjY4bWEdcVw7sl8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.flake-parts.follows = "flake-parts";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      treefmt-nix,
      nixvim,
      nix-index-database,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        treefmt-nix.flakeModule
      ];

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
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;

                  users.yuys13 = {
                    imports = [
                      ./home-manager/sway.nix
                      ./home-manager/home.nix
                      nixvim.homeModules.nixvim
                      nix-index-database.homeModules.default
                    ];
                  };
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
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              config.allowUnfree = true;
            }; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = {
              inherit inputs;
              outputs = self.outputs;
            };
            # > Our main home-manager configuration file <
            modules = [
              ./home-manager/home.nix
              nixvim.homeModules.nixvim
              nix-index-database.homeModules.default
            ];
          };
        };
      };

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              biome.enable = true;
              nixfmt.enable = true;
              stylua.enable = true;
              taplo.enable = true;
              yamlfmt.enable = true;
            };
            settings.global.excludes = [ "_sources/**" ];
          };
        };
    };
}
