# Start from Ubuntu
FROM ubuntu:bionic

# Update so we can download packages
RUN apt-get update && apt-get upgrade -y
# Set the ROS distro
ENV ROS_DISTRO melodic
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		curl \
		wget \
		gnupg2 \
		lsb-release \
		ca-certificates \
        console-setup \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Add the ROS GPG key
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Add the ROS repository
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list

# install Python 3    
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-dev 

# Set up ROS
RUN apt-get update && apt-get install -y \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential

# Install ROS Melodic packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ros-${ROS_DISTRO}-desktop-full \
        ros-${ROS_DISTRO}-tf2-geometry-msgs \
        ros-${ROS_DISTRO}-ackermann-msgs \
        ros-${ROS_DISTRO}-navigation \
        ros-${ROS_DISTRO}-xacro \
        ros-${ROS_DISTRO}-joy \
        python-catkin-tools \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Initialize rosdep
RUN rosdep init
RUN rosdep update

# Install VNC and things to install noVNC
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    wget \
    git \
    unzip


# Download NoVNC and unpack
ENV NO_VNC_VERSION 1.4.0
RUN wget -q https://github.com/novnc/noVNC/archive/v$NO_VNC_VERSION.zip
RUN unzip v$NO_VNC_VERSION.zip
RUN rm v$NO_VNC_VERSION.zip
RUN git clone https://github.com/novnc/websockify /noVNC-$NO_VNC_VERSION/utils/websockify

# Install a window manager
RUN apt-get update && apt-get install -y \
    openbox \
    x11-xserver-utils \
    xterm \
    dbus-x11

# Set up locales
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    locales \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV PYTHONIOENCODING=utf-8

# Install additional required packages for ROS
RUN apt update && apt install -y \
    build-essential \
    cython \
    libfreetype6-dev

# Install some cool programs
RUN apt update && apt install -y \
    sudo \
    vim \
    emacs \
    nano \
    gedit \
    screen \
    tmux \
    iputils-ping \
    feh 

# Install Python packages
RUN python3 -m pip install --upgrade pip
RUN pip3 install transforms3d \
    imutils

# Kill the bell!
RUN echo "set bell-style none" >> /etc/inputrc

# Copy in the entrypoint
COPY ./entrypoint.sh /usr/bin/entrypoint.sh
COPY ./xstartup.sh /usr/bin/xstartup.sh

# add required packages
RUN apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-driver-base 

# add Realsense2 SDK, register server public key
# RUN sudo apt-get -y --no-install-recommends  dist-upgrade; 

# Install the core packages required to build librealsense
# RUN sudo apt-get install -y --no-install-recommends \
    # libssl-dev libusb-1.0-0-dev libudev-dev pkg-config libgtk-3-dev

# install build tools
# RUN sudo apt-get install -y --no-install-recommends  git wget cmake build-essential

#install 
# RUN sudo apt-get install -y --no-install-recommends  libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev at v4l-utils


#Clone/Download the latest stable version of librealsense2 
# RUN git clone https://github.com/IntelRealSense/librealsense.git

#Run Intel Realsense permissions script from librealsense2 root directory
# RUN cd librealsense; sh ./scripts/setup_udev_rules.sh

#Build and apply patched kernel modules for UBUNTU 18
# RUN cd librealsense; sh ./scripts/patch-realsense-ubuntu-lts.sh

# Build SDK
# RUN mkdir build && cd build; cmake ../ ; sudo make uninstall && make clean && make && sudo make install; cd ~/home/sdc




# Copy your existing workspace into the Docker container
COPY ./f1tenth_ws /home/sdc/sandbox/f1tenth_ws

#delete realsense sdk for now
RUN rm -rf /home/sdc/sandbox/f1tenth_ws/build/realsense2_camera && rm -rf /home/sdc/sandbox/f1tenth_ws/build/realsense2_description

# Source the ROS setup.bash file and build the workspace
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash; cd /home/sdc/sandbox/f1tenth_ws; catkin build --skip-packages realsense2_camera"

# Copy in default config files
COPY ./config/bash.bashrc /etc/
COPY ./config/screenrc /etc/
COPY ./config/vimrc /etc/vim/vimrc
ADD ./config/openbox /etc/X11/openbox/
COPY ./config/XTerm /etc/X11/app-defaults/
COPY ./config/default.rviz /tmp/

# Create a user
RUN useradd -ms /bin/bash sdc
RUN echo 'sdc:sdc@lehigh.edu' | chpasswd
RUN usermod -aG sudo sdc
USER sdc
WORKDIR /home/sdc

# Set the entrypoint
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
