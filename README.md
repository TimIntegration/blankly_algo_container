# Blankly Strategy Dockerized Jupyter Lab

A development environment for blankly algorithmic trading bots

You need docker! Check out https://docs.docker.com/get-docker/ on information on how to install docker for your system.


## for jupyterlab using docker compose, __**recommended**__
run the following commands:
```
git clone https://github.com/TimIntegration/dockerized-ds-env.git projName
cd projName
make compose
cd /host_folder/notebooks
blankly init
python golden_cross_bot.py
```
jupyter lab can be accessed via http://localhost:8899


## for vscode
run the following commands:
```
git clone https://github.com/TimIntegration/dockerized-ds-env.git projName
cd projName
code .
```
Inside Visual Studio Code:
 - click button on the bottom right to reopen folder in Dev Container


## for standalone container
Step - 1: Build the container, first time only
```
make setup
```

Step - 2: Start the coding environment or jupyter lab
```
make run
```


### Optional
If you have NVIDIA drivers installed, you need the NVIDIA runtime to use GPUs in the development environment.
Run the following commands if you are on Ubuntu to set up the NVIDIA runtimes.

```
# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

For more information about the NVIDIA docker runtime, take a look here: https://github.com/NVIDIA/nvidia-docker
