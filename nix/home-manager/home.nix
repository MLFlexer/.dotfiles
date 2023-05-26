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
      gitmux
      go
      grex
      lazygit
      neovim
      ntfy-sh
      procs
      ripgrep
      ripgrep-all
      rustup
      sd
      starship
      tealdeer
      tmux
      xsv
      zoxide
      zsh
      zsh-autosuggestions
      zsh-completions
      zsh-fzf-tab
      zsh-syntax-highlighting
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    # allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
