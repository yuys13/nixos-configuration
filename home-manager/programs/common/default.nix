{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-output-monitor

    zip
    xz
    unzip
    p7zip

    ripgrep
    jq
    eza

    emacs
    nixfmt
    stylua
    selene
  ];

  programs.fd.enable = true;
}
