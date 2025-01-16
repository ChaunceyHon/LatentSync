#!/bin/bash

# Create a new conda environment
conda create -y -n latentsync python=3.10.13
conda activate latentsync

# Install ffmpeg
conda install -y -c conda-forge ffmpeg

# Python dependencies
pip install -r requirements.txt

# OpenCV dependencies
apt -y install libgl1

# Download all the checkpoints from HuggingFace using the mirror site
export HF_ENDPOINT=https://hf-mirror.com
echo 'export HF_ENDPOINT=https://hf-mirror.com' >> ~/.bashrc
source ~/.bashrc
huggingface-cli download chunyu-li/LatentSync --local-dir checkpoints --exclude "*.git*" "README.md" --repo-type model

# Soft links for the auxiliary models
mkdir -p ~/.cache/torch/hub/checkpoints
ln -sf $(pwd)/checkpoints/auxiliary/2DFAN4-cd938726ad.zip ~/.cache/torch/hub/checkpoints/2DFAN4-cd938726ad.zip
ln -sf $(pwd)/checkpoints/auxiliary/s3fd-619a316812.pth ~/.cache/torch/hub/checkpoints/s3fd-619a316812.pth
ln -sf $(pwd)/checkpoints/auxiliary/vgg16-397923af.pth ~/.cache/torch/hub/checkpoints/vgg16-397923af.pth

#解决公共链接问题：
wget https://cdn-media.hf-mirror.com/frpc-gradio-0.3/frpc_linux_amd64 -O frpc_linux_amd64_v0.3
mv frpc_linux_amd64_v0.3 /root/miniconda3/envs/latentsync/lib/python3.10/site-packages/gradio/
chmod +x /root/miniconda3/envs/latentsync/lib/python3.10/site-packages/gradio/frpc_linux_amd64_v0.3
