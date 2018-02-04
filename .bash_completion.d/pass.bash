# Requires Bash >= 4.0 for globstar
((BASH_VERSINFO[0] >= 4)) || return

# Custom completion for pass(1), because I don't like the one included with the
# distribution
_pass()
{
    # If we can't read the password directory, just bail
    local passdir
    passdir=${PASSWORD_STORE_DIR:-"$HOME"/.password-store}
    [[ -r $passdir ]] || return 1

    # Iterate through list of .gpg paths, extension stripped, null-delimited,
    # and filter them down to the ones matching the completing word (compgen
    # doesn't seem to do this properly with a null delimiter)
    local entry
    while IFS= read -rd '' entry ; do
        [[ -n $entry ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$entry
    done < <(

        # Set shell options to expand globs the way we expect
        shopt -u dotglob
        shopt -s globstar nullglob

        # Gather the entries and remove their .gpg suffix
        declare -a entries
        entries=("$passdir"/"${COMP_WORDS[COMP_CWORD]}"*/**/*.gpg \
            "$passdir"/"${COMP_WORDS[COMP_CWORD]}"*.gpg)
        entries=("${entries[@]#"$passdir"/}")
        entries=("${entries[@]%.gpg}")

        # Print quoted entries, null-delimited, if there was at least one;
        # otherwise, just print a null character to stop this hanging in Bash
        # 4.4
        if ((${#entries[@]})) ; then
            printf '%q\0' "${entries[@]}"
        else
            printf '\0'
        fi
    )
}
complete -F _pass pass
