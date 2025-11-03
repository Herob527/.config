mise activate fish | source

if status is-interactive
    eval (zellij setup --generate-auto-start fish | string collect)
end

set EDITOR $(which nvim)
set VISUAL $(which nvim)
starship init fish | source
fish_add_path -g

set -gx PATH /run/user/1000/fnm_multishells/22028_1736889187602/bin $PATH

set PATH "$PATH:$HOME/.local/share/bob/nvim-bin"
set PATH "$PATH:$HOME/.local/share/mise"
set PATH "$PATH:$HOME/.dotnet/tools"
set PATH "$PATH:$HOME/.local/bin"
set PATH "$PATH:$HOME/.pub-cache/bin"
set -gx FNM_MULTISHELL_PATH /run/user/1000/fnm_multishells/22028_1736889187602

set -gx FNM_VERSION_FILE_STRATEGY local

set -gx FNM_DIR "$HOME/.local/share/fnm"

set -gx FNM_LOGLEVEL info

set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist"

set -gx FNM_COREPACK_ENABLED false

set -gx FNM_RESOLVE_ENGINES true

set -gx FNM_ARCH x64

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
set -gx PATH $HOME/.cabal/bin $PATH $HOME/.ghcup/bin # ghcup-env

type -q node

if test $status -eq 1
    fnm use default
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

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
    docker exec -it $container /bin/bash -c $cmd
end
