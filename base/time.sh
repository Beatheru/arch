# Windows keeps the hardware clock in local time; match it when dual booting
if efibootmgr | grep -q 'Windows Boot Manager'; then
  log INFO "Windows detected, using local time for the hardware clock"
  sudo timedatectl set-local-rtc 1
fi
