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
      firefox
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
      vhs
      xclip
      xsv
      yarn
      zig
      zoxide
      zsh
      zsh-autosuggestions
      zsh-completions
      zsh-powerlevel10k
      zsh-syntax-highlighting
    ];
  };

  home.file = { 
    "bat" = {
      source = ./bat;
      recursive = true;
      target = ".config/bat";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    # allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
