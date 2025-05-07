xhost +local:docker


sudo docker build --load -t my-cuda-gui-app .  
sudo docker images | grep my-cuda-gui-app

#docker run -it --rm --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v $HOME/.Xauthority:/home/devuser/.Xauthority:rw my-cuda-gui-app                                                                                                                         

MYHOME=/home/tdwebste

sudo docker run -it --rm --gpus all \
    --runtime=nvidia \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $MYHOME/.Xauthority:/home/devuser/.Xauthority:rw \
    -v $MYHOME/src/openfoam1:/home/devuser/src/openfoam:rw \
    --user devuser \
    my-cuda-gui-app
   
#    --user $(id -u):$(id -g) \  # <- Important! run as your user
