# Load ~/.profile regardless of shell version
[ -e "$HOME"/.profile ] && . "$HOME"/.profile

# If POSIXLY_CORRECT is set after doing that, force the `posix` option on and
# don't load the rest of this stuff--so, just ~/.profile and ENV
if [ -n "$POSIXLY_CORRECT" ] ; then
    set -o posix
    return
fi

# If ~/.bashrc exists, source that too; the tests for both interactivity and
# >=2.05a (for features like [[) are in there
[ -f "$HOME"/.bashrc ] && . "$HOME"/.bashrc
