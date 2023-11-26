{ config, pkgs, ... }:

{
  home.username = "uwe";
  home.homeDirectory = "/home/uwe";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    bat
    btop
    direnv
    docker-compose
    du-dust
    eza
    fd
    fzf
    gitflow
    git-trim
    google-chrome
    grc
    jq
    kubectl
    kubectx
    lm_sensors
    mtr
    neovim
    ripgrep
    ugrep
    usbutils
    viddy
    xclip
    zoxide
  ];

  programs.home-manager.enable = true;
  programs.starship.enable = true;
  programs.bash.enable = true;

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      if status --is-login
        if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
          exec startx -- -keeptty &> /dev/null
        end
      end
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
    };
    shellAliases = {
      l="eza -lg --time-style=long-iso --git";
      ll="l -a";
    };
  };

  programs.git = {
    enable = true;
    userName = "Uwe Sommerlatt";
    userEmail = "uwe.sommerlatt@gmail.com";

    delta = {
      enable = true;
      options = {
        navigate = true;
	line-numbers = true;
	diff-highlight = true;
	hunk-header-style = "hidden";
	file-style = "blue";
	file-decoration-style = "omit";
	line-numbers-left-format = "{nm:^4}⋮ ";
	line-numbers-right-format = "{np:^4}│ ";
	line-numbers-left-style = "#777777";
	line-numbers-right-style = "#777777";
	line-numbers-zero-style = "#777777";
	line-numbers-minus-style = "#BB0000";
	line-numbers-plus-style = "#009900";
      };
    };

    aliases = {
      "fd" = "!f(){ git log --oneline $@ | sed -nr 's/.*Merged in .*\\/([A-Z]+-[0-9]+).*/\\1/p' | tr '\\n' ' ' | tee /dev/tty | xclip -i -sel clipboard; }; f";
      "in" = "!f(){ local b=$(git symbolic-ref --short HEAD); local r=\${1:-origin}; git fetch $r $b; git lo \${2:-} ..$r/$b; }; f";
      "lo" = "!f(){ git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %Cblue<%an>%Creset' --date=short $@; }; f";
      "out" = "!f() { local b=$(git symbolic-ref --short HEAD); local r=\${1:-origin}; git lo \${2:-} $r/$b..; }; f";
      "sw" = "!f(){ git switch \"$(git branch --all | fzf | sed -r 's/^[ \\*]*(remotes\\/\\w+\\/)?//g')\"; }; f";
    };

    extraConfig = {

      color.ui = true;
      diff.submodule = "diff";
      format.pretty = "fuller";
      pull.rebase = true;
      status.submodulesummary = true;
      trim.bases = "develop,master,main";

      "gitflow \"branch\"".master = "main";
      "gitflow \"prefix\"".versiontag = "v";
      "mergetool".prompt = false;
      "mergetool \"nvim\"".cmd = "cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";

      core = {
        editor = "nvim";
	excludesfile = "${config.xdg.configHome}/git/gitignore";
      };

      init = {
        defaultBranch = "main";
	templatedir = "${config.xdg.configHome}/git/templates";
      };

      merge = {
        tool = "nvim";
	ff = false;
	conflictstyle = "diff3";
      };

      push = {
        default = "simple";
	followTags = true;
	recourseSubmodules = "check";
      };

      rebase = {
        autoStash = true;
	autoSquash = true;
      };

    };
  };

  programs.keychain = {
    enable = true;
    enableFishIntegration = true;
    extraFlags = [
      "--quiet"
      "--nogui"
      "--ignore-missing"
    ];
    keys = [
      "id_rsa"
      "id_ed25519"
    ];
  };

  home.file.".xinitrc".text = ''
    #!/bin/sh
    exec awesome
  '';

  home.file."${config.xdg.configHome}/git/templates/hooks/prepare-commit-msg" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      branchName=$(git rev-parse --abbrev-ref HEAD)
      jiraId=$(echo $branchName | sed -nr 's,[a-z]+/([A-Z]+-[0-9]+).*,\1,p')

      # $1 is the name of the file containing the commit message
      # $2 is empty if it's a regular commit (no merge, amend, squash,...)

      if [ ! -z "$jiraId" ] && [ -z "$2" ]; then
       sed -i.bak -e "1s/^/\n\n[$jiraId]\n/" $1
      fi
    '';
  };

  home.file."${config.xdg.configHome}/git/gitignore". text = ''
    .idea/
    .vscode/

    .bloop/
    .metals/
    .bsp/
    project/metals.sbt
    project/project/

    .envrc
    *.worksheet.sc
  '';
}

