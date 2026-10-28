set -gx EDITOR nvim
set -gx BROWSER zen-browser

if status is-interactive
    set -g fish_greeting

    starship init fish | source
    set -gx _ZO_ECHO 1
    zoxide init fish --cmd cd | source
    fzf --fish | source

    alias ls 'eza -lh --group-directories-first --icons=auto'
end
