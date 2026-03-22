{ pkgs, ... }:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    extraPackages = with pkgs; [
      neovim-remote
      gcc
      gitlint
      tree-sitter
    ];
  };
  home.file.".config/nvim" = {
    source = sources.dotfiles.src + "/home/XDG_CONFIG_HOME/nvim";
    recursive = true;
  };
}
