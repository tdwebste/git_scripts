

docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS                      PORTS                                         NAMES
5e93fef2f0d7   my-cuda-gui-app         "/opt/nvidia/nvidia_…"   6 minutes ago   Up 6 minutes                                                              loving_bouman
3d889357ff6b   j4ym0/pia-qbittorrent   "/bin/sh -c /entrypo…"   13 months ago   Up 15 minutes (unhealthy)   0.0.0.0:8888->8888/tcp, [::]:8888->8888/tcp   pia


#take an image of the current docker 

./snashot_docker.sh

run the image commited

./run_docker_image.sh my-cuda-gui-app_snapshot:latest
docker ps 


##build openmpi
sudo apt install hwloc libhwloc-dev pkg-config
sudo apt install libucx-dev
sudo apt install libibverbs-dev ibverbs-utils

sudo apt install libevent-dev


git clone https://github.com/openucx/ucx.git
cd ucx
git checkout v1.15.0
./autogen.sh
./configure --prefix=/opt/ucx-1.15.0 --enable-cuda
make -j$(nproc)
sudo make install

export UCX_DIR=/opt/ucx-1.15.0
export CPPFLAGS="-I$UCX_DIR/include $CPPFLAGS"
export LDFLAGS="-L$UCX_DIR/lib $LDFLAGS"
export PKG_CONFIG_PATH="$UCX_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"

cd ~/src/openfoam
git clone https://github.com/open-mpi/ompi.git

git tag -l | grep v4.1.2
git checkout  v4.1.2

#check current commit
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold black)%ci %C(bold blue)%ae <%an>%Creset' --decorate --abbrev-commit -n 5


#alternative build
tar xf openmpi-4.1.2.tar.gz 

cd openmpi-4.1.2 
./configure --prefix=/opt/openmpi-4.1.2 \
            --with-cuda \
            --with-hwloc=external \
            --with-ucx=$UCX_DIR \
            --with-verbs \
            --with-slurm \
            --with-libevent=external

make -j $(nproc) all 
sudo make install 



