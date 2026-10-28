# niri otherwise holds on to ~1GiB of VRAM on NVIDIA. See https://yalter.github.io/niri/Nvidia
has_nvidia || exit 0

sudo mkdir -p /etc/nvidia/nvidia-application-profiles-rc.d
sudo cp niri.json /etc/nvidia/nvidia-application-profiles-rc.d/niri.json
