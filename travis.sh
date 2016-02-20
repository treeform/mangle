#!/bin/bash

current=$PWD

install_nim() {
    wget "http://nim-lang.org/download/nim-0.13.0.tar.xz" -O nim.tar.xz
    mkdir nim
    tar -xvf nim.tar.xz -C nim --strip-components=1
    cd nim
    ./build.sh
    export PATH=$PATH:$PWD/bin
    cd ..
}


if [[ ! -d "tmp" ]]; then
    mkdir tmp
    cd tmp

    echo "Installing nim"
    install_nim

    cd ..
fi

export PATH=$PATH:$current/tmp/nim/bin

echo "================================================================================"

echo -e "\nNim:"
nim --version

echo "================================================================================"

nim c -r mangle_test.nim
