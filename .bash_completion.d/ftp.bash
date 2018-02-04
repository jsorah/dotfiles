# Completion for ftp(1) with .netrc machines
_ftp() {

    # Bail if the .netrc file is illegible
    local netrc
    netrc=$HOME/.netrc
    [[ -r $netrc ]] || return 1

    # Tokenize the file
    local -a tokens
    read -a tokens -d '' -r < "$netrc"

    # Iterate through tokens and collect machine names
    local -a machines
    local -i nxm
    local token
    for token in "${tokens[@]}" ; do
        if ((nxm)) ; then
            machines[${#machines[@]}]=$token
            nxm=0
        elif [[ $token == machine ]] ; then
            nxm=1
        fi
    done

    # Generate completion reply
    local machine
    for machine in "${machines[@]}" ; do
        [[ $machine == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$machine
    done
}

# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _ftp -o bashdefault -o default ftp
else
    complete -F _ftp -o default ftp
fi
