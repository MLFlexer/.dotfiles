{ pkgs, config, lib, pkgs_unstable, ... }: {
  options = {
    cli_tools.enable = lib.mkEnableOption "Enables common cli tools";
  };

  config = lib.mkIf config.cli_tools.enable {
    home.packages = (with pkgs; [
      # stable
      age
      atuin
      comma
      eza
      fd
      fzf
      lazydocker
      python3
      ripgrep
      ripgrep-all
      zoxide
      nixfmt
    ]) ++ (with pkgs_unstable;
      [
        # unstable
        yazi
      ]);
  };
}
