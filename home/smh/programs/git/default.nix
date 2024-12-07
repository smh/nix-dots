{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Stein Martin Hustad";
    userEmail = "stein@hustad.com";

    includes = [
      { path = "${./catppuccin.gitconfig}"; }
    ];

    aliases = {
      s = "status --short";
      st = "status";
      # Adding the complex recentb alias
      # not escaped properly for nixos config, but brv works well enough?
      # recentb = "!r() { refbranch=$1 count=$2; git for-each-ref --sort=-committerdate refs/heads --format='%(refname:short)|%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' --color=always --count=${count:-20} | while read line; do branch=$(echo \"$line\" | awk 'BEGIN { FS = \"|\" }; { print $1 }' | tr -d '*'); ahead=$(git rev-list --count \"${refbranch:-origin/main}..${branch}\"); behind=$(git rev-list --count \"${branch}..${refbranch:-origin/main}\"); colorline=$(echo \"$line\" | sed 's/^[^|]*|//'); echo \"$ahead|$behind|$colorline\" | awk -F'|' -vOFS='|' '{$5=substr($5,1,70)}1' ; done | ( echo \"ahead|behind||branch|lastcommit|message|author\\n\" && cat) | column -ts'|';}; r";
      # Difftastic aliases
      dlog = ''-c diff.external=difft log --ext-diff'';
      dshow = ''-c diff.external=difft show --ext-diff'';
      ddiff = ''-c diff.external=difft diff'';
      dl = ''-c diff.external=difft log -p --ext-diff'';
      ds = ''-c diff.external=difft show --ext-diff'';
      dft = ''-c diff.external=difft diff'';
    };

    extraConfig = {
      color = {
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = "auto";
      };

      core = {
        quotePath = false;
      };

      delta = {
        navigate = true;
        light = false;
        "side-by-side" = false;
        features = "side-by-side line-numbers decorations catppuccin-frappe";
        "whitespace-error-style" = "22 reverse";
      };

      diff = {
        tool = "vimdiff";
        algorithm = "patience";
        submodule = "log";
        colorMoved = "default";
      };

      init.defaultBranch = "main";
      log.date = "relative";
      format.pretty = "format:%C(yellow)%h %Cblue%>(13)%ad %Cgreen%<(9)%aN%Cred%d %Creset%s";

      filter = {
        media = {
          clean = "git-media-clean %f";
          smudge = "git-media-smudge %f";
        };
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };

      github.user = "smh";

      interactive.diffFilter = "delta --color-only";

      merge = {
        tool = "vimdiff";
        conflictStyle = "diff3";
      };

      mergetool = {
        keepBackup = true;
        path = "nvim";
        vimdiff.cmd = "nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
      };

      pull.rebase = true;

      push = {
        default = "simple";
        autoSetupRemote = "true";
      };

      status.branch = true;
      web.browser = "open";
    };
  };

  home.packages = with pkgs; [
    delta
    git-lfs
  ];
}
