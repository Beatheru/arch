packages=()
services=()
for module in base "$@"; do
  mapfile -t -O "${#packages[@]}" packages < <(sed 's/#.*//' "$INSTALL_HOME/$module/packages.list" | xargs -n1)
done

# ---------- Hardware ---------- #

cpu_model=$(grep -m1 '^model\s' /proc/cpuinfo | awk '{print $3}')

if has_intel_cpu; then
  packages+=(intel-ucode)
  if is_laptop; then
    packages+=(thermald)
    services+=(thermald)
    # Low Power Mode Daemon for hybrid (P/E core) CPUs:
    # Alder Lake, Raptor Lake, Meteor Lake, Lunar Lake, Panther Lake
    if [[ $cpu_model =~ ^(151|154|170|172|183|186|189|191|204)$ ]]; then
      packages+=(intel-lpmd)
      services+=(intel_lpmd)
    fi
  fi
fi

# Intel audio DSPs need Sound Open Firmware, otherwise PipeWire only shows "Dummy Output"
if lspci | grep -qiE '(multimedia audio controller|audio device).*intel'; then
  packages+=(sof-firmware)
fi

if has_intel_gpu; then
  # Vulkan, VA-API video decode (Broadwell+), Quick Sync (Tiger Lake+)
  packages+=(vulkan-intel intel-media-driver vpl-gpu-rt)
fi

if has_nvidia; then
  # Open kernel modules (Turing and newer), built by DKMS for every installed kernel
  for kernel in $(pacman -Qq linux linux-lts linux-zen linux-hardened 2>/dev/null || true); do
    packages+=("${kernel}-headers")
  done
  packages+=(nvidia-open-dkms)
  # Hybrid graphics: prime-run offloads apps to the NVIDIA GPU
  if has_intel_gpu; then
    packages+=(nvidia-prime)
    # Dynamic Boost on laptops (Ampere and newer, no-op elsewhere)
    if is_laptop; then
      services+=(nvidia-powerd)
    fi
  fi
fi

# ---------- Install ---------- #

log INFO "Installing ${#packages[@]} packages"
paru -S --noconfirm --needed --skipreview "${packages[@]}"

if ((${#services[@]})); then
  sudo systemctl enable "${services[@]}"
fi
