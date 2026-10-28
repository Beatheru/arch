run_script() {
  log INFO "Running ${1#"$INSTALL_HOME/"}"
  (cd "$(dirname "$1")" && bash -euo pipefail "$@")
}

export -f run_script
