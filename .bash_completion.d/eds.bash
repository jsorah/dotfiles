# Complete args to eds(1df) with existing executables in $EDSPATH, defaulting
# to ~/.local/bin
_eds() {
    local edspath
    edspath=${EDSPATH:-"$HOME"/.local/bin}
    [[ -d $edspath ]] || return
    local executable
    while IFS= read -rd '' executable ; do
        [[ -n $executable ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$executable
    done < <(
        shopt -s dotglob nullglob
        declare -a files
        files=("${EDSPATH:-"$HOME"/.local/bin}"/"${COMP_WORDS[COMP_CWORD]}"*)
        declare -a executables
        for file in "${files[@]}" ; do
            [[ -f $file && -x $file ]] || continue
            executables[${#executables[@]}]=${file##*/}
        done

        # Print quoted entries, null-delimited, if there was at least one;
        # otherwise, just print a null character to stop this hanging in Bash
        # 4.4
        if ((${#executables[@]})) ; then
            printf '%q\0' "${executables[@]}"
        else
            printf '\0'
        fi
    )
}
complete -F _eds eds
