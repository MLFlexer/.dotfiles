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
      broot
      choose
      comma
      delta
      difftastic
      du-dust
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
      procs
      ripgrep
      ripgrep-all
      sd
      starship
      tealdeer
      gitmux
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
