#!/bin/sh

image=duzy/wayland
container=wayland

cleanup() {
    docker stop $container >/dev/null
    docker rm $container >/dev/null
}

running=$(docker ps -a -q --filter "name=${container}")
if [ -n "$running" ]; then
    cleanup
fi

docker run -d \
    --name $container \
    -v "$(pwd):/home/user/work" \
    --device=/dev/dri/card0:/dev/dri/card0 \
    --device=/dev/dri/card1:/dev/dri/card1 \
    --device=/dev/dri/controlD64:/dev/dri/controlD64 \
    --device=/dev/dri/controlD65:/dev/dri/controlD65 \
    $image >/dev/null

finally() {
    #docker cp $container:/var/log/supervisor/graphical-app-launcher.log - | tar xO
    #result=$(docker cp $container:/tmp/graphical-app.return_code - | tar xO)
    cleanup
    exit $result
}

trap "docker stop $container >/dev/null && finally" SIGINT SIGTERM

docker wait $container >/dev/null

finally
