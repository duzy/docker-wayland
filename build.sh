#!/bin/sh

dir="$(cd $(dirname $0); pwd)"
tag="duzy/wayland"

dir="$dir/development"
tag="$tag-dev"

docker build -t $tag $dir
