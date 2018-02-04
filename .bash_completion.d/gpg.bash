# Completion for gpg(1) with long options
_gpg() {

    # Bail if no gpg(1)
    hash gpg 2>/dev/null || return 1

    # Bail if not completing an option
    [[ ${COMP_WORDS[COMP_CWORD]} == --* ]] || return 1

    # Generate completion reply from gpg(1) options
    local option
    while read -r option ; do
        [[ $option == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$option
    done < <(gpg --dump-options 2>/dev/null)
}

# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _gpg -o bashdefault -o default gpg
else
    complete -F _gpg -o default gpg
fi
