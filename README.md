# 🚀 Kokila AI TTS Container (CUDA 13 + RTX 5090 Ready)

A production-ready Docker container for high-performance AI audio workloads, optimized for:

* 🎤 Text-to-Speech (TTS)
* ⚡ Flash Attention acceleration
* 🧠 Transformers models
* 🚀 FastAPI deployment

---

## 🔥 Features

* ✅ CUDA 13 + RTX 5090 support
* ✅ PyTorch 2.9.1 (cu130)
* ✅ Flash Attention enabled
* ✅ DAC + Audio processing stack
* ✅ HuggingFace model caching
* ✅ Non-root secure environment
* ✅ Ready for API deployment

---

## 📦 Docker Image

```bash
docker pull YOUR_USERNAME/kokila:latest
```

---

## 🚀 Run Container

```bash
docker run -it --gpus all \
  -p 8000:8000 \
  -v $(pwd):/workspace \
  -v hf_cache:/home/kokila/.cache/huggingface \
  YOUR_USERNAME/kokila:latest
```

---

## 🧪 Verify Setup

```bash
python -c "import torch; print(torch.cuda.get_device_name())"

python -c "import flash_attn; print('FLASH OK')"

python -c "import audiotools; print('AUDIO OK')"
```

---

## ⚡ Run FastAPI Server

```bash
uvicorn app:app --host 0.0.0.0 --port 8000
```

Then open:

👉 http://localhost:8000/docs

---

## 🎤 Example: Load Model

```python
from transformers import AutoModel

model = AutoModel.from_pretrained("bert-base-uncased")
```

---

## 💾 Persistent Caching

This container uses:

```bash
/home/kokila/.cache/huggingface
```

Mount it for faster startup:

```bash
-v hf_cache:/home/kokila/.cache/huggingface
```

---

## 🧠 Performance Tip

Enable Tensor Core acceleration:

```python
import torch
torch.set_float32_matmul_precision('high')
```

---

## 🛠️ Tech Stack

* PyTorch + CUDA 13
* Flash Attention
* Transformers
* FastAPI + Uvicorn
* DAC + AudioTools

---

## ⚠️ Notes

* Requires NVIDIA GPU (RTX 30/40/50 series recommended)
* Requires Docker with GPU support (`--gpus all`)
* Optimized for Linux environments

---

## 👨‍💻 Author

Built by **sivamohan / OOHA DIGITALS**

---

## ⭐ Support

If you find this useful:

👉 Star the repo
👉 Share with others
👉 Contribute improvements

---

## 🚀 Future Improvements

* Real-time streaming TTS
* WebSocket audio streaming
* Multi-user GPU batching
* Kubernetes deployment

---

🔥 Ready for production AI audio workloads.
