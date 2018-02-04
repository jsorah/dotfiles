# Complete group names for first non-option chgrp(1) argument
_chgrp() {
    local i
    for ((i = 1; i < COMP_CWORD; i++)) ; do
        case ${COMP_WORDS[i]} in
            -*) ;;
            *) return 1 ;;
        esac
    done
    while read -r group ; do
        COMPREPLY[${#COMPREPLY[@]}]=$group
    done < <(compgen -A group -- "${COMP_WORDS[COMP_CWORD]}")
}

# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _chgrp -o bashdefault -o default chgrp
else
    complete -F _chgrp -o default chgrp
fi
