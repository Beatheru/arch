# Nothing in the desktop needs to wait for DHCP/Wi-Fi before the greeter shows
sudo systemctl mask NetworkManager-wait-online.service
