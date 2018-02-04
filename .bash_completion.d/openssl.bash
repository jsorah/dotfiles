# Some simple completion for openssl(1ssl)
_openssl() {

    # Only complete the first word: OpenSSL subcommands
    case $COMP_CWORD in
        1)
            while read -r subcmd ; do
                case $subcmd in
                    '') ;;
                    "${COMP_WORDS[COMP_CWORD]}"*)
                        COMPREPLY[${#COMPREPLY[@]}]=$subcmd
                        ;;
                esac
            done < <(
                for arg in \
                list-cipher-commands \
                list-standard-commands \
                list-message-digest-commands ; do
                    printf '%s\n' "$arg"
                    openssl "$arg"
                done
            )
            ;;
    esac
}

# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _openssl -o bashdefault -o default openssl
else
    complete -F _openssl -o default openssl
fi
