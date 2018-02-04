#!/bin/bash

GLOBIGNORE=".:..:README.md:install.sh:.git"

for file in * ; do
    cp -vr "${file}" "${HOME}"
done

unset -v file
