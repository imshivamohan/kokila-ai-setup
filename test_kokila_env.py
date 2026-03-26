import importlib

import torch
torch.set_float32_matmul_precision('high')
print("🚀 KOKILA ENV VALIDATION\n")

# ------------------------
# CORE CHECK
# ------------------------
try:
    print("🐍 Python OK")
    print("🔥 Torch:", torch.__version__)
    print("⚡ CUDA:", torch.version.cuda)
    print("🧠 GPU:", torch.cuda.get_device_name(0))
    print("🎯 Capability:", torch.cuda.get_device_capability(0))
except Exception as e:
    print("❌ Torch/GPU ERROR:", e)

# ------------------------
# PACKAGE CHECK FUNCTION
# ------------------------
def check(pkg):
    try:
        module = importlib.import_module(pkg)
        version = getattr(module, "__version__", "unknown")
        print(f"✅ {pkg}: {version}")
    except Exception as e:
        print(f"❌ {pkg}: {e}")

print("\n📦 Checking core libraries...\n")

core_packages = [
    "numpy",
    "google.protobuf",
    "transformers",
    "torchaudio",
    "soundfile",
    "librosa"
]

for pkg in core_packages:
    check(pkg)

print("\n🎵 Checking audio stack...\n")

audio_packages = [
    "audiotools",
    "dac",
    "parler_tts"
]

for pkg in audio_packages:
    check(pkg)

print("\n🧠 Checking TTS models...\n")

tts_packages = [
    "sentencepiece",
    "rjieba",
    "unidecode"
]

for pkg in tts_packages:
    check(pkg)

print("\n🌐 Checking API stack...\n")

api_packages = [
    "fastapi",
    "uvicorn",
    "gradio"
]

for pkg in api_packages:
    check(pkg)

print("\n⚡ Checking performance features...\n")

# Flash Attention
try:
    import flash_attn
    print("⚡ Flash Attention: INSTALLED")
except:
    print("⚠️ Flash Attention: NOT INSTALLED")

# Triton
try:
    import triton
    print("⚡ Triton:", triton.__version__)
except:
    print("❌ Triton missing")

# ------------------------
# MINI INFERENCE TEST
# ------------------------
print("\n🧪 Running mini GPU test...\n")

try:
    model = torch.nn.Linear(512, 512).to("cuda")
    model = torch.compile(model)
    x = torch.randn(1, 512).to("cuda")

    with torch.inference_mode():
        y = model(x)

    print("✅ GPU inference test PASSED")
except Exception as e:
    print("❌ GPU inference FAILED:", e)

print("\n🎯 VALIDATION COMPLETE")
