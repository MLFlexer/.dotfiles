{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    cli_tools.enable = lib.mkEnableOption "Enables common cli tools";
  };

  config = lib.mkIf config.cli_tools.enable {
    home.packages = with pkgs; [
      age
      btop
      jq
      # atuin
      comma
      eza
      fd
      fzf
      # lazydocker
      python3
      ripgrep
      ripgrep-all
      # zoxide
      # nixfmt
      yazi
      ouch
    ];
  };
}
