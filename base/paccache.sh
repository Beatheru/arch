# Weekly cleanup. Keep two versions: the installed one plus one to downgrade to offline
sudo sed -i -E 's|^PACCACHE_ARGS=.*|PACCACHE_ARGS="-k2"|' /etc/conf.d/pacman-contrib
sudo systemctl enable paccache.timer
