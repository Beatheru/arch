# Don't wait 90s for hung services on shutdown
sudo mkdir -p /etc/systemd/system.conf.d
sudo cp timeout.conf /etc/systemd/system.conf.d/timeout.conf
sudo mkdir -p /etc/systemd/user.conf.d
sudo cp timeout.conf /etc/systemd/user.conf.d/timeout.conf
