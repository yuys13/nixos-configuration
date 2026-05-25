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
        useForceIfIncludes = true;
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
    };
  };

  programs.gh.enable = true;
}
