#!/bin/bash
DIR=$(dirname $(readlink -e "$0"))

# set local go path
gopath="$DIR/go"
if [[ "$(uname -s)" == CYGWIN* ]]; then
	export GOPATH=$(cygpath -w "$gopath")

	mkdir -p "$gopath/src/github.com/vzex/dog-tunnel/"
	rsync -r --delete "$DIR/ikcp/" "$gopath/src/github.com/vzex/dog-tunnel/ikcp"
	rsync -r --delete "$DIR/common/" "$gopath/src/github.com/vzex/dog-tunnel/common"
	rsync -r --delete "$DIR/pipe/" "$gopath/src/github.com/vzex/dog-tunnel/pipe"
	rsync -r --delete "$DIR/platform/" "$gopath/src/github.com/vzex/dog-tunnel/platform"
else
	export GOPATH="$gopath"
fi

go get github.com/klauspost/reedsolomon
go get github.com/cznic/zappy
go get github.com/vzex/zappy

echo "arm64"
GOOS=linux GOARCH=arm64 go build -ldflags "-s -w" -o dtunnel_lite client.go

echo "win64"
CC="x86_64-w64-mingw32-gcc" \
CXX="x86_64-w64-mingw32-g++" \
GOOS=windows GOARCH=amd64 \
go build -ldflags "-s -w" -o dtunnel_lite.exe client.go

echo "done"
