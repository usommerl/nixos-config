{ config, pkgs, ... }:
let
  # I have found no way to determine the directory of the flake in pure evaluation mode.
  # Maybe this could be helpful in the future: https://github.com/NixOS/nix/issues/8034
  flakeRoot = "~/.dotfiles";
in
{

  home.packages = with pkgs; [
    eza
    fd
    fzf
    grc
  ];

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      bind \t accept-autosuggestion
      set fish_greeting # Disable greeting

      if status --is-login
        if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
          exec Hyprland &> /dev/null
        end
      end

      set -gx MANPAGER 'nvim +Man!'
      set -gx LESS '-iR'
      set -gx SBT_TPOLECAT_DEV
      set -gx fzf_fd_opts --hidden --exclude=.git
      set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*" --bind ctrl-alt-k:preview-up,ctrl-alt-j:preview-down'
      set -gx EXA_COLORS 'da=38;5;244:uu=38;5;244:gu=38;5;244:un=33:gn=33:ur=38;5;244:gr=38;5;244:tr=38;5;244:uw=38;5;244:gw=38;5;244:tw=38;5;244:sn=15:sb=15:ux=38;5;244:ue=38;5;244:gx=38;5;244:tx=38;5;244:ga=1;31:gm=1;31'

      function __bctl_connect
        bluetoothctl -- power off
        bluetoothctl -- power on
        bluetoothctl -- connect $argv[1]
      end

      function bctl
        switch $argv[1]
          case off
            bluetoothctl -- power off
          case aiaiai
            __bctl_connect 1C:6E:4C:9A:05:59
          case nubert
            __bctl_connect CC:90:93:12:6D:C8
          case '*'
            echo "Unknown argument: $argv[1]"
        end
      end
      complete -c bctl -n "not __fish_seen_subcommand_from $commands" \
          -a "off aiaiai nubert"
    '';

    shellAbbrs = {
      "-"="cd -";
      ".."="cd ..";
      c="docker-compose";
      cat="bat";
      d="docker";
      dc="docker context";
      dcl="docker context ls";
      dcu="docker context use";
      dcud="docker context use default";
      dps="command docker ps --format 'table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}' | begin sed -u 1q; sort -k 2; end | grcat conf.dockerps";
      du="dust";
      fh="nix run 'https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz'";
      h="history";
      n="nvim";
      tree="eza --tree";
      v="nvim";
      vi="nvim";
      watch="viddy";
      top="btop";

      k="kubectl";
      kc="kubectx";
      kn="kubens";
      kg="kubectl get";
      kd="kubectl describe";

      g="git";
      ga="git add";
      gai="git add -ip";
      gau="git add -u";
      gb="git branch";
      gbc="git rev-parse --abbrev-ref HEAD";
      gbla="git branch -a --list";
      gbll="git branch --list";
      gblr="git branch -r --list";
      gblu="git remote update origin --prune";
      gc="git commit -v";
      gca="git commit -v --amend";
      gcan="git commit -v --amend --no-edit";
      gcc="git clean -f -d";
      gco="git checkout";
      gcp="git cherry-pick";
      gd="git diff";
      gds="git diff --staged";
      gf="git flow";
      gfb="git flow bugfix";
      gfbf="git flow bugfix finish";
      gfbl="git flow bugfix list -v";
      gfbp="git flow bugfix publish";
      gfbs="git flow bugfix start";
      gfd="git fd";
      gff="git flow feature";
      gfff="git flow feature finish";
      gffl="git flow feature list -v";
      gffp="git flow feature publish";
      gffs="git flow feature start";
      gfi="git flow init --defaults";
      gfr="git flow release";
      gfrf="git flow release finish --keepremote";
      gfrl="git flow release list -v";
      gfrp="git flow release publish";
      gfrs="git flow release start";
      gin="git in";
      gl="git lo";
      glg="git lo --graph";
      gll="git log --stat";
      gout="git out";
      gpl="git pull";
      gps="git push";
      gpsa="git push --all";
      gpsr="git push --recurse-submodules=on-demand";
      gr="cd (git rev-parse --show-toplevel)";
      grl="git reflog --date=local";
      grs="git remote -vv show";
      gs="git show";
      gst="git status --short -b";
      gstl="git status --long";
      gsu="git submodule";
      gsw="git sw";
      gt="git tag";
      gtl="git tag --list | sort -V";
      gtr="git trim";
      gw="git worktree";

      nrs="sudo nixos-rebuild switch --flake ${flakeRoot}";
      nrt="sudo nixos-rebuild test --flake ${flakeRoot}";
      nrb="sudo nixos-rebuild boot --flake ${flakeRoot}";
      nrl="nixos-rebuild list-generations --flake ${flakeRoot}";
      nfu="nix flake update";
    };

    shellAliases = {
      l="eza -lg --time-style=long-iso --git";
      ll="l -a";
    };

    plugins = with pkgs; [
      { name = "fzf-fish"; src = fishPlugins.fzf-fish.src; }
    ];
  };
}
