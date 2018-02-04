# compopt requires Bash >=4.0, and I don't think it's worth making a compatible
# version
((BASH_VERSINFO[0] >= 4)) || return

# Semi-intelligent completion for find(1); nothing too crazy
_find() {

    # Backtrack through words so far; if none of them look like options, we're
    # still completing directory names
    local i
    local -i opts
    for ((i = COMP_CWORD; i >= 0; i--)) ; do
        case ${COMP_WORDS[i]} in
            -*)
                opts=1
                break
                ;;
        esac
    done
    if ! ((opts)) ; then
        compopt -o dirnames
        return
    fi

    # For the rest of this, if we end up with an empty COMPREPLY, we should
    # just do what Bash would normally do
    compopt -o bashdefault -o default

    # Iterate through whatever the subshell gives us; don't add blank items, though
    local item
    while read -r item ; do
        [[ -n $item ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$item
    done < <(

        # If the word being completed starts with a dash, just complete it as
        # an option; crude, but simple, and will be right the vast majority of
        # the time
        case ${COMP_WORDS[COMP_CWORD]} in
            (-*)
                compgen -W '
                    -atime
                    -ctime
                    -depth
                    -exec
                    -group
                    -links
                    -mtime
                    -name
                    -newer
                    -nogroup
                    -nouser
                    -ok
                    -perm
                    -print
                    -prune
                    -size
                    -type
                    -user
                    -xdev
                ' -- "${COMP_WORDS[COMP_CWORD]}"
                ;;
        esac

        # Otherwise, look at the word *before* this one to figure out what to
        # complete
        case "${COMP_WORDS[COMP_CWORD-1]}" in

            # Args to -exec and -execdir should be commands
            (-exec|-execdir)
                compgen -A command -- "${COMP_WORDS[COMP_CWORD]}"
                ;;

            # Args to -group should complete group names
            (-group)
                compgen -A group -- "${COMP_WORDS[COMP_CWORD]}"
                ;;

            # Legal POSIX flags for -type
            (-type)
                compgen -W 'b c d f l p s' -- "${COMP_WORDS[COMP_CWORD]}"
                ;;

            # Args to -user should complete usernames
            (-user)
                compgen -A user -- "${COMP_WORDS[COMP_CWORD]}"
                ;;
        esac
    )
}
complete -F _find find
