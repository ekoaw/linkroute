# linkroute

Open work links in your work Brave profile and everything else in your
personal one, wherever you click them (chat, mail, terminal, file manager).

linkroute registers itself as the default browser. For each link it checks the
host against a list of work domains, then starts Brave with the matching
profile.

Brave only for now. Tested on KDE Plasma (Wayland); it uses only the
freedesktop default-browser mechanism, so other desktops should work too.

## Why a separate user-data-dir

All profiles inside one Brave user-data-dir share one process and one window
class, so the taskbar groups them under a single icon. linkroute runs the work
profile as its own Brave instance (`--user-data-dir` plus `--class`), which
gives it its own taskbar entry and lets you pin it separately.

To move an existing profile there, quit Brave and copy it, for example
`Profile 1`:

```sh
src=~/.config/BraveSoftware/Brave-Browser
dst=~/.config/BraveSoftware/Brave-Browser-Work
mkdir -p "$dst"
cp -a "$src/Profile 1" "$dst/Default"
cp -a "$src/Local State" "$dst/Local State"   # holds the cookie/password key
```

The copied `Local State` still lists the other profiles; delete them from the
work instance's profile menu if they show up.

## Install

```sh
./install.sh
```

This puts `linkroute` in `~/.local/bin`, adds a hidden `linkroute.desktop`,
creates `~/.config/linkroute/config` and `~/.config/linkroute/work-domains`
from the examples (existing files are kept), and sets linkroute as the default
browser.

Then edit both files:

- `config`: the Brave command (`brave`, `brave-origin`, ...), the work
  user-data-dir, and the work window class.
- `work-domains`: one host per line. `example.com` also matches its
  subdomains; a line ending in `.` is a prefix, for IP ranges (`10.0.0.`).
  Changes apply on the next click.

## Work launcher

To start the work profile from the menu or taskbar, add a launcher such as
`~/.local/share/applications/brave-work.desktop`:

```ini
[Desktop Entry]
Type=Application
Name=Brave (Work)
Exec=brave --user-data-dir=/home/you/.config/BraveSoftware/Brave-Browser-Work --class=brave-work %U
Icon=brave-browser
StartupWMClass=brave-work
Actions=edit-domains;

[Desktop Action edit-domains]
Name=Edit work domains
Exec=xdg-open /home/you/.config/linkroute/work-domains
```

`StartupWMClass` must equal `work_class` in the config. Right-click the pinned
icon and choose "Edit work domains" to change the list.

## Limits

- Links clicked inside Brave stay in that window; linkroute only sees links
  opened from other apps.
- If Brave asks to become the default browser and you accept, it replaces
  linkroute. Run `./install.sh` again to restore it.

## Uninstall

```sh
xdg-settings set default-web-browser brave-browser.desktop
rm ~/.local/bin/linkroute ~/.local/share/applications/linkroute.desktop
```

## Test

```sh
./test.sh
```
