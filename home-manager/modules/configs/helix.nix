{ config, config_dir, pkgs, system, inputs, ... }:
let
  # path to config directory
  config_sym_dir = config.lib.file.mkOutOfStoreSymlink "${config_dir}";
in {
  home.packages = with pkgs; [ inputs.helix-editor.packages.${system}.default ];

  # Symlink files
  home.file = {
    "helix" = {
      enable = true;
      source = "${config_sym_dir}/helix";
      recursive = true;
      target = ".config/helix";
    };
  };
}
