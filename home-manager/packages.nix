{ pkgs
, pkgs_unstable
, ...
}:
let
  stable = with pkgs; [
    atuin
    # broot
    # choose
    comma
    difftastic
    # du-dust
    # erdtree
    fd
    # fselect
    # fx
    fzf
    gh
    ghc # Haskell
    go
    # grex
    haskell-language-server
    lazygit
    nodejs_20
    ntfy-sh
    # procs
    ripgrep
    ripgrep-all
    rustup
    python3
    # sd
    tealdeer
    gnumake
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
    act
    ffmpeg
    pandoc
    hyperfine
  ];

  unstable = with pkgs_unstable; [
    yazi
    ollama
    nodejs
    eza
    nixd
    nixpkgs-fmt
    helix
    neovim
    # asm-lsp
  ];
in
{
  home = {
    packages = stable ++ unstable;
  };
}
