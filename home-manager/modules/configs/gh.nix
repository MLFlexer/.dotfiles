{ config, config_dir, pkgs, ... }:
let config_sym_dir = config.lib.file.mkOutOfStoreSymlink "${config_dir}";
in {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-dash ];
    settings = {
      git_protocol = "https";
      # editor = "nvim";
      prompt = "enabled";
      # pager = "";
      # http_unix_socket = "";
      # browser = "";
      # version = "1";
      # aliases = {
      #   co = "pr checkout";
      #   vpr = "pr view --web";
      #   vr = "repo view --web";
      #   clean-branches = "poi";
      # };
    };
  };

  # Symlink files
  home.file."gh-dash" = {
    enable = true;
    source = "${config_sym_dir}/gh-dash";
    recursive = true;
    target = ".config/gh-dash";
  };
}
