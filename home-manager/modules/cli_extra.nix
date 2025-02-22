{ pkgs, pkgs_unstable, ... }: {
  home.packages = (with pkgs; [
    # broot
    # choose
    # difftastic
    # du-dust
    # erdtree
    # fselect
    # fx
    gh
    # grex
    ntfy-sh
    # procs
    # sd
    tealdeer
    gnumake
    xclip
    # xsv

    act
    ffmpeg
    pandoc
    hyperfine
    texliveMedium
  ]) ++ (with pkgs_unstable; [
    # ollama

    nodejs
    yarn
    rustup
    # ghc # Haskell
    go
    haskell-language-server
    nodejs_20
    zig
    nixd
    nixpkgs-fmt
    asm-lsp
    lua-language-server
    nil
  ]);
}
