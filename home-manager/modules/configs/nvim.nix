{ config
, config_dir
, pkgs_unstable
, ...
}:
let
  # path to config directory
  config_sym_dir = config.lib.file.mkOutOfStoreSymlink "${config_dir}";
in
{
  home.packages = with pkgs_unstable; [ neovim ];

  # Symlink files
  home.file = {
    "nvim" = {
      enable = true;
      source = "${config_sym_dir}/nvim";
      recursive = true;
      target = ".config/nvim";
    };
  };
}
