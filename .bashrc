[[ $COLORTERM = gnome-terminal && ! $TERM = screen-256color ]] && TERM=xterm-256color 
eval `dircolors ~/.dir_colors`
alias ls="ls --color"
