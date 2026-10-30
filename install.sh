#!/bin/sh
# Installs linkroute for the current user and makes it the default browser.
set -eu
cd "$(dirname "$0")"

bin="$HOME/.local/bin"
apps="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
conf="${XDG_CONFIG_HOME:-$HOME/.config}/linkroute"

mkdir -p "$bin" "$apps" "$conf"
install -m 755 linkroute "$bin/linkroute"
# Desktop sessions may not have ~/.local/bin on PATH.
sed "s#^Exec=linkroute#Exec=$bin/linkroute#" linkroute.desktop > "$apps/linkroute.desktop"
[ -e "$conf/config" ] || cp config.example "$conf/config"
[ -e "$conf/work-domains" ] || cp work-domains.example "$conf/work-domains"

command -v kbuildsycoca6 >/dev/null && kbuildsycoca6 >/dev/null 2>&1 || true
xdg-settings set default-web-browser linkroute.desktop
for m in x-scheme-handler/http x-scheme-handler/https text/html; do
  xdg-mime default linkroute.desktop "$m"
done
echo "Installed. Edit $conf/config and $conf/work-domains."
