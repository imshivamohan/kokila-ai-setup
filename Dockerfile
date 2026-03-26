FROM nvidia/cuda:13.0.0-devel-ubuntu24.04

# ---------- ENV ----------
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata
ENV CUDA_HOME=/usr/local/cuda-13.0
ENV TORCH_CUDA_ARCH_LIST="12.0"
ENV PYTHONNOUSERSITE=1

# 🔥 Cache locations (IMPORTANT)
ENV HF_HOME=/home/kokila/.cache/huggingface
ENV PIP_CACHE_DIR=/home/kokila/.cache/pip

ENV LD_LIBRARY_PATH=/usr/local/cuda-13.0/targets/x86_64-linux/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

# ---------- SYSTEM ----------
RUN apt-get update && apt-get install -y \
    wget git ffmpeg bzip2 build-essential libsndfile1 sudo \
    && rm -rf /var/lib/apt/lists/*

# ---------- USER ----------
RUN useradd -ms /bin/bash kokila && \
    echo "kokila ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ---------- MINIFORGE ----------
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh && \
    bash /tmp/miniforge.sh -b -p /opt/conda && \
    rm /tmp/miniforge.sh

ENV PATH="/opt/conda/bin:$PATH"

# ---------- CONDA ----------
RUN conda init bash && conda create -n kokila python=3.12 -y

# ---------- FIX PERMISSIONS ----------
RUN chown -R kokila:kokila /opt/conda && \
    mkdir -p /home/kokila/.cache/pip && \
    mkdir -p /home/kokila/.cache/huggingface && \
    chown -R kokila:kokila /home/kokila

# ---------- USER ----------
USER kokila
WORKDIR /workspace

# auto activate
RUN echo "source /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate kokila" >> ~/.bashrc

# ---------- USE ENV ----------
SHELL ["conda", "run", "-n", "kokila", "/bin/bash", "-c"]

# ---------- PYTORCH ----------
RUN pip install torch==2.9.1+cu130 torchvision==0.24.1+cu130 torchaudio==2.9.1+cu130 \
    --index-url https://download.pytorch.org/whl/cu130

# ---------- BUILD ----------
RUN pip install --upgrade pip setuptools wheel ninja packaging

# ---------- CUDA 12 RUNTIME ----------
RUN pip install nvidia-cuda-runtime-cu12

# ---------- CORE ----------
RUN pip install \
    numpy==1.26.4 \
    protobuf==5.29.6 \
    transformers==4.57.6 \
    soundfile==0.13.1 \
    librosa==0.11.0 \
    sentencepiece==0.2.1

# ---------- AUDIO ----------
RUN pip install dac descript-audiotools==0.7.2

# ---------- API ----------
RUN pip install \
    fastapi \
    uvicorn[standard] \
    gradio \
    rjieba \
    Unidecode \
    orjson \
    ujson \
    websockets \
    accelerate

# ---------- FLASH ATTENTION ----------
RUN pip install flash-attn --no-build-isolation

# ---------- FINAL LIB FIX ----------
ENV LD_LIBRARY_PATH=/opt/conda/envs/kokila/lib/python3.12/site-packages/nvidia/cuda_runtime/lib:/opt/conda/envs/kokila/lib:/usr/local/cuda-13.0/targets/x86_64-linux/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

# ---------- KEEP ALIVE ----------
CMD ["tail", "-f", "/dev/null"]
