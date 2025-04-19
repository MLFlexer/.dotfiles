{ config, lib, pkgs_unstable, ... }:
let config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in {
  options = { nvim.enable = lib.mkEnableOption "enables Nvim"; };

  config = lib.mkIf config.nvim.enable {

    home.packages = with pkgs_unstable; [ neovim ];

    home.file = {
      "nvim" = {
        enable = true;
        source = "${config_sym_dir}/nvim";
        recursive = true;
        target = ".config/nvim";
      };
    };

  };
}
