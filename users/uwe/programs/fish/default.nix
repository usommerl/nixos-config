{ config, pkgs, ... }:

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
          # exec startx -- -keeptty &> /dev/null
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

    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
  };
}