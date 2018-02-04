pathmunge () {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}

pathmunge "${HOME}/.cargo/bin"
pathmunge "${HOME}/go/bin"
pathmunge "${HOME}/bin"

unset -f pathmunge
