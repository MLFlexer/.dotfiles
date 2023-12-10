{ pkgs
, unstable
, ollama_pkgs
, ...
}:
let

  stable_pkgs = with pkgs; [
    atuin
    bat
    broot
    # cabal-install # Haskell
    stack # KU Advanced programming haskell
    # choose
    comma
    delta
    difftastic
    # du-dust
    # erdtree
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
    # nodejs_20
    ntfy-sh
    # procs
    ripgrep
    ripgrep-all
    rustup
    python3
    # sd
    tealdeer
    tmux
    gnumake
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
  unstable_pkgs = with unstable; [
    (unstable.callPackage ./deravations/yazi.nix { })
    # (unstable.callPackage ./deravations/ollama/ollama.nix { })
    ollama_pkgs.ollama
    # (unstable.callPackage ./deravations/neovim_nightly.nix {unstable, })
    # ollama
    erlang_26
    erlang-ls
    rebar3 # for installing erlang-ls with mason
    nodejs
    eza
    # jdk
  ];
in
{
  home = {
    packages = stable_pkgs ++ unstable_pkgs;
  };
}
