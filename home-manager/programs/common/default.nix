{ pkgs, ... }: {
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
    nil
    nixd
    nixfmt
    stylua
    selene
    lua-language-server
  ];

  programs.bat.enable = true;
  programs.fd.enable = true;
}
