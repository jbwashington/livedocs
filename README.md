# livedocs

Public livedocs by [jbwashington](https://github.com/jbwashington). Each file is a single self-contained HTML document with embedded DSL source and grammar — open any one to read, edit, or download.

**Index:** [https://jbwashington.github.io/livedocs/](https://jbwashington.github.io/livedocs/)

## What is a livedoc?

A livedoc is a durable, self-describing HTML artifact:

- **Single file**, zero external dependencies
- **Embedded grammar** — each livedoc carries the spec for its own DSL inside `<pre id="livedoc-grammar">`
- **Embedded source** — the content lives in a `<textarea id="livedoc-source">` that's editable in-browser
- **Live re-render** — type in the textarea, the rendered view updates instantly
- **Copy markdown** — a button generates a 4-section bundle (title · rendered · source · grammar) for pasting into chat with another LLM
- **Download .html** — a button serializes the current textarea state into a fresh self-contained file

The pattern is documented in the [`living-doc` Claude Code skill](https://github.com/jbwashington/.claude) at `~/.claude/skills/living-doc/SKILL.md`.

## Publishing flow

1. Author livedocs locally at `~/Documents/livedocs/personal/`
2. Copy the file into this repo's root directory
3. Run `./regen-index.sh` to refresh `index.html`
4. Commit and push — GitHub Pages serves the file at `https://jbwashington.github.io/livedocs/{filename}`

Work livedocs stay in `~/Documents/livedocs/work/` and are never pushed here.

## Editing & sharing

Anyone with the URL can:

- Read the rendered view
- Edit the source in the textarea (changes stay client-side in their browser tab)
- Click **Download .html** to walk away with their edits baked into a fresh file
- Click **Copy markdown** to grab the current state as a paste-able bundle

To send changes back to the author: download a snapshot, attach via email/iMessage.
