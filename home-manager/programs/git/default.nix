{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "yuys13";
        email = "yuys13@users.noreply.github.com";
      };
      init = {
        defaultbranch = "main";
      };
      commit = {
        verbose = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        useForceIfInclues = true;
      };
      pull = {
        ff = "only";
      };
      rebase = {
        autoStash = true;
        autoSquash = true;
      };
      diff = {
        tool = "nvimdiff";
      };
      difftool = {
        trustExitCode = true;
      };
      merge = {
        tool = "nvimdiff";
      };
      mergetool = {
        "vimdiff".trustExitCode = true;
        "nvimdiff".trustExitCode = true;
      };
      blame = {
        markIgnoredLines = true;
      };
      ghq = {
        root = "~/src";
      };
    };
    ignores = [
      ".envrc"
      ".direnv"
      # nvim 'exrc'
      ".nvim.lua"
      ".nvimrc"
      ".exrc"
    ];
  };

  programs.gh.enable = true;
}
