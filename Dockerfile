# Image mesin GPU ezboard (owner, 20 Nov 2026): semua alat render sudah terpasang, jadi mesin RunPod baru langsung
# merender tanpa mengunduh dari server Ubuntu / Google / Node / blender.org (19 Nov 2026 siang: semua render gagal karena
# pemasangan alat lewat 8 menit). Dasarnya image RunPod yang sama dengan sebelumnya (biasanya sudah ada di mesin RunPod,
# jadi hanya lapisan alat ini yang diunduh); start.sh RunPod (SSH dengan PUBLIC_KEY) tetap dipakai, CMD tidak diubah.
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

# paket Ubuntu: ffmpeg, rsync, komponen grafis EGL/GL untuk Chrome dan Blender tanpa layar
RUN mkdir -p /root/apt-luar && find /etc/apt/sources.list.d -maxdepth 1 \( -name '*.list' -o -name '*.sources' \) -exec mv -t /root/apt-luar {} + ; \
    apt-get update -qq -o Acquire::Languages=none \
 && apt-get install -y -qq --no-install-recommends wget curl gnupg ca-certificates xz-utils ffmpeg rsync \
      libegl1 libgl1 libgles2 libglvnd0 libxrender1 libxi6 libxkbcommon0 libsm6 libxxf86vm1 libxfixes3 libx11-6 libxext6 xvfb \
 && wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && apt-get install -y -qq /tmp/chrome.deb \
 && rm -f /tmp/chrome.deb && apt-get clean && rm -rf /var/lib/apt/lists/*

# Node 22 (rekam.mjs)
RUN wget -q -O /tmp/node.tar.xz https://nodejs.org/dist/v22.11.0/node-v22.11.0-linux-x64.tar.xz \
 && tar -xJf /tmp/node.tar.xz -C /opt && ln -sf /opt/node-v22.11.0-linux-x64/bin/node /usr/local/bin/node && rm -f /tmp/node.tar.xz

# three.js 0.149.0 (disalin ke /workspace/web3d saat render; /workspace bisa jadi volume, jadi disimpan di /opt/ezb)
RUN B=https://cdn.jsdelivr.net/npm/three@0.149.0 && for f in build/three.module.js examples/jsm/loaders/GLTFLoader.js \
      examples/jsm/utils/BufferGeometryUtils.js examples/jsm/controls/OrbitControls.js examples/jsm/environments/RoomEnvironment.js; do \
      mkdir -p "/opt/ezb/three/$(dirname $f)" && wget -q -O "/opt/ezb/three/$f" "$B/$f" || exit 1; done

# Blender 4.0.2 (sama dengan server), dicek SHA256 resmi blender.org
RUN F=blender-4.0.2-linux-x64.tar.xz \
 && wget -q -O /tmp/$F https://download.blender.org/release/Blender4.0/$F \
 && echo "5583a5588736da8858c522ef17fff5d73be59c47a6fe91ad29c6f3263e22086a  /tmp/$F" | sha256sum -c --quiet \
 && tar -xJf /tmp/$F -C /opt && mv /opt/blender-4.0.2-linux-x64 /opt/blender && rm -f /tmp/$F

# tanda versi alat: setup-render.sh / setup-blender.sh membandingkannya dengan alat-versi.txt yang dikirim bersama tugas
COPY alat-versi.txt /opt/ezb/alat-versi.txt
RUN node --version && google-chrome --version && ffmpeg -version | head -1 && /opt/blender/blender --version | head -1
