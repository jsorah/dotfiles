# Some simple completion for Git
_git() {

    # Subcommands for this function to stack words onto COMPREPLY; if the first
    # argument is not given, the rest of the function is reached
    case $1 in

        # No argument; continue normal completion
        '') ;;

        # Symbolic references, remote or local
        refs)
            local ref
            while IFS= read -r ref ; do
                [[ -n $ref ]] || continue
                ref=${ref#refs/*/}
                case $ref in
                    "${COMP_WORDS[COMP_CWORD]}"*)
                        COMPREPLY[${#COMPREPLY[@]}]=$ref
                        ;;
                esac
            done < <(git for-each-ref \
                --format '%(refname)' \
                2>/dev/null)
            return
            ;;

        # Remote names
        remotes)
            local remote
            while IFS= read -r remote ; do
                case $remote in
                    '') continue ;;
                    "${COMP_WORDS[COMP_CWORD]}"*)
                        COMPREPLY[${#COMPREPLY[@]}]=$remote
                        ;;
                esac
            done < <(git remote 2>/dev/null)
            return
            ;;

        # Git aliases
        aliases)
            local alias
            while IFS= read -r alias ; do
                alias=${alias#alias.}
                alias=${alias%% *}
                case $alias in
                    '') continue ;;
                    "${COMP_WORDS[COMP_CWORD]}"*)
                        COMPREPLY[${#COMPREPLY[@]}]=$alias
                        ;;
                esac
            done < <(git config \
                --get-regexp '^alias\.' \
                2>/dev/null)
            return
            ;;

        # Git subcommands
        subcommands)
            local execpath
            execpath=$(git --exec-path) || return
            local path
            for path in "$execpath"/git-"${COMP_WORDS[COMP_CWORD]}"* ; do
                [[ -f $path ]] || continue
                [[ -x $path ]] || continue
                COMPREPLY[${#COMPREPLY[@]}]=${path#"$execpath"/git-}
            done
            return
            ;;
    esac

    # Try to find the index of the Git subcommand
    local -i sci i
    for ((i = 1; !sci && i <= COMP_CWORD; i++)) ; do
        case ${COMP_WORDS[i]} in

            # Skip --option=value
            --*=*) ;;

            # These ones have arguments, so bump the index up one more
            -C|-c|--exec-path|--git-dir|--work-tree|--namespace) ((i++)) ;;

            # Skip --option
            --?*) ;;

            # We have hopefully found our subcommand
            *) ((sci = i)) ;;
        esac
    done

    # Complete initial subcommand or alias
    if ((sci == COMP_CWORD)) ; then
        "${FUNCNAME[0]}" subcommands
        "${FUNCNAME[0]}" aliases
        return
    fi

    # Test subcommand to choose completions
    case ${COMP_WORDS[sci]} in

        # Help on real subcommands (not aliases)
        help)
            "${FUNCNAME[0]}" subcommands
            return
            ;;

        # Complete with remote subcommands and then remote names
        remote)
            if ((COMP_CWORD == 2)) ; then
                local word
                while IFS= read -r word ; do
                    [[ -n $word ]] || continue
                    COMPREPLY[${#COMPREPLY[@]}]=$word
                done < <(compgen -W '
                    add
                    get-url
                    prune
                    remove
                    rename
                    set-branches
                    set-head
                    set-url
                    show
                    update
                ' -- "${COMP_WORDS[COMP_CWORD]}")
            else
                "${FUNCNAME[0]}" remotes
            fi
            return
            ;;

        # Complete with stash subcommands
        stash)
            ((COMP_CWORD == 2)) || return
            local word
            while IFS= read -r word ; do
                [[ -n $word ]] || continue
                COMPREPLY[${#COMPREPLY[@]}]=$word
            done < <(compgen -W '
                apply
                branch
                clear
                create
                drop
                list
                pop
                save
                show
                store
            ' -- "${COMP_WORDS[COMP_CWORD]}")
            return
            ;;

        # Complete with submodule subcommands
        submodule)
            ((COMP_CWORD == 2)) || return
            local word
            while IFS= read -r word ; do
                [[ -n $word ]] || continue
                COMPREPLY[${#COMPREPLY[@]}]=$word
            done < <(compgen -W '
                add
                deinit
                foreach
                init
                status
                summary
                sync
                update
            ' -- "${COMP_WORDS[COMP_CWORD]}")
            return
            ;;

        # Complete with remotes and then refs
        fetch|pull|push)
            if ((COMP_CWORD == 2)) ; then
                "${FUNCNAME[0]}" remotes
            else
                "${FUNCNAME[0]}" refs
            fi
            ;;

        # Commands for which I'm likely to want a ref
        branch|checkout|merge|rebase|tag)
            "${FUNCNAME[0]}" refs
            ;;

        # I normally only want a refspec for "reset" if I'm using the --hard or
        # --soft option; otherwise, files are fine
        reset)
            case ${COMP_WORDS[COMP_CWORD-1]} in
                --hard|--soft)
                    "${FUNCNAME[0]}" refs
                    ;;
            esac
            ;;
    esac
}

# Defaulting to directory/file completion is important in Git's case;
# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _git -o bashdefault -o default git
else
    complete -F _git -o default git
fi
