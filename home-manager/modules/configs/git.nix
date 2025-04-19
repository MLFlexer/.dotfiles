{ config, lib, ... }: {

  options = { git.enable = lib.mkEnableOption "Enables Git config"; };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          syntax-theme = "tokoyonight_moon";
          line-numbers = true;
        };
      };
      userEmail = "75012728+MLFlexer@users.noreply.github.com";
      userName = "MLFlexer";
      ignores = [ ".direnv" ];
      # follows: https://blog.gitbutler.com/how-git-core-devs-configure-git/
      extraConfig = {
        diff = {
          algorithm = "histogram";
          colorMoved = true;
          renames = true;
          mnemonicPrefix = true;
        };

        init.defaultBranch = "main";

        tag.sort = "version:refname";
        branch.sort = "-committerdate";
        column.ui = "auto";

        push = {
          autoSetupRemote = true;
          followTags = true;
        };

        fetch = {
          # prune = false;
          # pruneTags = false;
          all = true;
        };
        pull.rebase = true;

        help.autocorrect = "prompt";
        commit.verbose = true;
        merge.conflictstyle = "zdiff3";

        rerere = {
          enabled = true;
          autoupdate = true;
        };

        rebase = {
          autoSquash = "true";
          autoStash = "true";
          updateRefs = "true";
        };

      };
    };

    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --paging=never";
          };
        };
      };
    };
  };
}
