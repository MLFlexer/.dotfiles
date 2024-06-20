{ config
, config_dir
, ...
}:
let
  # path to config directory
  config_sym_dir = config.lib.file.mkOutOfStoreSymlink "${config_dir}";
in
{
  # Symlink files
  home.file = {
    "nvim" = {
      enable = true;
      source = "${config_sym_dir}/nvim";
      recursive = true;
      target = ".config/nvim";
    };

    "wezterm" = {
      enable = true;
      source = "${config_sym_dir}/wezterm";
      recursive = true;
      target = ".config/wezterm";
    };

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

    "nix" = {
      enable = true;
      source = "${config_sym_dir}/nix";
      recursive = true;
      target = ".config/nix";
    };
  };
}
