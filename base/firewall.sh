# Allow nothing in, allow everything out
sudo ufw default deny incoming
sudo ufw default allow outgoing

# LocalSend
sudo ufw allow 53317/udp comment 'localsend'
sudo ufw allow 53317/tcp comment 'localsend'

sudo ufw --force enable
sudo systemctl enable ufw

# Docker
sudo ufw-docker install
sudo ufw reload
