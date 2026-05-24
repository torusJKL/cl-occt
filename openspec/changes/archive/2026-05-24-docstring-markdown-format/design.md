## Context

All ~324 public function docstrings in `src/core/*.lisp` were recently added using a plain-text convention (ALL-CAPS `PARAM -- description`, plain `Example:` labels, inline prose for return values). These docstrings are readable in the REPL but have no structure for documentation generation. The project intends to use Staple with the `staple-markdown` extension to generate HTML documentation, which requires docstrings to use Markdown formatting that 3bmd can parse.

## Goals / Non-Goals

**Goals:**
- Reformat every public function docstring from plain text to a consistent Markdown format
- Establish a single canonical convention that covers parameters, returns, examples, predicates, cross-references, and edge cases
- Add `staple.ext.lisp` configuration so Staple renders the Markdown correctly (including xref linking)
- No functional or behavioral changes — only docstring text

**Non-Goals:**
- Not adding or removing any documentation content (only reformatting existing information)
- Not modifying internal `cl-occt.impl` functions (they have no docstrings)
- Not setting up a Staple GitHub Actions deployment pipeline
- Not generating or publishing HTML documentation — just enabling it

## Decisions

### D1. Markdown flavor: 3bmd + 3bmd-ext-code-blocks

`staple-markdown` depends on `3bmd` (core Markdown) and `3bmd-ext-code-blocks` (fenced code blocks). This determines what syntax is available:
- ATX headings (`#`), bold (`**`), italic (`*`), inline code (`` ` ``)
- Indented code blocks (4+ spaces)
- Fenced code blocks with language tags (`` ```lisp ``)
- Links, lists, blockquotes
- No tables, definition lists, or admonitions

### D2. Parameter names: bold lowercase in bullet lists

`- **dx** width along X axis (positive double-float)`

Rationale: Bold lowercase matches the actual lambda-list names (e.g., `dx` not `DX`). The bullet-list format replaces the previous `DX -- description` convention and renders as a clean HTML list.

### D3. Section labels: bold with colon

`**Returns:**`, `**Example:**`, `**See also:**`

Rationale: Consistent with Markdown conventions for labeled sections. Not using ATX headings (`###`) to avoid visual noise in REPL display.

### D4. Returns format: labeled section, bullet list for multi-value

Single value: `**Returns:** a new `shape`, or `nil` on error.`

Multi-value:
```
**Returns:**
- projected point (X Y Z)
- distance
- curve parameter
```

Returns `nil` on failure is appended as a separate paragraph after the list.

### D5. nil/t: inline code (xref-linked)

`` `nil` ``, `` `t` ``

When rendered via Staple, `markup-code-snippets` calls `xref` on inline code content. For `nil` and `t`, the Common Lisp xref resolver finds definitions in the CL package and emits links to `http://l1sp.org/cl/nil` and `http://l1sp.org/cl/t`. This is acceptable and informative.

### D6. Code examples: indented blocks

```
**Example:**

    (make-box 10 20 30)
    ;; => new shape
```

Rationale: Indented code blocks (4+ spaces) are cleaner in raw docstrings than fenced blocks. The blank line before the indented block is required by Markdown. Output annotations use `;; =>` inside the code block so syntax highlighting treats them as comments.

### D7. See also: inline code references

`**See also:** `cut`, `fuse`, `common``

Each function name is in inline code, which Staple will xref-link to its definition page/anchor.

### D8. Predicates: one-liner with Returns label

`**Returns:** `t` if `obj` is a `shape` object, `nil` otherwise.`

No separate parameter list section. The `**Returns:**` label (with colon) introduces the whole sentence.

### D9. Minimal transformation

If a function currently has no Example, See also, or Returns section, don't add one — only reformat what exists.

### D10. Staple configuration

A `staple.ext.lisp` file in the project root will:
- `(asdf:load-system :staple-markdown)`
- Define a custom page class
- Override `format-documentation` to compile docstrings as Markdown and then xref-markup code snippets
- Override `packages` to include `:cl-occt` and `:cl-occt.impl`

## Risks / Trade-offs

- **[Risk] Indentation errors break code blocks**: If the blank line before a 4-space-indented code block is missing, 3bmd won't render it as a code block. → **Mitigation**: Visual review after each file conversion; test via Staple's `compile-source` on a sample file.
- **[Risk] Inconsistent conversion across 324 docstrings**: Human error in applying the convention across 45 files. → **Mitigation**: Process files in batches with a clear checklist; use `just test-core`/`just test-all` to verify nothing broke.
- **[Trade-off] Raw REPL readability**: Markdown formatting (`**bold**`, `` `code` ``) adds visual noise compared to current plain text. → Accepted: the rendered HTML documentation benefit outweighs the minor raw-text noise.
- **[Trade-off] xref linking of nil/t**: `nil` and `t` in Returns sections become links to CLHS. → Accepted: these links are informative rather than distracting.
