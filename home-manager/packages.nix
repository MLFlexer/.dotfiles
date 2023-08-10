{ config
, pkgs
, ...
}:
{
  home = {
    packages = with pkgs; [
      bat
      broot
      cabal-install # Haskell
      # choose
      comma
      delta
      difftastic
      # du-dust
      # erdtree
      exa
      fd
      # firefox
      # fselect
      # fx
      fzf
      gh
      ghc # Haskell
      git
      gitmux
      go
      # grex
      haskell-language-server
      lazygit
      neovim
      nodejs_20
      ntfy-sh
      # procs
      ripgrep
      ripgrep-all
      rustup
      # sd
      tealdeer
      tmux
      vhs
      # vscodium
      # wezterm
      xclip
      # xsv
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
  nixpkgs.config = {
    allowUnfree = true;
  };
}
