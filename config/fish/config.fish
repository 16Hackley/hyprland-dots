set -g fish_greeting

if status is-interactive
    starship init fish | source
end

# List Directory
alias fucking="sudo"
alias please="sudo"
alias xdd="sudo"
alias xd="sudo"
alias ff="fastfetch"
alias pacman="sudo pacman"
alias bot="ssh root@185.196.21.128"

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'
