# Email addresses from abook(1)
_abook_addresses() {
    while IFS=$'\t' read -r address _ ; do
        case $address in
            "${COMP_WORDS[COMP_CWORD]}"*)
                COMPREPLY[${#COMPREPLY[@]}]=$address
                ;;
        esac
    done < <(abook --mutt-query \@)
}
