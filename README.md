# ezboard-gpu

Image mesin GPU (RunPod) untuk render film ezboard: Chrome, Node 22, ffmpeg, three.js 0.149.0, Blender 4.0.2 di atas
`runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04`. Dibangun otomatis oleh GitHub Actions setiap push ke `main`
(atau Actions → bangun-image → Run workflow) ke `ghcr.io/masyogis/ezboard-gpu:<image>` dan `:latest`.

Sumber aslinya ada di repo ezboard (`backend/robot/gpu/image/`); `alat-versi.txt` harus sama dengan `backend/robot/gpu/alat-versi.txt`.
