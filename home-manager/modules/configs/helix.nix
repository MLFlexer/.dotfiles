{ config, lib, system, pkgs, inputs, ... }:
let config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in {
  options = { helix.enable = lib.mkEnableOption "Enables Helix"; };

  config = lib.mkIf config.helix.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      package = inputs.helix-editor.packages.${system}.default;
      extraPackages = with pkgs; [
        nil
        nixpkgs-fmt
        lua-language-server
        bash-language-server
        marksman

        # non-minimal
        rust-analyzer
        llvmPackages_19.clang-unwrapped
      ];
    };

    home.packages = [ pkgs.wl-clipboard ];

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
