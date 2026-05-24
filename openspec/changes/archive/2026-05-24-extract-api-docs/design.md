## Context

The README.md at the project root serves dual purposes: (1) a quickstart/overview for human readers on GitHub, and (2) a source document for Staple-generated HTML documentation. The API Reference section (lines 163–1163) contains ~1000 lines of function tables and code examples that duplicate what Staple already generates from docstrings. This produces bloated output where every function appears twice — once in the README-derived section and once in the auto-generated definition index.

A separate `docs/api-reference.md` file solves both problems: Staple won't include it (it's not listed in `staple:documents`), and AI agents get a clean function reference without parsing the entire README.

## Goals / Non-Goals

**Goals:**
- Extract the API Reference section into `docs/api-reference.md` with no content loss
- Replace the extracted content in README.md with a brief link
- Fix `.gitignore` so the new file is tracked and only Staple's `docs/index.html` is ignored

**Non-Goals:**
- No changes to Staple configuration or docstring content
- No changes to the non-API sections of README.md (quickstart, build, architecture, etc.)
- No reformatting or editing of the API tables themselves

## Decisions

1. **Split boundary is the existing `## API Reference` heading**: Lines 163–1163 in README.md are a single contiguous "API Reference" section (heading + all subsections). The split occurs cleanly at this heading.

2. **`docs/api-reference.md` is a direct extraction, not a rewrite**: Preserve exact content to avoid introducing errors. Only add a frontmatter/preamble: "This file is extracted from README.md for AI agent consumption."

3. **Staple exclusion is implicit, not explicit**: `staple.ext.lisp` returns `(list (merge-pathnames "README.md" source))` from `staple:documents`. The new file is simply not in this list. No Staple code changes needed.

4. **`.gitignore` change is minimal**: Replace `docs/` with `docs/index.html`. This keeps the existing git-ignored state for the generated Staple file while allowing `docs/api-reference.md` (and any future docs files) to be tracked.

## Risks / Trade-offs

- **Stale copy risk**: `docs/api-reference.md` is a static extraction. If API functions change, the file can become outdated. **Mitigation**: The README extraction is a one-time snapshot at the boundary of the old approach. Future API reference additions go into specs/docstrings (canonical source), and this file becomes a reference snapshot.

- **Human discoverability**: Readers on GitHub who scan README.md for function signatures will need to follow a link. **Acceptable trade-off**: The README overview flow (quickstart → examples) is improved by removing the wall of tables. Power users who need signatures can follow the link or use the generated Staple docs.
