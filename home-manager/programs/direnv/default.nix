{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  programs.git.ignores = [
    ".envrc"
    ".direnv"
  ];
}
