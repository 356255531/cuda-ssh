docker build -t hanzw/cuda-ssh-python38:10.2 Dockerfile
# prepare gpu support and increase share memory for dataloader
docker run -d --gpus all -it --shm-size=8G -p 52022:22 -p 5000:5000 -v ~/WorkSpace/:/WorkSpace hanzw/cuda-ssh-python38:10.2