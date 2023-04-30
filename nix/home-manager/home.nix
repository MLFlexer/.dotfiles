{
  config,
  pkgs,
  ...
}: {
  home = {
    stateVersion = "22.11";
    homeDirectory = "/home/mlflexer";
    username = "mlflexer";
    packages = with pkgs; [
      bat
      delta
      difftastic
      erdtree
      exa
      fd
      fselect
      fx
      fzf
      gh
      git
      grex
      lazygit
      neovim
      ntfy-sh
      ripgrep
      ripgrep-all
      sd
      tealdeer
      tmux
      xsv
      zoxide
      zsh
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    # allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
