```
$ ./bootstrap.sh
```

```
$ cd /src/wxNode
$ cp -f /src/wxWidgets/wxapi.xml .
$ rm -rf build wxapi.json
$ node mnm.js build
```

```
$ ssh -X root@172.17.0.2
$ cd /src/wxNode
$ node examples/helloWorld.js
$ node examples/taborder.js
``
