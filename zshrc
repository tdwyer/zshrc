source /etc/zsh/zprofile
source ~/.zprofile
#
############################################################
autoload -U colors
colors
setopt PROMPT_SUBST
############################################################
#
if [[ $USER = user ]]; then
	_USER_="%{$fg_no_bold[magenta]%}%n%{$reset_color%}"

elif [[ $USER = devel ]]; then
	_USER_="%{$fg_no_bold[green]%}%n%{$reset_color%}"

elif [[ $USER = admin ]]; then
	_USER_="%{$fg_no_bold[yellow]%}%n%{$reset_color%}"

elif [[ $USER = root ]]; then
	_USER_="%{$fg_no_bold[red]%}%n%{$reset_color%}"

else
	_USER_="%{$fg_no_bold[blue]%}%n%{$reset_color%}"
fi
#
#
_HOST_="%{$fg_no_bold[blue]%}"
#
#Grab the current date (%w) and time (%t):
_TIME_="$_HOST_%w %t%{$reset_color%}"
#
#Grab the current machine name 
_HOSTNAME_="$_HOST_%m%{$reset_color%}"
#
#What TTY or PTY is this?
_TTY_="%{$fg_bold[white]%}%l%{$reset_color%}"
#
#name -> tty -> host spacer
_DOT_="%{$fg_no_bold[yellow]%}_%{$reset_color%}"
#
#
# If root Red>Yellow>White
# else Blue>Light-blue>White
_ROOT_CMD_="%{$fg_bold[red]%}>%{$fg_bold[yellow]%}>%{$fg_bold[white]%}>%{$reset_color%}"
_USER_CMD_="%{$fg_no_bold[blue]%}>%{$fg_bold[blue]%}>%{$fg_bold[white]%}>%{$reset_color%}"
#
setopt extended_glob
preexec () {
  if [[ "$TERM" == "screen-256color" ]] ;then
    local USR=$USERNAME[(w)1,1]:u
    local CMD=${1[(wr)^(*=*|sudo|-*)]}
    echo -ne "\ek${USR}_${CMD}\e\\"
  fi
}
#
_CMD_="%(!.$_ROOT_CMD_.$_USER_CMD_)"
#
# Put it all together!
PROMPT="
$_DOT_$_USER_$_DOT_$_TTY_$_DOT_$_HOSTNAME_$_DOT_
%{$fg_bold[white]%}%4~$_CMD_ "
RPS1="$_TIME_"
###########################################################
#
###########################################################
#
zmodload zsh/complist
autoload -U compinit && compinit
zstyle ':completion:::::' completer _complete _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*:descriptions' format "- %d -"
#zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
setopt completealiases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word    
setopt complete_in_word         # allow completion from within a word/phrase
#setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.
setopt chase_links              # resolve symlinks
setopt print_exit_value         # print return value if non-zero
unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'
#
#
local _myhosts
if [[ -f $HOME/.ssh/known_hosts ]]; then
  _myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
  zstyle ':completion:*' hosts $_myhosts
fi
zstyle ':completion:*:kill:*:processes' command "ps x"
#
###############################################################################
# Key bindings
# Ctrl+v then type the key to see the code
#
# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#
# This all depends on your termcapinfo
# These are correct if your on Arch Linux
# If you use urxvt, and you should, make sure to install:
# pacman -S urxvt-unicode-terminfo
#
# Debian dose not have any termcaps installed by default:
# apt-get install ncurses-term
#
# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#
typeset -g -A key
#
# screen-256color
#
if [[ $TERM == "screen-256color" ]] ;then
  # home ^[[1~ end ^[[4~ insert ^[[2~ delete ^[[3~ backspace ^?
  # pgup ^[[5~ pgdown ^[[6~ left ^[[D right ^[[C up ^[[A down ^[[B
  bindkey '^[[1~' beginning-of-line
  bindkey '^[[4~' end-of-line
  bindkey '^[[2~' overwrite-mode
  bindkey '^[[3~' delete-char
  bindkey '^?' backward-delete-char
  bindkey '^[[5~' up-line-or-history
  bindkey '^[[6~' down-line-or-history
  bindkey '^[[D' backward-char
  bindkey '^[[C' forward-char
  bindkey '^[[A' up-line-or-search
  bindkey '^[[B' down-line-or-search
#
# rxvt-256color
#
elif [[ $TERM == "rxvt-256color" ]] ;then
  # home ^[[7~ end ^[[8~ insert ^[[2~ delete ^[[3~ backspace ^?
  # pgup ^[[5~ pgdown ^[[6~ left ^[[D right ^[[C up ^[[A down ^[[B
  bindkey '^[[7~' beginning-of-line
  bindkey '^[[8~' end-of-line
  bindkey '^[[2~' overwrite-mode
  bindkey '^[[3~' delete-char
  bindkey '^?' backward-delete-char
  bindkey '^[[5~' up-line-or-history
  bindkey '^[[6~' down-line-or-history
  bindkey '^[[D' backward-char
  bindkey '^[[C' forward-char
  bindkey '^[[A' up-line-or-search
  bindkey '^[[B' down-line-or-search
