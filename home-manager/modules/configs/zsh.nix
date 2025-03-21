{ config, lib, pkgs, ... }:
let config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in {
  options = { zsh.enable = lib.mkEnableOption "Enables Zsh config"; };

  config = lib.mkIf config.zsh.enable {
    home.packages = with pkgs; [
      zsh
      zsh-autosuggestions
      zsh-completions
      zsh-powerlevel10k
      zsh-syntax-highlighting
    ];

    home.file = {
      ".zshenv" = {
        enable = true;
        source = "${config_sym_dir}/.zshenv";
        recursive = false;
        target = ".zshenv";
      };

      "zsh" = {
        enable = true;
        source = "${config_sym_dir}/zsh";
        recursive = true;
        target = ".config/zsh";
      };
    };
  };
}
