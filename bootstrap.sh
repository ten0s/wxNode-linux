#!/bin/bash -e

if [[ ! -d node ]]; then
    git clone https://github.com/nodejs/node.git
    pushd node
    git checkout v0.6.21
    popd
fi

if [[ ! -d wxWidgets ]]; then
    git clone https://github.com/wxWidgets/wxWidgets.git
    pushd wxWidgets
    git checkout v2.9.3
    popd
fi

if [[ ! -d wxNode ]]; then
    git clone git@github.com:ten0s/wxNode.git
fi

docker build --rm --tag wx-test . | tee build.log

docker run -ti --rm -v $PWD/wxNode:/src/wxNode wx-test
