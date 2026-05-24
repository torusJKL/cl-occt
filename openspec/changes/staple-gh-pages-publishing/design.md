## Context

The project uses Staple (Common Lisp documentation generator) with a custom page class and Markdown formatting (configured in `staple.ext.lisp`). Staple generates a static HTML site from ASDF system docstrings. Currently, generating the docs is a manual step.

The existing CI workflow (`pr-check.yml`) already handles the full build chain: installing system deps (sbcl, cmake, g++, Quicklisp), building OCCT from source with caching, and compiling the C wrapper. The doc workflow reuses this pattern.

## Goals / Non-Goals

**Goals:**
- Automatically generate Staple HTML docs on every push to `main`
- Deploy generated docs to GitHub Pages
- Add a `just docs` recipe for local doc generation
- Reuse the existing OCCT cache key so cached builds are shared with `pr-check.yml`

**Non-Goals:**
- Redesign the Staple configuration or docstring formatting
- Publish docs on PRs (only `main`)
- Host docs outside GitHub Pages

## Decisions

1. **Deployment: `peaceiris/actions-gh-pages`** — simpler than GitHub's Pages deploy actions. Pushes the `docs/` output to the `gh-pages` branch on each deploy. The GitHub repo must have Pages configured to serve from the `gh-pages` branch. Requires a `GITHUB_TOKEN` with contents:write permission.

2. **Staple invocation via SBCL** — run `(asdf:load-system :cl-occt)` then call `(staple:generate-system-docs :cl-occt :output-directory "...")`. This mirrors how `just start` and `just test-core` load the system, requiring Quicklisp for the staple dependency chain.

3. **Cache key: `occt-${{ env.OCCT_VERSION }}-visual`** — same key as `pr-check.yml`. Ensures the OCCT build cache is shared between CI workflows, avoiding redundant builds.

4. **Just recipe: `just docs`** — simple wrapper for local generation, reusing the same SBCL invocation pattern from `just start`.

## Risks / Trade-offs

- [Build time] Full OCCT build on cache miss takes ~15 min → mitigated by caching with shared key
- [Staple failure] Malformed docstrings could break the generation step → mitigated by running generation after tests pass (or as a separate workflow)
- [Quicklisp availability] Staple and its dependencies (`staple-markdown`, `3bmd`, etc.) must be installable via Quicklisp in CI → verified they're in the Quicklisp dist
- [Docs directory] `docs/` currently contains static images; generated HTML mixes with them → acceptable, Staple only writes `.html` files, images are untouched
