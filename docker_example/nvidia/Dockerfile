# Use the specified NVIDIA CUDA base image
FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts during build
ARG DEBIAN_FRONTEND=noninteractive

# Set up user arguments (optional, allows customization at build time)
ARG USERNAME=devuser
ARG USER_UID=1010
ARG USER_GID=1010

# Update package lists and install xterm, sudo, and basic utilities
# --no-install-recommends keeps the image slightly smaller
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    xterm \
    sudo \
    vim \
    vim-gtk3 \
    procps \
    iproute2 \
    mesa-utils \
    apt-file \
    aptitude \
    etckeeper \
    cmake \ 
    python3 \
    ninja-build \
    nvidia-utils-570-server \
atop \
autoconf \
automake \
autotools-dev \
btop \
cron \
cron-daemon-common \
file \
flex \
hwloc \
ibverbs-providers:amd64 \
ibverbs-utils \
libamd-comgr2:amd64 \
libamdhip64-5 \
libauthen-sasl-perl \
libcbor0.10:amd64 \
libclone-perl:amd64 \
libdata-dump-perl \
libdouble-conversion3:amd64 \
libegl-dev:amd64 \
libencode-locale-perl \
libevdev2:amd64 \
libevent-2.1-7t64:amd64 \
libevent-core-2.1-7t64:amd64 \
libevent-dev \
libevent-extra-2.1-7t64:amd64 \
libevent-openssl-2.1-7t64:amd64 \
libevent-pthreads-2.1-7t64:amd64 \
libfido2-1:amd64 \
libfile-listing-perl \
libfl-dev:amd64 \
libfl2:amd64 \
libfont-afm-perl \
libgl-dev:amd64 \
libglu1-mesa:amd64 \
libglu1-mesa-dev:amd64 \
libglx-dev:amd64 \
libgmp-dev:amd64 \
libgmpxx4ldbl:amd64 \
libgudev-1.0-0:amd64 \
libhsa-runtime64-1 \
libhsakmt1:amd64 \
libhtml-form-perl \
libhtml-format-perl \
libhtml-parser-perl:amd64 \
libhtml-tagset-perl \
libhtml-tree-perl \
libhttp-cookies-perl \
libhttp-daemon-perl \
libhttp-date-perl \
libhttp-message-perl \
libhttp-negotiate-perl \
libhwloc-dev:amd64 \
libhwloc-plugins:amd64 \
libhwloc15:amd64 \
libibverbs-dev:amd64 \
libibverbs1:amd64 \
libinput-bin \
libinput10:amd64 \
libio-html-perl \
libio-socket-ssl-perl \
libllvm17t64:amd64 \
libltdl-dev:amd64 \
liblwp-mediatypes-perl \
liblwp-protocol-https-perl \
libmagic-mgc \
libmagic1t64:amd64 \
libmailtools-perl \
libmd4c0:amd64 \
libmetis-dev \
libmetis5:amd64 \
libmpfr-dev:amd64 \
libmtdev1t64:amd64 \
libnet-http-perl \
libnet-smtp-ssl-perl \
libnet-ssleay-perl:amd64 \
libnl-3-200:amd64 \
libnl-3-dev:amd64 \
libnl-route-3-200:amd64 \
libnl-route-3-dev:amd64 \
libnuma-dev:amd64 \
libnuma1:amd64 \
libopengl-dev:amd64 \
libopengl0:amd64 \
libpcre2-16-0:amd64 \
libpkgconf3:amd64 \
libpthread-stubs0-dev:amd64 \
libqt5concurrent5t64:amd64 \
libqt5core5t64:amd64 \
libqt5dbus5t64:amd64 \
libqt5gui5t64:amd64 \
libqt5network5t64:amd64 \
libqt5opengl5-dev:amd64 \
libqt5opengl5t64:amd64 \
libqt5printsupport5t64:amd64 \
libqt5qml5:amd64 \
libqt5qmlmodels5:amd64 \
libqt5quick5:amd64 \
libqt5sql5-sqlite:amd64 \
libqt5sql5t64:amd64 \
libqt5svg5:amd64 \
libqt5test5t64:amd64 \
libqt5waylandclient5:amd64 \
libqt5waylandcompositor5:amd64 \
libqt5widgets5t64:amd64 \
libqt5xml5t64:amd64 \
librdmacm1t64:amd64 \
libtext-unidecode-perl \
libtimedate-perl \
libtool \
libtry-tiny-perl \
libucx-dev:amd64 \
libucx0:amd64 \
liburi-perl \
libvulkan-dev:amd64 \
libwacom-common \
libwacom9:amd64 \
libwww-perl \
libwww-robotrules-perl \
libx11-dev:amd64 \
libx11-xcb-dev:amd64 \
libxau-dev:amd64 \
libxcb-composite0:amd64 \
libxcb-composite0-dev:amd64 \
libxcb-cursor-dev:amd64 \
libxcb-cursor0:amd64 \
libxcb-damage0:amd64 \
libxcb-damage0-dev:amd64 \
libxcb-dpms0:amd64 \
libxcb-dpms0-dev:amd64 \
libxcb-dri2-0-dev:amd64 \
libxcb-dri3-dev:amd64 \
libxcb-ewmh-dev:amd64 \
libxcb-ewmh2:amd64 \
libxcb-glx0-dev:amd64 \
libxcb-icccm4:amd64 \
libxcb-icccm4-dev:amd64 \
libxcb-image0:amd64 \
libxcb-image0-dev:amd64 \
libxcb-imdkit-dev:amd64 \
libxcb-imdkit1:amd64 \
libxcb-keysyms1:amd64 \
libxcb-keysyms1-dev:amd64 \
libxcb-present-dev:amd64 \
libxcb-randr0-dev:amd64 \
libxcb-record0:amd64 \
libxcb-record0-dev:amd64 \
libxcb-render-util0:amd64 \
libxcb-render-util0-dev:amd64 \
libxcb-render0-dev:amd64 \
libxcb-res0:amd64 \
libxcb-res0-dev:amd64 \
libxcb-screensaver0:amd64 \
libxcb-screensaver0-dev:amd64 \
libxcb-shape0:amd64 \
libxcb-shape0-dev:amd64 \
libxcb-shm0-dev:amd64 \
libxcb-sync-dev:amd64 \
libxcb-util-dev:amd64 \
libxcb-util0-dev:amd64 \
libxcb-util1:amd64 \
libxcb-xf86dri0:amd64 \
libxcb-xf86dri0-dev:amd64 \
libxcb-xfixes0-dev:amd64 \
libxcb-xinerama0:amd64 \
libxcb-xinerama0-dev:amd64 \
libxcb-xinput-dev:amd64 \
libxcb-xinput0:amd64 \
libxcb-xkb-dev:amd64 \
libxcb-xrm-dev:amd64 \
libxcb-xrm0:amd64 \
libxcb-xtest0:amd64 \
libxcb-xtest0-dev:amd64 \
libxcb-xv0:amd64 \
libxcb-xv0-dev:amd64 \
libxcb-xvmc0:amd64 \
libxcb-xvmc0-dev:amd64 \
libxcb1-dev:amd64 \
libxdmcp-dev:amd64 \
libxext-dev:amd64 \
libxfixes-dev:amd64 \
libxi-dev:amd64 \
libxkbcommon-dev:amd64 \
libxkbcommon-x11-dev:amd64 \
libxml-libxml-perl \
libxml-namespacesupport-perl \
libxml-parser-perl \
libxml-sax-base-perl \
libxml-sax-expat-perl \
libxml-sax-perl \
libxmuu1:amd64 \
libxnvctrl0:amd64 \
libxrender-dev:amd64 \
m4 \
metis \
ocl-icd-libopencl1:amd64 \
openssh-client \
perl-openssl-defaults:amd64 \
pkg-config:amd64 \
pkgconf:amd64 \
pkgconf-bin \
qt5-gtk-platformtheme:amd64 \
qt5-qmake:amd64 \
qt5-qmake-bin \
qtbase5-dev:amd64 \
qtbase5-dev-tools \
qtchooser \
qttranslations5-l10n \
qtwayland5:amd64 \
tex-common \
texinfo \
texinfo-lib \
ucf \
wget \
x11proto-dev \
xauth \
xorg-sgml-doctools \
xtrans-dev \
zlib1g-dev:amd64 \
    # Add any other development tools or libraries you need here
 && apt-get upgrade -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user with sudo privileges (without password)
# This is generally better practice than running everything as root
RUN groupadd --gid $USER_GID $USERNAME && \
     useradd --uid $USER_UID --gid $USER_GID -m --shell /bin/bash $USERNAME && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME


RUN mkdir -p /home/$USERNAME/src/openfoam

# Switch to the non-root user
USER $USERNAME

# Set the working directory to the user's home
WORKDIR /home/$USERNAME

# Set environment variable for applications to find the Xauthority file
# This file will be mounted from the host at runtime
ENV XAUTHORITY=/home/$USERNAME/.Xauthority

# Default command when the container starts (optional, can be overridden)
# Opens a bash shell by default. You can run 'xterm' from here.
#USER root
CMD ["/bin/bash"]
