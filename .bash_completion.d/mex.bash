# Completion setup for mex(1df), completing non-executable files in $PATH
_mex() {
    local -a path
    IFS=: read -ra path < <(printf '%s\n' "$PATH")
    local dir name
    for dir in "${path[@]}" ; do
        [[ -d $dir ]] || continue
        for name in "$dir"/* ; do
            [[ -f $name ]] || continue
            ! [[ -x $name ]] || continue
            COMPREPLY[${#COMPREPLY[@]}]=${name##*/}
        done
    done
}
complete -F _mex mex
