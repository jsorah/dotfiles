# Make pushd default to $HOME if no arguments given, much like cd
pushd() {
    builtin pushd "${@:-"$HOME"}"
}
