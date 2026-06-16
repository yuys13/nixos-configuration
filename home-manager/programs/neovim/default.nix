{ pkgs, ... }:
let
  sources = pkgs.callPackage ../../../_sources/generated.nix { };

  # Build merged SKK dictionary at build time! ✨
  merged-skk-jisyo = pkgs.stdenv.mkDerivation {
    name = "merged-skk-jisyo";
    nativeBuildInputs = [ pkgs.skktools ];
    dicts = with pkgs.skkDictionaries; [
      l
      jinmei
      geo
      station
      propernoun
      zipcode
    ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out
      args=""
      for dict in $dicts; do
        jisyo=$(find $dict -name "SKK-JISYO.*" | head -n 1)
        if [ -n "$args" ]; then
          args="$args + $jisyo"
        else
          args="$jisyo"
        fi
      done
      skkdic-expr2 $args > $out/SKK-JISYO.L
    '';
  };
in
{
  # Link the merged dictionary to the expected path 💎
  home.file.".local/share/nvim/eskk/SKK-JISYO.L".source = "${merged-skk-jisyo}/SKK-JISYO.L";

  programs.git.ignores = [
    ".nvim.lua"
    ".nvimrc"
    ".exrc"
  ];

  programs.fish.functions.vi = {
    wraps = "$EDITOR";
    description = "alias vi $EDITOR";
    body = ''
      if test -z "$EDITOR"
          command vi $argv
      else
          eval $EDITOR $argv
      end
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;
    sideloadInitLua = true;

    extraPackages = with pkgs; [
      neovim-remote
      gcc
      gitlint
      tree-sitter
      ripgrep
      fd
      stylua
      shfmt
      shellcheck
      hadolint
      actionlint
      checkmake
      markdownlint-cli
      ruff
      yamlfmt
      # Language Servers 🛠✨
      vscode-langservers-extracted
      yaml-language-server
      nixd
      nil
      lua-language-server
    ];
  };
}
