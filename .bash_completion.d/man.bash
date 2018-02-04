# Autocompletion for man(1)
_man() {

    # Don't even bother if we don't have manpath(1)
    hash manpath 2>/dev/null || return 1

    # Snarf the word
    local word
    word=${COMP_WORDS[COMP_CWORD]}

    # Don't bother if the word has slashes in it, the user is probably trying
    # to complete an actual path
    case $word in
        */*) return 1 ;;
    esac

    # If this is the second word, and the previous word started with a number,
    # we'll assume that's the section to search
    local section subdir
    if ((COMP_CWORD > 1)) && [[ ${COMP_WORDS[COMP_CWORD-1]} == [0-9]* ]] ; then
        section=${COMP_WORDS[COMP_CWORD-1]}
        subdir=man${section%%[^0-9]*}
    fi

    # Read completion results from a subshell and add them to the COMPREPLY
    # array individually
    local page
    while IFS= read -rd '' page ; do
        [[ -n $page ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$page
    done < <(

        # Do not return dotfiles, give us extended globbing, and expand empty
        # globs to just nothing
        shopt -u dotglob
        shopt -s extglob nullglob

        # Break manpath(1) output into an array of paths
        declare -a manpaths
        IFS=: read -a manpaths -r < <(manpath 2>/dev/null)

        # Iterate through the manual page paths and add every manual page we find
        declare -a pages
        for manpath in "${manpaths[@]}" ; do
            [[ -n $manpath ]] || continue
            if [[ -n $section ]] ; then
                for page in "$manpath"/"$subdir"/"$word"*."$section"?(.[glx]z|.bz2|.lzma|.Z) ; do
                    pages[${#pages[@]}]=$page
                done
            else
                for page in "$manpath"/man[0-9]*/"$word"*.* ; do
                    pages[${#pages[@]}]=$page
                done
            fi
        done

        # Strip paths, .gz suffixes, and finally .<section> suffixes
        pages=("${pages[@]##*/}")
        pages=("${pages[@]%.@([glx]z|bz2|lzma|Z)}")
        pages=("${pages[@]%.[0-9]*}")

        # Print quoted entries, null-delimited, if there was at least one;
        # otherwise, just print a null character to stop this hanging in Bash
        # 4.4
        if ((${#pages[@]})) ; then
            printf '%q\0' "${pages[@]}"
        else
            printf '\0'
        fi
    )
}

# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _man -o bashdefault -o default man
else
    complete -F _man -o default man
fi
