FROM --platform=linux/amd64 nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV CUDA_HOME="/usr/local/cuda"

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    git \
    python-dev-is-python3

RUN pip3 install --no-cache-dir --upgrade pip

# build required dependencies for flash attention wheel 
RUN pip3 install --no-cache-dir \
    torch \
    torchaudio \
    torchvision \
    --index-url https://download.pytorch.org/whl/cu118
    
RUN pip3 install packaging \
    einops \
    setuptools \
    ninja

RUN python3 -m pip install build

# copy all current files in this directory (flash attention) to the home directory of container 
COPY . ./

# Build wheel 
RUN python3 setup.py bdist_wheel
