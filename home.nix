{
  config,
  pkgs,
  ...
}: 
let
  # path to dotfiles directory
  dotdir = config.lib.file.mkOutOfStoreSymlink "/home/mlflexer/repos/.dotfiles";
in {
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

  # Symlink files
  home.file = { 
    "alacritty" = {
      enable = false;
      source = "${dotdir}/alacritty";
      recursive = true;
      target = ".config/alacritty";
    };
    "bat" = {
      enable = true;
      source = "${dotdir}/bat";
      recursive = true;
      target = ".config/bat";
    };
    "nvim" = {
      enable = true;
      source = "${dotdir}/nvim";
      recursive = true;
      target = ".config/nvim";
    };
    "wezterm" = {
      enable = true;
      source = "${dotdir}/wezterm";
      recursive = true;
      target = ".config/wezterm";
    };
    ".gitconfig" = {
      enable = true;
      source = "${dotdir}/.gitconfig";
      recursive = false;
      target = ".gitconfig";
    };
    ".zshenv" = {
      enable = true;
      source = "${dotdir}/.zshenv";
      recursive = false;
      target = ".zshenv";
    };
    "zsh" = {
      enable = true;
      source = "${dotdir}/zsh";
      recursive = true;
      target = ".config/zsh";
    };
    "tmux" = {
      enable = true;
      source = "${dotdir}/tmux";
      recursive = true;
      target = ".config/tmux";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    # allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
}
