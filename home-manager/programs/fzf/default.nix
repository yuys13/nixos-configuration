{ pkgs, ... }: {
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--layout reverse"
      "--height 40%"
    ];
    changeDirWidgetCommand = "fd -t d";
    changeDirWidgetOptions = [ "--preview 'eza --icons --tree --level=1 --color=always {}'" ];
    fileWidgetCommand = "fd -t f -L -H -E .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=header,grid --line-range :100 {}'"
    ];
  };
}
