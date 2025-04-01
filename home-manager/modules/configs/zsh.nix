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
      initExtra = ''
        source $HOME/.config/zsh/.p10k.zsh
        bindkey '^[[Z' reverse-menu-complete
        autoload -z edit-command-line
        zle -N edit-command-line
        bindkey -M vicmd v edit-command-line
      '';
      completionInit = ''
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${LS_COLORS}"
        zstyle ':completion:*' menu select
        _comp_options+=(globdots) # include hidden files
      '';
      dotDir = ".config/zsh";
      shellAliases = {
        ls = "eza";
        lg = "lazygit";
        cat = "smart_cat";
      };

      sessionVariables = {
        BROWSER = "zen";
        TERM = "wezterm";
        EDITOR = "hx";
      };

      plugins = [{
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }];
    };

    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };

    programs.zoxide.enable = true;

    home.file = {
      "zsh" = {
        enable = true;
        source = "${config_sym_dir}/zsh";
        recursive = true;
        target = ".config/zsh";
      };
    };
  };
}
