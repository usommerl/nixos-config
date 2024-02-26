{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    gitflow
    git-trim
  ];

  programs.git = {
    enable = true;
    userName = config.user.fullname;
    userEmail = config.user.email;

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
