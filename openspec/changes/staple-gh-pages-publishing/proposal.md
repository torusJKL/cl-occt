## Why

The project uses Staple for documentation generation (configured in `staple.ext.lisp`), but HTML docs must be generated manually. There's no automated pipeline to build and publish the documentation site. A GitHub workflow will generate Staple docs on every push to `main` and deploy them to GitHub Pages, making the API docs always up-to-date and accessible to users.

## What Changes

- New GitHub workflow `.github/workflows/docs.yml` that:
  - Installs system dependencies (SBLC, CMake, Quicklisp, etc.) for building the C wrapper and loading `cl-occt`
  - Builds/caches OCCT shared libraries (reuses cache from `pr-check.yml`)
  - Compiles the C wrapper (`just wrap`)
  - Loads the `cl-occt` system and runs Staple to generate HTML docs into `docs/`
  - Deploys the `docs/` directory to GitHub Pages via `peaceiris/actions-gh-pages` or the built-in `actions/deploy-pages`
- New `just docs` recipe in `justfile` for local doc generation
- No functional changes to the library itself

## Capabilities

### New Capabilities
- `docs-publishing`: Automated Staple documentation generation and GitHub Pages deployment. Defines the CI pipeline for building HTML docs from docstrings and publishing them with each commit to `main`.

### Modified Capabilities

- None. The library's functional behavior is unchanged.

## Impact

- `.github/workflows/docs.yml` — new workflow file
- `justfile` — new `docs` recipe
- `docs/` — becomes the output directory for generated HTML (existing static images remain)
- Dependencies: `staple`, `staple-markdown`, `3bmd`, `3bmd-ext-code-blocks` (already loadable via Quicklisp, needed at doc-generation time only)
