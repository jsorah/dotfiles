# Completion for vared() (only if defined)
declare -F vared >/dev/null || return
complete -A variable vared
