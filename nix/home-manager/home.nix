{
  config,
  pkgs,
  ...
}: {
  home = {
    stateVersion = "23.05";
    homeDirectory = "/home/mlflexer";
    username = "mlflexer";
    packages = with pkgs; [
      bat
      broot
      cabal-install # Haskell
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
      ghc # Haskell
      git
      gitmux
      go
      grex
      haskell-language-server
      lazygit
      neovim
      nodejs_20
      ntfy-sh
      procs
      ripgrep
      ripgrep-all
      rustup
      sd
      tealdeer
      tmux
      vscodium
      xclip
      xsv
      yarn
      zig
      zoxide
      zsh
      zsh-autosuggestions
      zsh-completions
      zsh-fzf-tab
      zsh-powerlevel10k
      zsh-syntax-highlighting
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    # allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
