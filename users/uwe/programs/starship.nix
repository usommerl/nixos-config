{ config, ... }:

{

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file."${config.xdg.configHome}/starship.toml".text = ''

    add_newline = false

    format = """
    $username\
    $hostname\
    $shlvl\
    $kubernetes\
    $directory\
    $git_branch\
    $git_commit\
    $git_state\
    $git_status\
    $hg_branch\
    $docker_context\
    $dart\
    $golang\
    $helm\
    $kotlin\
    $python\
    $ruby\
    $rust\
    $terraform\
    $nix_shell\
    $conda\
    $memory_usage\
    $aws\
    $openstack\
    $env_var\
    $crystal\
    $custom\
    $cmd_duration\
    $line_break\
    $jobs\
    $battery\
    $time\
    $status\
    $shell\
    $character"""

    [character]
    success_symbol = "[>](bold yellow)"
    error_symbol = "[✗](bold red)"

    [directory]
    style = "bold yellow"
    truncate_to_repo = false

    [git_branch]
    truncation_length = 40
    symbol = " "
    style= "bold yellow"

    [git_status]
    style = 'fg:244'
    ahead = "[↑](bold cyan)$count"
    behind = "[↓](bold cyan)$count"
    stashed = "[@](bold cyan)$count"
    diverged = "[↕](bold red)"
    modified = '[M](bold red)$count'
    staged = '[M](bold green)$count'
    untracked = '[?](bold red)$count'
    deleted = "[D](bold red)$count"

    [docker_context]
    symbol="  "
    only_with_files=false

    # Adopted from
    # - https://github.com/direnv/direnv/issues/68#issuecomment-1368441542
    # - https://github.com/direnv/direnv/issues/68#issuecomment-1535044690
    [custom.direnv]
    style = "fg:yellow bold"
    format = "with [\\$direnv]($style) "
    when = "printenv DIRENV_FILE"

    [aws]
    symbol = "  "
    [buf]
    symbol = " "
    [c]
    symbol = " "
    [conda]
    symbol = " "
    [dart]
    symbol = " "
    [elixir]
    symbol = " "
    [elm]
    symbol = " "
    [fossil_branch]
    symbol = " "
    [golang]
    symbol = " "
    [guix_shell]
    symbol = " "
    [haskell]
    symbol = " "
    [haxe]
    symbol = "⌘ "
    [hg_branch]
    symbol = " "
    [java]
    symbol = " "
    [julia]
    symbol = " "
    [lua]
    symbol = " "
    [meson]
    symbol = "喝 "
    [nim]
    symbol = " "
    [nix_shell]
    format = "via [$symbol$state]($style) "
    symbol = " "
    [nodejs]
    symbol = " "
    [python]
    symbol = " "
    [rlang]
    symbol = "ﳒ "
    [ruby]
    symbol = " "
    [rust]
    symbol = " "
    [scala]
    symbol = " "
  '';
}
