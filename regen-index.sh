#!/usr/bin/env bash
# Regenerates index.html from the HTML files in this directory.
# Run before commit when adding or removing a livedoc.

set -euo pipefail
cd "$(dirname "$0")"

# Find all .html files except index.html
shopt -s nullglob
files=()
for f in *.html; do
  [[ "$f" == "index.html" ]] && continue
  files+=("$f")
done

extract() {
  # Usage: extract <attr> <file>
  # Pulls a data-* attribute value from the <html> tag.
  grep -oE "data-livedoc-$1=\"[^\"]+\"" "$2" 2>/dev/null \
    | head -1 \
    | sed -E "s/data-livedoc-$1=\"([^\"]+)\"/\1/"
}

# Sort files by data-livedoc-created (newest first), falling back to filename
declare -a sorted
if [[ ${#files[@]} -gt 0 ]]; then
  IFS=$'\n' sorted=($(
    for f in "${files[@]}"; do
      created=$(extract created "$f")
      echo "${created:-0000-00-00}|$f"
    done | sort -r | cut -d'|' -f2
  ))
  unset IFS
fi

# Build index.html
{
cat <<'HEAD'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>jbwashington · livedocs</title>
  <style>
    :root {
      --bg:#FAF9F5; --surface:#F0EEE6; --card:#FFFFFF; --text:#141413;
      --text-muted:#87867F; --border:1.5px solid #D1CFC5;
      --accent:#5C7CA3; --olive:#788C5D; --clay:#D97757; --oat:#E3DACC;
      --serif:ui-serif,Georgia,serif; --sans:system-ui,-apple-system,sans-serif; --mono:ui-monospace,'SF Mono',Menlo,monospace;
    }
    @media (prefers-color-scheme: dark) {
      :root { --bg:#0f0f14; --surface:#1a1a2e; --card:#16213e; --text:#e0e0e0;
              --text-muted:#9ca3af; --border:1.5px solid #2a2a3e;
              --accent:#7c83ff; --olive:#34d399; --clay:#f59e0b; --oat:#1e2040; }
    }
    * { box-sizing:border-box; }
    body { font-family:var(--sans); background:var(--bg); color:var(--text);
           max-width:780px; margin:0 auto; padding:2rem 1.25rem; line-height:1.6; }
    h1 { font-family:var(--serif); font-size:1.75rem; margin:0 0 0.25rem; }
    p { color:var(--text-muted); margin:0 0 2rem; }
    .label { font-family:var(--mono); font-size:0.7rem; text-transform:uppercase;
             letter-spacing:0.06em; color:var(--text-muted); }
    ul { list-style:none; padding:0; margin:0; }
    li { padding:0.85rem 0; border-bottom:1px solid rgba(127,127,127,.18);
         display:flex; flex-wrap:wrap; align-items:baseline; gap:0.6rem; }
    li a { color:var(--text); text-decoration:none; font-weight:600; flex:1; min-width:60%; }
    li a:hover { color:var(--accent); }
    .meta { font-family:var(--mono); font-size:0.75rem; color:var(--text-muted); }
    .grammar { background:rgba(92,124,163,.18); color:var(--accent);
               padding:0.15em 0.55em; border-radius:999px; }
    footer { margin-top:3rem; font-size:0.85rem; color:var(--text-muted); }
    footer a { color:var(--accent); }
  </style>
</head>
<body>
  <header>
    <p class="label">jbwashington · livedocs</p>
    <h1>Livedocs</h1>
    <p>Self-describing HTML artifacts. Open any one to read, edit, or download.</p>
  </header>
  <ul>
HEAD

if [[ ${#sorted[@]} -gt 0 ]]; then
  for f in "${sorted[@]}"; do
    name=$(extract name "$f")
    grammar=$(extract grammar "$f")
    created=$(extract created "$f")
    : "${name:=$f}"
    : "${grammar:=unknown}"
    : "${created:=}"
    printf '    <li><a href="%s">%s</a> <span class="grammar">%s</span> <span class="meta">%s</span></li>\n' \
      "$f" "$name" "$grammar" "$created"
  done
else
  echo '    <li class="meta">No livedocs yet.</li>'
fi

cat <<'FOOT'
  </ul>
  <footer>
    Repo: <a href="https://github.com/jbwashington/livedocs">github.com/jbwashington/livedocs</a> ·
    Pattern: <a href="https://github.com/jbwashington/.claude">living-doc skill</a>
  </footer>
</body>
</html>
FOOT
} > index.html

echo "Wrote index.html with ${#sorted[@]} livedoc(s)"
