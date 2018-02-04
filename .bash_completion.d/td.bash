# Complete filenames for td(1df)
_td() {
    local dir
    dir=${TODO_DIR:-"$HOME"/Todo}
    local fn
    while IFS= read -rd '' fn ; do
        [[ -n $fn ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$fn
    done < <(
        shopt -s extglob nullglob
        shopt -u dotglob
        declare -a fns
        fns=("$dir"/"${COMP_WORDS[COMP_CWORD]}"*)
        fns=("${fns[@]#"$dir"/}")

        # Print quoted entries, null-delimited, if there was at least one;
        # otherwise, just print a null character to stop this hanging in Bash
        # 4.4
        if ((${#fns[@]})) ; then
            printf '%q\0' "${fns[@]}"
        else
            printf '\0'
        fi
    )
}
complete -F _td td
