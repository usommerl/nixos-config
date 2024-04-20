{ pkgs, config, ... }:
{
  home.file."${config.xdg.configHome}/vifm/vifmrc".text = ''
    " Options
    set vicmd=nvim
    set title
    set trash
    set trashdir=$HOME/.local/vifm/trash
    set history=100
    set nofollowlinks
    set fastrun
    set sortnumbers
    set undolevels=100
    set novimhelp
    set norunexec
    set noiec
    set fusehome=/tmp/vifm_FUSE
    set timefmt=%Y-%m-%d\ %H:%M
    set wildmenu
    set ignorecase
    set smartcase
    set nohlsearch
    set incsearch
    set scrolloff=4
    set slowfs=curlftpfs,cifs
    set statusline=" %t%= %A %10u:%-7g %15s %20d "
    set grepprg="ack\ -H\ -r\ %i\ %a\ %s"
    set rulerformat="%2l/%S [%0-] "
    set confirm=permdelete
    set tuioptions-=s
    set dotdirs="rootparent"
    set vifminfo=dhistory,chistory,state,tui,shistory,
        \phistory,fhistory,dirstack,registers,bookmarks

    windo set viewcolumns=-{name}..,20{}.
    windo set relativenumber
    windo set number
    colorscheme custom

    " Bookmarks
    mark r /
    mark h ~/
    mark d ~/downloads
    mark D /mnt/${config.user.username}/data
    mark c ~/.dotfiles
    mark m /mnt

    " Commands
    command! df df -h %m 2> /dev/null
    command! diff nvim -d %f %F
    command! zip zip -r %f.zip %f
    command! run !! ./%f
    command! make !!make %a
    command! mkcd :mkdir %a | cd %a
    command! vgrep vim "+grep %a"
    command! reload :write | restart
    command! qa :q
    command! zoxide :set noquickview | execute 'cd' fnameescape(system('zoxide query -l | fzf --height 20 2>/dev/tty || echo "%d"')) '%IU' | norm :redraw<cr>

    " Keys
    nnoremap s :shell<cr>
    nnoremap T :!alacritty --working-directory %d 2> /dev/null &<cr>
    nnoremap S :sort<cr>
    nnoremap R :invert o<cr>
    nnoremap <C-w>m :sync<cr>
    nnoremap w :view<cr>
    vnoremap w :view<cr>gv
    nnoremap o :!nvr --remote-silent %f<cr>
    nnoremap O :!alacritty --command nvim %f &<cr>
    nnoremap <C-p> :!lp %f<cr>
    nnoremap gb :file &<cr>l
    nnoremap yd :!echo %d | xclip -selection clipboard %i<cr>
    nnoremap yf :!echo %c:p | xclip -selection clipboard %i<cr>
    nnoremap yn :!echo -n %c | xclip -selection clipboard %i<cr>
    nnoremap I cw<c-a>
    nnoremap cc cw<c-u>
    nnoremap A cw<c-w>
    nnoremap ,w :set wrap!<cr>
    nnoremap ,c :copy<cr>
    nnoremap ,m :move<cr>
    nnoremap ,b :set viewcolumns=-{name}..,20{}.<cr>
    nnoremap ,d :set viewcolumns=-{name}.,10{perms},12{uname},-7{gname},10{size}.,20{mtime}<cr>
    nnoremap ,D :diff<cr>
    nnoremap <silent>Z :zoxide<cr>

    " Autocommands
    autocmd DirEnter * !zoxide add %d %i

    " File Associations
    filextype *.doc,*.docx,*.xls,*.xlsx,*.ppt,*.pptx,*.ods,*.ots,*.odt,*.ott,*.odp,*.otp,*.odm libreoffice %f &
    filextype *.pdf zathura %c %i &, apvlv %c, xpdf %c
    filextype *.ps,*.eps,*.ps.gz
            \ {View in zathura}
            \ zathura %f,
            \ {View in gv}
            \ gv %c %i &,

    filextype *.desktop
            \ open-desktop-file %f > /dev/null 2>&1 &

    filextype *.djvu
            \ {View in zathura}
            \ zathura %f,
            \ {View in apvlv}
            \ apvlv %f,

    filetype *.wav,*.mp3,*.flac,*.ogg,*.m4a,*.wma,*.ape,*.ac3
           \ {Play using ffplay}
           \ ffplay -nodisp %c,
           \ {Play using MPlayer}
           \ mplayer %f,
           \ ffplay %c,

    filextype *.avi,*.mp4,*.wmv,*.dat,*.3gp,*.ogv,*.mkv,*.mpg,*.vob,*.flv,*.m2v,*.mov,*.webm,*.m4v
            \ {View using mpv}
            \ mpv -really-quiet %f &,
            \ {View using mplayer}
            \ mplayer -really-quiet %f &,
            \ {View using ffplay}
            \ ffplay -fs %c,
            \ {View using Dragon}
            \ dragon %f,

    filetype *.o nm %f | less
    filetype *.[1-8] gtbl %c | groff -Tascii -man | less
    fileviewer *.[1-8] gtbl %c | groff -Tascii -man | col -b
    filextype *.bmp,*.jpg,*.jpeg,*.png,*.gif,*.xpm,*.tif
            \ {View in feh}
            \ feh -Tdefault --scale-down --start-at %c %d &>/dev/null &,
            \ {View in sxiv}
            \ sxiv -s f -b %f &,
            \ {View in gpicview}
            \ gpicview %c,

    filextype *.svg
            \ inkview %f &>/dev/null &

    " vifmimg
    fileviewer *.pdf
        \ vifmimg pdf %px %py %pw %ph %c
        \ %pc
        \ vifmimg clear

    fileviewer *.djvu
        \ vifmimg djvu %px %py %pw %ph %c
        \ %pc
        \ vifmimg clear

    fileviewer *.epub
        \ vifmimg epub %px %py %pw %ph %c
        \ %pc
        \ vifmimg clear

    fileviewer <video/*>
        \ vifmimg video %px %py %pw %ph %c
        \ %pc
        \ vifmimg clear

    fileviewer <image/*>
        \ vifmimg draw %px %py %pw %ph %c
        \ %pc
        \ vifmimg clear

    fileviewer <audio/*>
        \ vifmimg audio %px %py %pw %ph %c
        \ %pc
        \ vifmimg clear

    fileviewer <font/*>
        \ vifmimg font %px %py %pw %ph %c
        \ %pc
        \ vifmimg clear

    filetype *.md5
           \ {Check MD5 hash sum}
           \ md5sum -c %f,

    filetype *.asc
           \ {Check signature}
           \ !!gpg --verify %c,

    fileviewer *.torrent transmission-show %f

    filetype *.zip,*.jar,*.war,*.ear,*.oxt,*.apk
           \ {Mount with mount-zip}
           \ FUSE_MOUNT|mount-zip -o allow_other %SOURCE_FILE %DESTINATION_DIR,
           \ {View contents}
           \ zip -sf %c | less,
           \ {Extract here}
           \ tar -xf %c,

    fileviewer *.zip,*.jar,*.war,*.ear,*.oxt zip -sf %c

    filetype *.tar,*.tar.bz2,*.tbz2,*.tgz,*.tar.gz,*.tar.xz,*.txz
           \ {Mount with archivemount}
           \ FUSE_MOUNT|archivemount %SOURCE_FILE %DESTINATION_DIR,

    fileviewer *.tgz,*.tar.gz tar -tzf %c
    fileviewer *.tar.bz2,*.tbz2 tar -tjf %c
    fileviewer *.tar.txz,*.txz xz --list %c
    filetype *.rar
           \ {Mount with rar2fs}
           \ FUSE_MOUNT|rar2fs %SOURCE_FILE %DESTINATION_DIR,

    fileviewer *.rar unrar v %c
    filetype *.iso
           \ {Mount with fuseiso}
           \ FUSE_MOUNT|fuseiso %SOURCE_FILE %DESTINATION_DIR,

    filetype *.ssh
           \ {Mount with sshfs}
           \ FUSE_MOUNT2|sshfs %PARAM %DESTINATION_DIR,

    filetype *.ftp
           \ {Mount with curlftpfs}
           \ FUSE_MOUNT2|curlftpfs -o ftp_port=-,,disable_eprt %PARAM %DESTINATION_DIR,

    filetype *.7z
           \ {Mount with fuse-7z}
           \ FUSE_MOUNT|fuse-7z %SOURCE_FILE %DESTINATION_DIR,

    fileviewer *.7z 7z l %c
    filextype *.odt,*.doc,*.docx,*.xls,*.xlsx,*.odp,*.pptx libreoffice %f &
    fileviewer *.doc catdoc %c
    fileviewer *.docx, docx2txt.pl %f -
    filetype *.tudu tudu -f %c
    filextype *.pro qtcreator %f &
    fileviewer .*/,*/ tree %f
  '';

  home.file."${config.xdg.configHome}/vifm/colors/custom.vifm".text = ''
    highlight Win cterm=none ctermfg=white ctermbg=-1
    highlight Directory cterm=bold ctermfg=blue ctermbg=-1
    highlight Link cterm=bold ctermfg=cyan ctermbg=-1
    highlight BrokenLink cterm=underline ctermfg=Cyan ctermbg=-1
    highlight Socket cterm=none ctermfg=magenta ctermbg=-1
    highlight Device cterm=none ctermfg=red ctermbg=-1
    highlight Fifo cterm=none ctermfg=yellow ctermbg=-1
    highlight Executable cterm=bold ctermfg=green ctermbg=-1
    highlight Selected cterm=bold ctermfg=yellow ctermbg=-1
    highlight CurrLine cterm=underline,bold ctermfg=default ctermbg=-1
    highlight TopLine cterm=none ctermfg=yellow ctermbg=-1
    highlight TopLineSel cterm=none ctermfg=yellow ctermbg=-1
    highlight StatusLine cterm=none ctermfg=yellow ctermbg=-1
    highlight WildMenu cterm=bold,reverse ctermfg=white ctermbg=-1
    highlight CmdLine cterm=bold ctermfg=yellow ctermbg=-1
    highlight ErrorMsg cterm=none ctermfg=red ctermbg=-1
    highlight Border cterm=none ctermfg=-1 ctermbg=-1
  '';

  home.packages = with pkgs; [
    alacritty
    archivemount
    curlftpfs
    feh
    fuseiso
    fuse-7z-ng
    inkscape
    mount-zip
    mpv
    rar2fs
    sshfs
    vifm
    zathura
    zoxide
    (
      let
        name = "open-desktop-file";
        buildInputs = with pkgs; [ xdg-utils google-chrome gnugrep ];
        script = pkgs.writeShellScriptBin name ''
          if grep -q 'Type=Link' "$1"; then
            google-chrome-stable "$(grep 'URL=' "$1" | cut -d '=' -f 2-)"
          else
            xdg-open $1
          fi
        '';
      in pkgs.symlinkJoin {
        name = name;
        paths = [ script ] ++ buildInputs;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
      }
    )
  ];
}
