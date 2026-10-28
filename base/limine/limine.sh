# ---------- Plymouth ---------- #

sudo cp 10-base.conf /etc/dracut.conf.d/10-base.conf

sudo cp -r plymouth/arch-mac-style /usr/share/plymouth/themes/
sudo plymouth-set-default-theme arch-mac-style

# Don't let a hung plymouthd block the greeter
sudo install -Dm644 plymouth/quit-timeout.conf /etc/systemd/system/plymouth-quit.service.d/quit-timeout.conf

# ---------- Snapper ---------- #

if ! sudo snapper list-configs 2>/dev/null | grep -q '^root '; then
  sudo snapper -c root create-config /
fi

sudo snapper -c root set-config \
  NUMBER_MIN_AGE=0 \
  NUMBER_LIMIT=10 \
  NUMBER_LIMIT_IMPORTANT=10

sudo systemctl enable snapper-cleanup.timer

# ---------- Limine ---------- #

ESP=$(bootctl --print-esp-path)

# Add quiet splash to kernel params
if ! grep -qw splash /etc/kernel/cmdline; then
  sudo sed -i 's/$/ quiet splash/' /etc/kernel/cmdline
fi

sudo cp default.conf /etc/default/limine

sudo limine-update

if ! sudo sh -c "ls '$ESP'/EFI/Linux/*.efi" &>/dev/null; then
  log ERROR "limine-update did not produce any UKI in $ESP/EFI/Linux, leaving the old boot entries in place"
  exit 1
fi

# Theme
if ! sudo grep -q '^term_background:' "$ESP/limine.conf"; then
  sudo sed -i "1e cat '$PWD/theme.conf'" "$ESP/limine.conf"
fi

# Snapshots in the boot menu
sudo systemctl enable limine-snapper-sync

# Remove archinstall's Limine boot entries and files
for bootnum in $(efibootmgr | sed -n 's/^Boot\([0-9A-F]\{4\}\)\*\? Arch Linux Limine.*/\1/p'); do
  sudo efibootmgr -b "$bootnum" -B >/dev/null
done
sudo rm -rf "$ESP/EFI/arch-limine" "$ESP/limine"

# Limine reads a limine.conf next to its own EFI binary (or in these other
# places) before $ESP/limine.conf. archinstall leaves one in EFI/BOOT/, so the
# fallback BOOTX64.EFI keeps booting archinstall's old menu and UKI.
sudo rm -f \
  "$ESP/EFI/BOOT/limine.conf" \
  "$ESP/EFI/limine/limine.conf" \
  "$ESP/boot/limine/limine.conf" \
  "$ESP/boot/limine.conf"
# archinstall's mkinitcpio UKIs (ours are arch_*.efi)
sudo rm -f "$ESP"/EFI/Linux/arch-linux*.efi

# The fallback BOOTX64.EFI is Limine itself (ENABLE_LIMINE_FALLBACK), so a menu
# entry for it only loops back to this menu. Keep the file, drop the entry.
sudo limine-entry-tool --remove-efi-path "$ESP/EFI/BOOT/BOOTX64.EFI" --keep-files --quiet || true

# dracut replaces mkinitcpio
if pacman -Qq mkinitcpio &>/dev/null; then
  sudo pacman -Rns --noconfirm mkinitcpio
fi
