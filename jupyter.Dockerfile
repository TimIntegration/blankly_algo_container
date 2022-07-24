FROM jupyter/tensorflow-notebook
# FROM nvidia/cuda:10.2-cudnn7-runtime-ubuntu18.04

LABEL Creator: "Tim" \ 
    Version: "1.0"

ENV DEBIAN_FRONTEND noninteractive

USER root
RUN apt-get update --fix-missing
RUN apt-get install -y \
    net-tools iputils-ping \
    build-essential git \
    curl wget \
    gcc vim \
    libjpeg-dev libpng-dev \
    libtiff-dev libgtk2.0-dev \
    locales zsh \
    imagemagick ffmpeg \
    zip unzip p7zip-full p7zip-rar \
    libomp5 \
    libglu1-mesa-dev libgl1-mesa-dev libosmesa6-dev \
    xvfb patchelf ffmpeg cmake swig \
    libopenmpi-dev python3-dev zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ENV ZSH_THEME amuse
RUN locale-gen en_US.UTF-8
RUN /bin/sh -c chsh -s /bin/zsh

ENV SHELL /bin/zsh
ENV LANG=en_US.UTF-8

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

COPY ./common-debian.sh /tmp/library-scripts/
RUN apt-get update \
    && groupadd ${NB_USER} \
    && usermod -g ${NB_USER} -a -G users ${NB_USER} \
    && bash /tmp/library-scripts/common-debian.sh \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN chown -hR ${NB_UID}:${NB_GID} "/home/${NB_USER}/"

USER ${NB_USER}
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/
RUN pip install --quiet --no-cache-dir -r /tmp/requirements.txt

# https://jupyterlab-code-snippets-documentation.readthedocs.io/en/latest/index.html
RUN jupyter labextension install jupyterlab-code-snippets
RUN jupyter lab clean
RUN jupyter lab build

# NB_USER set in docker-compose.yml
RUN mkdir -p "/home/${NB_USER}/work"

ENV PATH "$PATH:/home/${NB_USER}/.local/bin"

# Jupyter and Tensorboard ports
EXPOSE 8888 6006 9082


# venv ml specifics
# RUN conda create -y -n ml python=3.9
# RUN /bin/zsh -c "source activate ml && pip install --user ipykernel"
# RUN /bin/zsh -c "source activate ml && python -m ipykernel install --user --name=ml"
# RUN /opt/conda/bin/conda install -yc conda-forge --file /tmp/cforge_req.txt -n ml
# RUN /bin/zsh -c "conda install --file /tmp/conda_req.txt -n ml"
# COPY --chown=${NB_UID}:${NB_GID} tensorflow_req.txt /tmp/
# RUN /bin/zsh -c 'source activate ml && pip install --no-cache-dir -r /tmp/tensorflow_req.txt && \
#     fix-permissions "${CONDA_DIR}" && \
#     fix-permissions "/home/${NB_USER}"'
