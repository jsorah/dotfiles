# Completion for mutt(1) with abook(1) email addresses
declare -F _abook_addresses >/dev/null ||
    source "$HOME"/.bash_completion.d/_abook_addresses.bash

# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _abook_addresses -o bashdefault -o default mutt
else
    complete -F _abook_addresses -o default mutt
fi
