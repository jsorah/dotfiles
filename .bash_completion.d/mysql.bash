# Completion setup for MySQL for configured databases
_mysql() {

    # Only makes sense for first argument
    ((COMP_CWORD == 1)) || return 1

    # Bail if directory doesn't exist
    local dirname
    dirname=$HOME/.mysql
    [[ -d $dirname ]] || return 1

    # Return the names of the .cnf files sans prefix as completions
    local db
    while IFS= read -rd '' db ; do
        [[ -n $db ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$db
    done < <(

        # Set options so that globs expand correctly
        shopt -s dotglob nullglob

        # Collect all the config file names, strip off leading path and .cnf
        local -a cnfs
        cnfs=("$dirname"/"${COMP_WORDS[COMP_CWORD]}"*.cnf)
        cnfs=("${cnfs[@]#"$dirname"/}")
        cnfs=("${cnfs[@]%.cnf}")

        # Print quoted entries, null-delimited, if there was at least one;
        # otherwise, just print a null character to stop this hanging in Bash
        # 4.4
        if ((${#cnfs[@]})) ; then
            printf '%q\0' "${cnfs[@]}"
        else
            printf '\0'
        fi
    )
}

# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _mysql -o bashdefault -o default mysql
else
    complete -F _mysql -o default mysql
fi
