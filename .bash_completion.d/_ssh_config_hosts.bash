# Complete ssh_config(5) hostnames
_ssh_config_hosts() {

    # Read hostnames from existent config files, no asterisks
    local -a hosts
    local config option value
    for config in "$HOME"/.ssh/config /etc/ssh/ssh_config ; do
        [[ -e $config ]] || continue
        while read -r option value _ ; do
            [[ $option == Host ]] || continue
            [[ $value != *'*'* ]] || continue
            hosts[${#hosts[@]}]=$value
        done < "$config"
    done

    # Generate completion reply
    local host
    for host in "${hosts[@]}" ; do
        [[ $host == "${COMP_WORDS[COMP_CWORD]}"* ]] || continue
        COMPREPLY[${#COMPREPLY[@]}]=$host
    done
}
