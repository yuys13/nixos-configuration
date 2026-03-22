{ pkgs, ... }: {
  home.packages = [ pkgs.tig ];
  home.file.".config/tig/config".source = ./config;
}
