# Set beam cursor on instant prompt
echo -ne '\e[5 q'

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ===================================================
# Environment variables
# ===================================================

# Zsh
export HISTFILE=$HOME/.cache/zsh/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# Editor
export EDITOR='nvim'

# Manpager
export MANPAGER='nvim +Man!'

# ===================================================
# Settings
# ===================================================

# Syntax highlighting
# !! has to be souced before manydots-magic
source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Completion
fpath=("$ZDOTDIR/functions" "/usr/share/zsh/vendor-completions" $fpath)
autoload -Uz compinit; compinit
autoload -Uz manydots-magic; manydots-magic
_comp_options+=(globdots)

# Completion style
eval "$(dircolors)"
zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:approximate"*' max-errors 5 numeric
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_VERIFY

# Miscellaneous
setopt menucomplete
setopt autocd

# Vi-mode
bindkey -v
export KEYTIMEOUT=1
zmodload zsh/complist

bindkey -v '^?' backward-delete-char

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

bindkey -M vicmd      '^U' history-beginning-search-backward
bindkey -M vicmd      '^D' history-beginning-search-forward

# Edit command in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd f edit-command-line

# ===================================================
# Miscellaneous
# ===================================================

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# p10k theme
source $ZDOTDIR/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

# bash insulter
if [ -f "$HOME/.local/share/bash.command-not-found" ]; then
    . "$HOME/.local/share/bash.command-not-found"
fi

# the fuck
eval "$(thefuck --alias)"

# ===================================================
# Aliases
# ===================================================

# Reloas config
alias reload='source $ZDOTDIR/.zshrc'

# Programs
alias v='$EDITOR'
alias vo='file=$(fzf-tmux); if [ "$file" != "" ]; then; $EDITOR -o $file; fi'
alias vs='nvim -c Rg'
alias vp='nvim -c Files'
alias vf='vifm'
alias fz='fzf-tmux'
alias fs='rg --column --heading --line-number . | fzf-tmux'
#alias hist="!+\$(fc -l 1  | fzf-tmux | awk '{print \$1;}')" TODO make this work

update-cmus-lib() {
    cmus-remote -l -c ~/Music
}
update-cmus-playlist() {
    /usr/local/bin/playlist_localizer \
        -m ~/Music \
        -o ~/.config/cmus/playlists
}
alias music='update-cmus-playlist; cmus'

alias music-dl='youtube-dl -f 140 --ignore-errors --output "%(title)s.%(ext)s"'

# Config
alias cfz='$EDITOR ~/.config/zsh/.zshrc'
alias cfnv='$EDITOR ~/.config/nvim/init.vim'
alias cfal='$EDITOR ~/.config/alacritty/alacritty.yml'
alias cftm='$EDITOR ~/.tmux.conf'

# Cd
alias cdp='cd ~/Projects'
alias cdn='cd ~/Documents/notable/notes'
alias countryroads='cd ~'

# Git
alias ga='git add'
alias gbD='git branch -D'
alias gbd='git branch -d'
alias gbl='git branch --list'
alias gc='git commit --verbose'
alias gca='git commit --verbose --amend'
alias gcb='git checkout -b'
alias gcl='git clone --recursive'
alias gco='git checkout'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gdhh='git diff HEAD^'
alias gdhhh='git diff HEAD^^'
alias gdhhhh='git diff HEAD^^^'
alias gdi='git diff-index --stat'
alias gf='git fetch'
alias ggpull='git pull origin "$(git branch --show-current)"'
alias ggpush='git push origin "$(git branch --show-current)"'
alias gl='git log'
alias glg='git log --graph'
alias glo='git log --oneline'
alias glog='git log --oneline --graph'
alias gls='git log --stat'
alias glsg='git log --stat --graph'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gpl='git pull'
alias gps='git push'
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grf='git rebase --strategy=ours'
alias gri='git rebase --interactive'
alias grs='git reset'
alias grss='git reset --soft'
alias grsh='git reset --hard'
alias gs='git status'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash push'


alias ggc='git gc --prune=now --aggressive'
alias gdu="git rev-list --objects --all \
         | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
         | sed -n 's/^blob //p' \
         | sort --numeric-sort --key=2 \
         | cut -c 1-12,41- \
         | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest"

# Dotfiles
_dotfiles='git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME'
alias dotfiles="$_dotfiles"
alias dotfiles-pull="$_dotfiles pull origin master"
alias dotfiles-forcepull="$_dotfiles stash save;\
                         $_dotfiles stash drop;\
                         $_dotfiles pull origin master"
alias dotfiles-push="$_dotfiles add -u;\
                     $_dotfiles commit -m update;\
                     $_dotfiles push origin master"
alias dotfiles-forcepush="$_dotfiles add -u;\
                          $_dotfiles commit --amend --no-edit;\
                          $_dotfiles push origin master -f"
unset _dotfiles

# Stuff
_stuff='git --git-dir=$HOME/.config/stuff --work-tree=$HOME'
alias stuff="$_stuff"
alias stuff-pull="$_stuff pull origin master"
alias stuff-forcepull="$_stuff stash save;\
                       $_stuff stash drop;\
                       $_stuff pull origin master"
alias stuff-push="$_stuff add -u;\
                  $_stuff commit -m update;\
                  $_stuff push origin master"
alias stuff-forcepush="$_stuff add -u;\
                       $_stuff commit --amend--no-edit;\
                       $_stuff push origin master -f"
unset _stuff

# Notes
_notes='git -C $HOME/Documents/notable'
alias notes-pull="$_notes pull origin master"
alias notes-push="$_notes add .;\
                  $_notes commit -m "update";\
                  $_notes push origin master"
alias notes-diff="$_notes diff HEAD"
unset _notes

# ls
alias l.='exa -d .*'
alias l='exa -lah'
alias la='ls -ah --git-ignore'
alias lg='ls -lah --git-ignore'
alias ll='exa -lh'
alias ls='exa'
alias tree='exa --tree --sort type'

# Delete swap files
alias delete-swap='rm ~/.local/share/nvim/swap/*'

# Systemd reboot
alias sysreboot='systemctl reboot -i'

alias csgo-config="git --git-dir $HOME/Documents/csgo-config --work-tree '$HOME/.local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg'"

print-color-table() {
    for i in {0..255}; do
        print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'};
    done
}
