{ config, lib, pkgs, ... }:
let config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in {
  options = { zsh.enable = lib.mkEnableOption "Enables Zsh config"; };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = "source $HOME/.config/zsh/.p10k.zsh";
      dotDir = ".config/zsh";
      shellAliases = {
        ls = "eza";
        lg = "lazygit";
        cat = "smart_cat";
      };

      plugins = [{
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }];
    };

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
