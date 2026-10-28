has_intel_cpu() {
  grep -q '^vendor_id.*GenuineIntel' /proc/cpuinfo
}

# Intel graphics, normally the CPU's integrated GPU (or an Intel Arc card)
has_intel_gpu() {
  lspci | grep -iE 'vga|3d|display' | grep -qi 'intel'
}

has_nvidia() {
  lspci | grep -iE 'vga|3d|display' | grep -qi 'nvidia'
}

is_laptop() {
  [[ $(hostnamectl chassis 2>/dev/null) =~ ^(laptop|convertible|tablet)$ ]]
}

export -f has_intel_cpu has_intel_gpu has_nvidia is_laptop
