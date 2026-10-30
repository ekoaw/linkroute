#!/bin/sh
# Checks which profile linkroute picks, using a fake browser that prints its args.
set -u
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
mkdir -p "$dir/linkroute" "$dir/bin"
printf '#!/bin/sh\necho "$@"\n' > "$dir/bin/fakebrave"
chmod +x "$dir/bin/fakebrave"
cat > "$dir/linkroute/config" <<CONF
browser=fakebrave
work_data_dir=/work
work_class=work
CONF
printf '# comment\n\nexample.com\n10.0.0.\n' > "$dir/linkroute/work-domains"

fail=0
check() {
  out=$(PATH="$dir/bin:$PATH" XDG_CONFIG_HOME="$dir" ./linkroute "$1")
  case "$out" in --user-data-dir=/work*) got=work ;; *) got=default ;; esac
  if [ "$got" = "$2" ]; then echo "ok   $1 -> $got"; else echo "FAIL $1 -> $got, want $2"; fail=1; fi
}

check 'https://example.com/a' work
check 'https://git.example.com' work
check 'https://user@GIT.Example.COM:8443/x' work
check 'http://10.0.0.5:3000' work
check 'https://notexample.com' default
check 'https://example.com.evil.net' default
check 'https://search.test/?q=example.com' default
check 'http://10.0.1.5' default
check '/home/user/page.html' default
check '' default
exit $fail
