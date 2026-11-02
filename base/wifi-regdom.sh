REGDOM_FILE=/etc/conf.d/wireless-regdom

timezone=$(timedatectl show -P Timezone)

# zone.tab maps canonical zones to countries
country=$(awk -v z="$timezone" '$3 == z {print $1; exit}' /usr/share/zoneinfo/zone.tab)

# Aliases such as US/Eastern aren't in zone.tab: resolve them to the canonical zone
if [[ -z $country ]]; then
  canonical=$(awk -v z="$timezone" '$1 == "L" && $3 == z {print $2; exit}' /usr/share/zoneinfo/tzdata.zi)
  country=$(awk -v z="$canonical" '$3 == z {print $1; exit}' /usr/share/zoneinfo/zone.tab)
fi

if [[ ! $country =~ ^[A-Z]{2}$ ]]; then
  log WARN "No country for timezone '$timezone', leaving the wireless regulatory domain unset"
  exit 0
fi

sudo sed -i '/^WIRELESS_REGDOM=/d' "$REGDOM_FILE"
echo "WIRELESS_REGDOM=\"$country\"" | sudo tee -a "$REGDOM_FILE" >/dev/null
log INFO "Wireless regulatory domain: $country"
