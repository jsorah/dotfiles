# Completion function for sd; any sibling directories, excluding the self
_sd() {

    # Only makes sense for the first argument
    ((COMP_CWORD == 1)) || return 1

    # Current directory can't be root directory
    [[ $PWD != / ]] || return 1

    # Build list of matching sibling directories
    local dirname
    while IFS= read -rd '' dirname ; do
        [[ -n $dirname ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$dirname
    done < <(

        # Set options to glob correctly
        shopt -s dotglob nullglob

        # Collect directory names, strip leading ../ and trailing /
        local -a dirnames
        dirnames=(../"${COMP_WORDS[COMP_CWORD]}"*/)
        dirnames=("${dirnames[@]#../}")
        dirnames=("${dirnames[@]%/}")

        # Iterate again, but exclude the current directory this time
        local -a sibs
        local dirname
        for dirname in "${dirnames[@]}" ; do
            [[ $dirname != "${PWD##*/}" ]] || continue
            sibs[${#sibs[@]}]=$dirname
        done

        # Print quoted sibs, null-delimited, if there was at least one;
        # otherwise, just print a null character to stop this hanging in Bash
        # 4.4
        if ((${#sibs[@]})) ; then
            printf '%q\0' "${sibs[@]}"
        else
            printf '\0'
        fi
    )
}
complete -F _sd sd
