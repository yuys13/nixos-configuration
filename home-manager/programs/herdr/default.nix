{ pkgs, ... }:
{
  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;
      keys = {
        prefix = "ctrl+q";
      };
    };
  };
}
