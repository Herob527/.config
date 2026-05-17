# Disable usage-based completions to avoid environment size issues
set -gx MISE_FISH_NO_USAGE 1
mise activate fish | source

# if status is-interactive
#     eval (zellij setup --generate-auto-start fish | string collect)
# end

# Deduplicate PATH to prevent it from growing too large
set -l new_path
for p in $PATH
    if not contains $p $new_path
        set new_path $new_path $p
    end
end
set -gx PATH $new_path

# Deduplicate XDG_DATA_DIRS
set -l new_xdg
for p in $XDG_DATA_DIRS
    if not contains $p $new_xdg
        set new_xdg $new_xdg $p
    end
end
set -gx XDG_DATA_DIRS $new_xdg

set -gx EDITOR $(which nvim)
set -gx VISUAL $(which nvim)
starship init fish | source

# Add paths only if not already present
fish_add_path -g $HOME/.local/share/bob/nvim-bin
fish_add_path -g $HOME/.dotnet/tools
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/.pub-cache/bin

# XDG_DATA_DIRS
contains "$HOME/Desktop" $XDG_DATA_DIRS; or set -gx XDG_DATA_DIRS $XDG_DATA_DIRS $HOME/Desktop

# GHCUP
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
fish_add_path -g $HOME/.cabal/bin $HOME/.ghcup/bin

type -q node

# bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path -g $BUN_INSTALL/bin

function git_profile -d "Set git user name and email" -a profile
    set value $(echo $profile | string lower)
    if test $value = herob
        git config user.name Herob527
        git config user.email "szymon.wrzos@onet.pl"
    else
        echo "usage: git_profile <herob>"
    end

end
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

alias atup "sudo dnf upgrade && flatpak upgrade"
alias lg lazygit
alias doup "docker compose up"
alias doupw "docker compose up --watch"
alias dodo "docker compose down"
# Used to run neovim with poetry to apply poetry-managed virtual env
alias pvim "poetry run nvim"
alias svim "EDITOR=$(which nvim) sudoedit"
alias gmtl "git mergetool"
alias ls "eza --header --git --icons -w 64"

alias gmc "git merge --continue"
alias gma "git merge --abort"

set description "
Perform SQL query in docker database.

Syntax: d_sql <container> <db> <query>
"

function d_sql -d "Perform SQL query in docker database" -a container -a db -a query
    set -l command "psql -U postgres -d $db -c"
    set -l processed (string replace -a "\"" '\\"' $query )
    set -l cmd (string join ' ' $command "\"$processed\";")
    echo docker exec -it $container /bin/bash -c $cmd
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/szymon/.local/share/mise/installs/conda/26.1.1/bin/conda
    eval /home/szymon/.local/share/mise/installs/conda/26.1.1/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/szymon/.local/share/mise/installs/conda/26.1.1/etc/fish/conf.d/conda.fish"
        . "/home/szymon/.local/share/mise/installs/conda/26.1.1/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/szymon/.local/share/mise/installs/conda/26.1.1/bin" $PATH
    end
end
# <<< conda initialize <<<


# Added by get-aspire-cli.sh
fish_add_path $HOME/.aspire/bin
fish_add_path /opt/flameshot/bin