#
# linux
#
elif [[ $TERM == "linux" ]] ;then
  # home ^[[1~ end ^[[4~ insert ^[[2~ delete ^[[3~ backspace ^?
  # pgup ^[[5~ pgdown ^[[6~ left ^[[D right ^[[C up ^[[A down ^[[B
  bindkey '^[[1~' beginning-of-line
  bindkey '^[[4~' end-of-line
  bindkey '^[[2~' overwrite-mode
  bindkey '^[[3~' delete-char
  bindkey '^?' backward-delete-char
  bindkey '^[[5~' up-line-or-history
  bindkey '^[[6~' down-line-or-history
  bindkey '^[[D' backward-char
  bindkey '^[[C' forward-char
  bindkey '^[[A' up-line-or-search
  bindkey '^[[B' down-line-or-search
#
# xterm-256color
#
elif [[ $TERM == "xterm-256color" || $TERM == "xterm" ]] ;then
  # home ^[[H end ^[[F insert ^[[2~ delete ^[[3~ backspace ^?
  # pgup ^[[5~ pgdown ^[[6~ left ^[[D right ^[[C up ^[[A down ^[[B
  bindkey '^[[H' beginning-of-line
  bindkey '^[[F' end-of-line
  bindkey '^[[2~' overwrite-mode
  bindkey '^[[3~' delete-char
  bindkey '^?' backward-delete-char
  bindkey '^[[5~' up-line-or-history
  bindkey '^[[6~' down-line-or-history
  bindkey '^[[D' backward-char
  bindkey '^[[C' forward-char
  bindkey '^[[A' up-line-or-search
  bindkey '^[[B' down-line-or-search
#
# Default
#
else
  # home ^[[1~ end ^[[4~ home ^[[7~ end ^[[8~ home ^[[H end ^[[F insert
  # ^[[2~ delete ^[[3~ backspace ^?
  # pgup ^[[5~ pgdown ^[[6~ left ^[[D right ^[[C up ^[[A down ^[[B
  #
  # screen-256color
  #bindkey '^[[1~' beginning-of-line
  #bindkey '^[[4~' end-of-line
  #bindkey '^[[2~' overwrite-mode
  #bindkey '^[[3~' delete-char
  #
  # urxvt-256color
  #bindkey '^[[7~' beginning-of-line
  #bindkey '^[[8~' end-of-line
  #bindkey '^[[2~' overwrite-mode
  #bindkey '^[[3~' delete-char
  #
  # linux
  #bindkey '^[[1~' beginning-of-line
  #bindkey '^[[4~' end-of-line
  #bindkey '^[[2~' overwrite-mode
  #bindkey '^[[3~' delete-char
  #
  # xterm
  bindkey '^[[H' beginning-of-line
  bindkey '^[[F' end-of-line
  bindkey '^[[2~' overwrite-mode
  bindkey '^[[3~' delete-char
  #
  # Common
  bindkey '^?' backward-delete-char
  bindkey '^[[5~' up-line-or-history
  bindkey '^[[6~' down-line-or-history
  bindkey '^[[D' backward-char
  bindkey '^[[C' forward-char
  bindkey '^[[A' up-line-or-search
  bindkey '^[[B' down-line-or-search
fi

###############################################################################
#
# Set GNU dircolors which match jellybeans.vim when used with the
# jellybeans.ansi Xresorces colors
#
eval `dircolors /usr/src/dircolors/dircolors-jellybeans/dircolors.ansi`
#------------------------------------------------------------------------------
# source-highlight : Convert source code to syntax highlighted document
# http://www.gnu.org/software/src-highlite/source-highlight.html
#
LESS_HILITE=`which src-hilite-lesspipe.sh`
if [[ -x ${LESS_HILITE} ]] ;then
  export LESSOPEN="| ${LESS_HILITE} %s" 
  export LESS=' -R '
fi
###############################################################################
#
alias grep='grep --color'
alias sl='ls --color=auto'
alias ls='ls --color=auto'
alias l='ls -lh'
alias la='ls -lha'
alias e='exit'
alias c='clear'
alias wanip='curl --get http://tnx.nl/ip'
alias suod='sudo'
alias soud='sudo'
alias sodu='sudo'
alias sdou='sudo'
alias sduo='sudo'
alias ip6='ip -6'

#  vim: set ts=2 sw=2 tw=80 et :
