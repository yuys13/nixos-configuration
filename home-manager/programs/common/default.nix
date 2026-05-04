{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip

    ripgrep
    jq
    eza
    ghq

    emacs
    nixfmt
    stylua
    selene
  ];

  programs.fd.enable = true;
}
