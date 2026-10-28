# System
run_script "$INSTALL_HOME/base/paccache.sh"
run_script "$INSTALL_HOME/base/shutdown-timeout/shutdown-timeout.sh"
run_script "$INSTALL_HOME/base/time.sh"

# Boot: Plymouth, snapper, Limine
run_script "$INSTALL_HOME/base/limine/limine.sh"

# Network and services
run_script "$INSTALL_HOME/base/network.sh"
run_script "$INSTALL_HOME/base/bluetooth.sh"
run_script "$INSTALL_HOME/base/firewall.sh"
run_script "$INSTALL_HOME/base/docker.sh"

# Login
run_script "$INSTALL_HOME/base/greeter/greeter.sh"

# Shell
run_script "$INSTALL_HOME/base/fish/fish.sh"
run_script "$INSTALL_HOME/base/fastfetch/fastfetch.sh"
run_script "$INSTALL_HOME/base/nvim.sh"

# Desktop
run_script "$INSTALL_HOME/base/user-dirs.sh"
run_script "$INSTALL_HOME/base/gtk.sh"
run_script "$INSTALL_HOME/base/mimeapps/mimeapps.sh"
run_script "$INSTALL_HOME/base/ghostty/ghostty.sh"
run_script "$INSTALL_HOME/base/wallpaper/wallpaper.sh"
