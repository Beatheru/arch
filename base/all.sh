for entry in "$INSTALL_HOME"/base/*; do
  name=$(basename "$entry" .sh)
  if [[ -d $entry ]]; then
    script="$entry/$name.sh"
    [[ -f $script ]] || { log ERROR "base/$name/ has no $name.sh"; exit 1; }
    run_script "$script"
  elif [[ $entry == *.sh && $name != all ]]; then
    run_script "$entry"
  fi
done