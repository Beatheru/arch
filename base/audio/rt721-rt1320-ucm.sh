# Speakers silent on Realtek RT721 + RT1320 SoundWire laptops (e.g. Razer Blade 16 RZ09-0581).
# alsa-ucm-conf 1.2.16.x includes codecs/rt721+rt1320/init.conf, which it doesn't ship, so the
# whole UCM config fails and PipeWire falls back to a stereo profile that never enables the amp.
# rt721 init already comes via the headset codec and rt1320 via sof-soundwire/rt721+rt1320.conf,
# so an empty file is enough. Upstream fixed it in alsa-ucm-conf ba372ade3434 (issue #851); that
# fix drops sof-soundwire/rt721+rt1320.conf, so delete once it no longer exists.

ucm=/usr/share/alsa/ucm2
file="$ucm/codecs/rt721+rt1320/init.conf"

# Both codecs must be on the SoundWire bus (Realtek mfg id 025d)
compgen -G '/sys/bus/soundwire/devices/sdw:*:025d:0721:*' >/dev/null || exit 0
compgen -G '/sys/bus/soundwire/devices/sdw:*:025d:1320:*' >/dev/null || exit 0

if [[ ! -f "$ucm/sof-soundwire/rt721+rt1320.conf" ]]; then
  log INFO "alsa-ucm-conf no longer needs the rt721+rt1320 workaround"
  if [[ -f "$file" ]]; then
    log INFO "Removing leftover $file"
    sudo rm -r "$(dirname "$file")"
  fi
  exit 0
fi

[[ -f "$file" ]] && exit 0

log INFO "Adding missing UCM file for RT721 + RT1320 speakers"
sudo install -Dm644 /dev/null "$file"

# Reload audio if a user session is already running
if systemctl --user is-active --quiet wireplumber 2>/dev/null; then
  systemctl --user restart wireplumber pipewire pipewire-pulse
fi
