# Make sure the shell is interactive
case $- in
    *i*) ;;
    *) return ;;
esac

# Don't do anything if restricted, not even sourcing the ENV file
# Testing $- for "r" doesn't work
# shellcheck disable=SC2128
[ -n "$BASH_VERSINFO" ] && shopt -q restricted_shell && return

# Clear away all aliases; we do this here rather than in the $ENV file shared
# between POSIX shells, because ksh relies on aliases to implement certain
# POSIX utilities, like fc(1) and type(1)
unalias -a

# If ENV is set, source it to get all the POSIX-compatible interactive stuff;
# we should be able to do this even if we're running a truly ancient Bash
[ -n "$ENV" ] && . "$ENV"

# Ensure we're using at least version 2.05. Weird arithmetic syntax needed here
# due to leading zeroes and trailing letters in some 2.x version numbers (e.g.
# 2.05a).
# shellcheck disable=SC2128
[ -n "$BASH_VERSINFO" ] || return
((BASH_VERSINFO[0] == 2)) &&
    ((10#${BASH_VERSINFO[1]%%[!0-9]*} < 5)) &&
    return

# Clear away command_not_found_handle if a system bashrc file set it up
unset -f command_not_found_handle

# Keep around 32K lines of history in file
HISTFILESIZE=$((1 << 15))

# Ignore duplicate commands
HISTCONTROL=ignoredups

# Keep the times of the commands in history
HISTTIMEFORMAT='%F %T  '

# Use a more compact format for the `time` builtin's output
TIMEFORMAT='real:%lR user:%lU sys:%lS'

# Correct small errors in directory names given to the `cd` buildtin
shopt -s cdspell
# Check that hashed commands still exist before running them
shopt -s checkhash
# Update LINES and COLUMNS after each command if necessary
shopt -s checkwinsize
# Put multi-line commands into one history entry
shopt -s cmdhist
# Include filenames with leading dots in pattern matching
shopt -s dotglob
# Enable extended globbing: !(foo), ?(bar|baz)...
shopt -s extglob
# Append history to $HISTFILE rather than overwriting it
shopt -s histappend
# If history expansion fails, reload the command to try again
shopt -s histreedit
# Load history expansion result as the next command, don't run them directly
shopt -s histverify
# Don't assume a word with a @ in it is a hostname
shopt -u hostcomplete
# Don't change newlines to semicolons in history
shopt -s lithist
# Don't try to tell me when my mail is read
shopt -u mailwarn
# Don't complete a Tab press on an empty line with every possible command
shopt -s no_empty_cmd_completion
# Use programmable completion, if available
shopt -s progcomp
# Warn me if I try to shift nonexistent values off an array
shopt -s shift_verbose
# Don't search $PATH to find files for the `source` builtin
shopt -u sourcepath

# These options only exist since Bash 4.0-alpha
if ((BASH_VERSINFO[0] >= 4)) ; then

    # Correct small errors in directory names during completion
    shopt -s dirspell
    # Allow double-star globs to match files and recursive paths
    shopt -s globstar

    # Warn me about stopped jobs when exiting
    # Available since 4.0, but only set it if >=4.1 due to bug:
    # <https://lists.gnu.org/archive/html/bug-bash/2009-02/msg00176.html>
    ((BASH_VERSINFO[1] >= 1)) && shopt -s checkjobs

    # Expand variables in directory completion
    # Only available since 4.3
    ((BASH_VERSINFO[1] >= 3)) && shopt -s direxpand
fi

# Load Bash-specific startup files
for sh in "$HOME"/.bashrc.d/*.bash ; do
    [[ -e $sh ]] && source "$sh"
done
unset -v sh

[[ $COLORTERM = gnome-terminal && ! $TERM = screen-256color ]] && TERM=xterm-256color 
eval "$(dircolors ~/.dir_colors)"
alias ls="ls --color"
