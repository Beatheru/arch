# ---------- Pacman ---------- #

sudo sed -i 's/^#Color$/Color/' /etc/pacman.conf
sudo sed -i 's/^#VerbosePkgLists$/VerbosePkgLists/' /etc/pacman.conf
sudo sed -i 's/^#DownloadUser = alpm$/DownloadUser = alpm/' /etc/pacman.conf
sudo sed -i -E 's/^#?ParallelDownloads = .*/ParallelDownloads = 10/' /etc/pacman.conf
grep -q '^ILoveCandy' /etc/pacman.conf || sudo sed -i '/^Color$/a ILoveCandy' /etc/pacman.conf
sudo sed -i '/^#\[multilib\]/{N;s/^#\[multilib\]\n#Include/[multilib]\nInclude/}' /etc/pacman.conf

# Arch's official geo-routed mirror
GEO_MIRROR='Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch'
if ! grep -qxF "$GEO_MIRROR" /etc/pacman.d/mirrorlist; then
  sudo sed -i "1i $GEO_MIRROR" /etc/pacman.d/mirrorlist
fi

# ---------- Paru ---------- #

sudo cp local.conf /etc/makepkg.conf.d/local.conf

sudo pacman -Syu --noconfirm --needed base-devel

if ! command -v paru &>/dev/null; then
  tmp=$(mktemp -d)
  git clone --depth 1 https://aur.archlinux.org/paru-bin.git "$tmp/paru"
  (cd "$tmp/paru" && makepkg -si --noconfirm)
  rm -rf "$tmp"
fi

sudo sed -i 's/^#BottomUp$/BottomUp/' /etc/paru.conf
sudo sed -i 's/^#SudoLoop$/SudoLoop/' /etc/paru.conf
sudo sed -i 's/^#CleanAfter$/CleanAfter/' /etc/paru.conf
grep -q '^BatchInstall' /etc/paru.conf || sudo sed -i '/^\[options\]$/a BatchInstall' /etc/paru.conf
