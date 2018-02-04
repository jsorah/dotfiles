# Completion for `source` with files that look like plain text
declare -F _text_filenames >/dev/null ||
    source "$HOME"/.bash_completion.d/_text_filenames.bash
complete -F _text_filenames -o filenames source
