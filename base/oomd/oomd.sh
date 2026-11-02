sudo install -Dm644 slice.conf /etc/systemd/system/system.slice.d/10-oomd.conf
sudo install -Dm644 slice.conf /etc/systemd/user/slice.d/10-oomd.conf
sudo install -Dm644 session-slice.conf /etc/systemd/user/session.slice.d/10-oomd.conf

sudo systemctl enable systemd-oomd.service
