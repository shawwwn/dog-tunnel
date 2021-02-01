#!/bin/bash
ARCH="$1"
DIR=$(dirname $(readlink -e "$0"))

[ -z "$ARCH" ] && echo "build.sh ARCH=win64|arm64" && exit 1

# set local go path
gopath="$DIR/go"
if [[ "$(uname -s)" == CYGWIN* ]]; then
	export GOPATH=$(cygpath -w "$gopath")
else
	export GOPATH="$gopath"
fi

[ ! -d "$gopath/src/github.com/vzex/dog-tunnel" ] && go get github.com/klauspost/reedsolomon
[ ! -d "$gopath/src/github.com/cznic/zappy" ] && go get github.com/cznic/zappy
[ ! -d "$gopath/src/github.com/vzex/zappy" ] && go get github.com/vzex/zappy

mkdir -p "$gopath/src/github.com/vzex/dog-tunnel/"
rsync -r --delete "$DIR/ikcp/" "$gopath/src/github.com/vzex/dog-tunnel/ikcp"
rsync -r --delete "$DIR/common/" "$gopath/src/github.com/vzex/dog-tunnel/common"
rsync -r --delete "$DIR/pipe/" "$gopath/src/github.com/vzex/dog-tunnel/pipe"
rsync -r --delete "$DIR/platform/" "$gopath/src/github.com/vzex/dog-tunnel/platform"

case "$ARCH" in
arm64)
	GOOS=linux GOARCH=arm64 go build -ldflags "-s -w" -o dtunnel_lite client.go
	;;
win64|*)
	CC="x86_64-w64-mingw32-gcc" \
	CXX="x86_64-w64-mingw32-g++" \
	GOOS=windows GOARCH=amd64 \
	go build -ldflags "-s -w" -o dtunnel_lite.exe client.go
	;;
esac

echo "done"
