{ pkgs, pkgs_unstable, ... }: {
  home.packages = (with pkgs; [
    # stable
    age
    atuin
    comma
    eza
    fd
    fzf
    lazydocker
    lazygit
    python3
    ripgrep
    ripgrep-all
    zoxide
    nixfmt
  ]) ++ (with pkgs_unstable;
    [
      # unstable
      yazi
    ]);
}
