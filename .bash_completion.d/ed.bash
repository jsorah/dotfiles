# Completion for ed(1) with files that look editable
declare -F _text_filenames >/dev/null ||
    source "$HOME"/.bash_completion.d/_text_filenames.bash
complete -F _text_filenames -o filenames ed
