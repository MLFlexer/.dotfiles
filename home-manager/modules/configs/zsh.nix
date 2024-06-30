
{ config
, config_dir
, pkgs
, ...
}:
let
  config_sym_dir = config.lib.file.mkOutOfStoreSymlink "${config_dir}";
in
{
  home.packages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-powerlevel10k
    zsh-syntax-highlighting
  ];

  # Symlink files
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
}
