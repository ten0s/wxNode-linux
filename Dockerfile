FROM rgrubba/debian-squeeze

RUN apt-get update --yes
RUN apt-get install --yes --force-yes \
    build-essential                   \
    mc                                \
    net-tools                         \
    python

RUN mkdir -p /src

RUN apt-get install --yes --force-yes libssl-dev
COPY node /src/node
RUN cd /src/node && \
    ./configure  && \
    make         && \
    make install && \
    cd /
RUN node --version

RUN apt-get install --yes --force-yes doxygen gccxml libgtk2.0-dev libwebkitgtk-dev
COPY wxWidgets /src/wxWidgets
COPY etc/rungccxml.sh.patch /src/wxWidgets/
COPY etc/strvararg.h.patch /src/wxWidgets/
RUN cd /src/wxWidgets                  && \
    mkdir build_gtk                    && \
    cd build_gtk                       && \
    ../configure --with-gtk               \
                 --enable-unicode         \

#                 --disable-shared         \

#                 --disable-clipboard      \

#                 --disable-dataobj        \
#                 --disable-dialupman      \
#                 --disable-docview        \
#                 --disable-dnd            \
#                 --disable-dynlib         \
#                 --disable-dynamicloader  \

#                 --disable-fileproto      \
#                 --disable-ffile          \
#                 --disable-file           \
#                 --disable-filehistory    \
#                 --disable-fileproto      \
#                 --disable-filesystem     \
#                 --disable-fontenum       \
#                 --disable-fontmap        \
#                 --disable-fs_archive     \
#                 --disable-fs_inet        \
#                 --disable-fs_zip         \
#                 --disable-fswatcher      \
#                 --disable-ftp            \

#                 --disable-gstreamer8     \

#                 --disable-html           \
#                 --disable-htmlhelp       \
#                 --disable-http           \

#                 --disable-ipc            \
#                 --disable-iniconf        \

#                 --disable-markup         \
#                 --disable-mediactrl      \
#                 --disable-mdi            \
#                 --disable-mdidoc         \
#                 --disable-mimetype       \

#                 --disable-ole            \
#                 --disable-ownerdrawn     \

#                 --disable-postscript     \
#                 --disable-printarch      \
#                 --disable-protocols      \

#                 --disable-regkey         \
#                 --disable-richtext       \

#                 --disable-snglinst       \
#                 --disable-sockets        \
#                 --disable-sound          \
#                 --disable-stdpaths       \
#                 --disable-stopwatch      \
#                 --disable-streams        \
#                 --disable-svg            \
#                 --disable-sysoptions     \

#                 --disable-tarstream      \
#                 --disable-tls            \

#                 --disable-url            \

                 --disable-webkit         \
                 --disable-webview        \
                 --disable-webviewie      \
                 --disable-webviewwebkit  \

#                 --disable-xlocale        \

                 --without-gtkprint       \
                 --without-gnomeprint     \
                                       && \
    make                               && \
    make install                       && \
    ldconfig                           && \
    cd ..

RUN cd /src/wxWidgets/docs/doxygen/     && \
    ./regen.sh xml                      && \
    cd ../..                            && \
    ./configure --with-gtk                 \
                --enable-unicode           \
                --without-gtkprint         \
                --without-gnomeprint       \
                                        && \
    patch -p0 -i rungccxml.sh.patch     && \
    patch -p0 -i strvararg.h.patch      && \
    cd utils/ifacecheck/                && \
    ./rungccxml.sh                      && \
    cp wxapi.xml /src/wxWidgets

#COPY wxNode    /src/wxNode

RUN apt-get --yes --force-yes install net-tools openssh-server
COPY etc/sshd_config /etc/ssh/sshd_config

RUN mkdir -p /root/.ssh/
COPY etc/id_rsa.pub /root/.ssh/authorized_keys

RUN ifconfig eth0

RUN mkdir -p -m0755 /var/run/sshd
CMD /usr/sbin/sshd && /bin/bash
