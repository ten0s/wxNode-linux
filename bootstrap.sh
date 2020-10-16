#!/bin/bash -e

DEBIAN_VER=6
NODE_VER=v0.6.21
WXWIDGETS_VER=v2.9.3

if [[ ! -d node ]]; then
    git clone https://github.com/nodejs/node.git
    pushd node
    git checkout $NODE_VER
    popd
fi

if [[ ! -d wxWidgets ]]; then
    git clone https://github.com/wxWidgets/wxWidgets.git
    pushd wxWidgets
    git checkout $WXWIDGETS_VER
    popd
fi

if [[ ! -d wxNode ]]; then
    git clone git@github.com:ten0s/wxNode.git
    pushd wxNode
    npm install
    popd
fi

docker build --rm --tag wxnode-debian-$DEBIAN_VER-node-$NODE_VER-wx-$WXWIDGETS_VER . | tee build.log

docker run -ti --rm -v $PWD/wxNode:/src/wxNode \
       wxnode-debian-$DEBIAN_VER-node-$NODE_VER-wx-$WXWIDGETS_VER
