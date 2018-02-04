# Complete kill builtin with jobspecs (prefixed with % so it will accept them)
# and this user's PIDs (requires pgrep(1))
_kill() {
    local pid
    while read -r pid ; do
        case $pid in
            "${COMP_WORDS[COMP_CWORD]}"*)
                COMPREPLY[${#COMPREPLY[@]}]=$pid
                ;;
        esac
    done < <( {
        compgen -A job -P%
        pgrep -u "$USER" .
    } 2>/dev/null )
}
complete -F _kill kill
