# Completion for sftp(1) with ssh_config(5) hostnames
declare -F _ssh_config_hosts >/dev/null ||
    source "$HOME"/.bash_completion.d/_ssh_config_hosts.bash

# bashdefault requires Bash >=3.0
if ((BASH_VERSINFO[0] >= 3)) ; then
    complete -F _ssh_config_hosts -o bashdefault -o default sftp
else
    complete -F _ssh_config_hosts -o default sftp
fi
