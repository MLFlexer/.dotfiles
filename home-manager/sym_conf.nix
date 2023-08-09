{ config
, user
, ...
}:
let
  # path to dotfiles directory
  dotdir = config.lib.file.mkOutOfStoreSymlink "/home/${user}/repos/.dotfiles/home-manager/config";
in
{
  # Symlink files
  home.file = {
    "alacritty" = {
      enable = false;
      source = "${dotdir}/alacritty";
      recursive = true;
      target = ".config/alacritty";
    };
    "bat" = {
      enable = true;
      source = "${dotdir}/bat";
      recursive = true;
      target = ".config/bat";
    };
    "nvim" = {
      enable = true;
      source = "${dotdir}/nvim";
      recursive = true;
      target = ".config/nvim";
    };
    "wezterm" = {
      enable = true;
      source = "${dotdir}/wezterm";
      recursive = true;
      target = ".config/wezterm";
    };
    ".gitconfig" = {
      enable = true;
      source = "${dotdir}/.gitconfig";
      recursive = false;
      target = ".gitconfig";
    };
    ".zshenv" = {
      enable = true;
      source = "${dotdir}/.zshenv";
      recursive = false;
      target = ".zshenv";
    };
    "zsh" = {
      enable = true;
      source = "${dotdir}/zsh";
      recursive = true;
      target = ".config/zsh";
    };
    "tmux" = {
      enable = true;
      source = "${dotdir}/tmux";
      recursive = true;
      target = ".config/tmux";
    };
  };
}
