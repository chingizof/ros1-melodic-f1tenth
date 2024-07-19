#!/bin/bash

# Allow local connections to X server
xhost +local:root

# Run the Docker container with the specified options
docker run -it --rm --name racecar --privileged \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --network=host \
    --device=/dev/ttyUSB0 \
    ros1-melodic-f1tenth:latest

# Disallow local connections to X server
xhost -local:root
