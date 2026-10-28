sudo cp config.toml /etc/greetd/config.toml
sudo systemctl enable greetd
sudo noctalia-greeter-apply-appearance --setup-system

# Unlock gnome-keyring with the password typed into the greeter
if ! grep -q pam_gnome_keyring /etc/pam.d/greetd; then
  printf '%s\n' \
    'auth       optional     pam_gnome_keyring.so' \
    'session    optional     pam_gnome_keyring.so auto_start' |
    sudo tee -a /etc/pam.d/greetd >/dev/null
fi
