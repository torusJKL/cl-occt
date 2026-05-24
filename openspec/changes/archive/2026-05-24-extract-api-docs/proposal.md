## Why

The README.md has grown to 1247 lines, with 1000+ lines dedicated to API reference tables (function signatures, descriptions, code examples). This content duplicates what Staple already auto-generates from docstrings, creating maintenance burden and bloating the generated Staple documentation. Meanwhile, AI agents parsing the repo have no structured API reference file to consume.

## What Changes

- **Create** `docs/api-reference.md` containing the full API Reference section (lines 163–1163) extracted from README.md
- **Edit** README.md to replace the API Reference section with a concise link to the new file
- **Edit** `.gitignore` to track individual docs files instead of ignoring the entire `docs/` directory

## Capabilities

### New Capabilities

None — this is a documentation reorganization, not a new feature.

### Modified Capabilities

None — no spec-level behavioral changes.

## Impact

- **README.md**: Loses ~900 lines of API tables; gains a brief pointer section
- **`docs/` directory**: New `docs/api-reference.md` file; must be git-tracked
- **`.gitignore`**: Replace blanket `docs/` exclusion with specific `docs/index.html` exclusion (Staple output)
- **Staple output**: Unchanged — `staple.ext.lisp` only includes README.md, which no longer contains duplicate API tables
- **AI agent consumption**: Agents can now read `docs/api-reference.md` for a complete function reference without parsing the entire README
