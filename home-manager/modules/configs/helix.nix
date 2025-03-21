{ config, lib, system, inputs, ... }:
let config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in {
  options = { helix.enable = lib.mkEnableOption "Enables Helix"; };

  config = lib.mkIf config.helix.enable {
    home.packages = [ inputs.helix-editor.packages.${system}.default ];

    home.file = {
      "helix" = {
        enable = true;
        source = "${config_sym_dir}/helix";
        recursive = true;
        target = ".config/helix";
      };
    };
  };
}
