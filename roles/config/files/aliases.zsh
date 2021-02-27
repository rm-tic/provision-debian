#GENERAL
export EDITOR="vim"

#HISTORY
alias history='history -i'
HISTSIZE=10000
SAVEHIST=20000
HISTFILE=~/.zhistory

#MANPAGE THEME
export LESS_TERMCAP_mb=$'\e[1;31m'     
export LESS_TERMCAP_md=$'\e[1;33m'     
export LESS_TERMCAP_so=$'\e[01;44;37m' 
export LESS_TERMCAP_us=$'\e[01;37m'    
export LESS_TERMCAP_me=$'\e[0m'        
export LESS_TERMCAP_se=$'\e[0m'        
export LESS_TERMCAP_ue=$'\e[0m'        
export GROFF_NO_SGR=1

#ALIAS
alias pbcopy='xclip -selection clipboard' #Depends xclip package
alias pbpaste='xclip -selection clipboard -o' #Depends xclip package
alias ssh='ssh -o ServerAliveInterval=15'
alias crontab='VISUAL=vi crontab'
alias git='LANG="en_US" git'
alias get-ip='dig @8.8.8.8 +short'
alias get-ipub='curl ifconfig.so'

#FUNCTIONS
ss() { /bin/ss $@ | column -t ;}

#TMUX
t2() { tmux new-session\; split-window -v -p 50\; select-pane -t0 ;}

t3() { tmux new-session\; split-window -v -p 66\; split-window -v\; select-pane -t0 ;}

t4() { tmux new-session \; split-window -v -p 50\; split-window -h\; select-pane -t0\; split-window -h\; select-pane -t0 ;}
