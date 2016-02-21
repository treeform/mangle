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

install_nimble() {
    git clone https://github.com/nim-lang/nimble.git
    cd nimble
    git clone -b v0.13.0 --depth 1 https://github.com/nim-lang/nim vendor/nim
    nim c -r src/nimble
    export PATH=$PATH:$PWD/src
    cd ..
}


echo "Installing nim"
install_nim

echo "Installing nimble"
install_nimble

git clone https://github.com/ivankoster/nimbench 

nimble install -y strfmt

export PATH=$PATH:$current/tmp/nim/bin
export PATH=$PATH:$current/nimble/src

echo "================================================================================"

echo -e "\nNim:"
nim --version

echo -e "\nNimble:"
nimble --version

nim c --threads:on mangle_test.nim
nim c --threads:on -d:release mangle_bench.nim

echo ""
echo ""
echo "================================================================================"
echo "=                               Running tests                                  =" 
echo "================================================================================"
./mangle_test

echo ""
echo ""
echo "================================================================================"
echo "=                             Running benchmarks                               =" 
echo "================================================================================"
./mangle_bench
