{ pkgs, lib, config, ... }: {
  options = { bat.enable = lib.mkEnableOption "Enables Bat config"; };

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "tokoyonight_moon";
      };
      themes = {
        tokoyonight_moon = {
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "tokyonight.nvim";
            rev = "610179f7f12db3d08540b6cc61434db2eaecbcff";
            sha256 = "sha256-mzCdcf7FINhhVLUIPv/eLohm4qMG9ndRJ5H4sFU2vO0=";
          };
          file = "extras/sublime/tokyonight_moon.tmTheme";
        };
      };
    };
  };
}
