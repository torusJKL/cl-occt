## Why

The project now has ~324 public function docstrings written in plain text with ad-hoc formatting (ALL-CAPS parameters, `--` separator, plain `Example:` labels). This works in the REPL but is opaque to documentation generators. Adding a Staple documentation pipeline with the `staple-markdown` system lets us render rich, cross-linked HTML docs — but only if docstrings use Markdown formatting. Reformatting now, while the docstrings are freshly written and the patterns are consistent, avoids a costly migration later.

## What Changes

- Reformat all ~324 docstrings across 45 core Lisp files from plain text to Markdown:
  - Parameter names: `PARAM` → `**param**` (bold lowercase) in bullet lists
  - Inline code: `` `function` ``, `` `:keyword` ``, `` `nil` ``, `` `t` ``
  - Section labels: `**Example:**`, `**Returns:**`, `**See also:**` (bold with colon)
  - Return values: structured bullet lists for multi-valued returns
  - Code examples: indented code blocks with `;; =>` output convention
- Add `staple.ext.lisp` configuration for Staple documentation generation
- No functional changes — documentation formatting only

## Capabilities

### New Capabilities

- `docstring-markdown-convention`: Defines the canonical docstring formatting rules using Markdown, Staple, and `staple-markdown`. Specifies the syntax for parameter descriptions, return values, code examples, cross-references, and section labels.

### Modified Capabilities

- None. All 66 existing specs describe functional behavior; docstring formatting is orthogonal.

## Impact

- `src/core/*.lisp` (all 45 files): Docstring formatting changes only.
- `cl-occt.asd`: Optional — may add `doc/` path or `staple.ext.lisp` reference.
- New file: `staple.ext.lisp` in project root (Staple customization).
- Dependencies: `staple-markdown`, `3bmd`, `3bmd-ext-code-blocks` (for doc generation, not runtime).
