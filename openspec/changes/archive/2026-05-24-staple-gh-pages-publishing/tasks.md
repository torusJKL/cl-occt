## 1. Local doc generation recipe

- [x] 1.1 Add `just docs` recipe to `justfile` that runs SBCL with Quicklisp, loads `cl-occt`, and calls `(staple:generate-system-docs :cl-occt :output-directory "docs/")`
- [x] 1.2 Verify `just docs` generates HTML files in `docs/` without errors

## 2. GitHub workflow

- [x] 2.1 Create `.github/workflows/docs.yml` with trigger: `push: branches: [main]`
- [x] 2.2 Add system dependency installation step (cmake, g++, sbcl, curl, just, libfreetype-dev, libx11-dev, libfontconfig-dev, libgl1-mesa-dev)
- [x] 2.3 Add Quicklisp installation step
- [x] 2.4 Add OCCT version extraction step (same pattern as `pr-check.yml`)
- [x] 2.5 Add OCCT build/cache step (same cache key: `occt-${{ env.OCCT_VERSION }}-visual`)
- [x] 2.6 Add C wrapper compilation step (`just wrap`)
- [x] 2.7 Add doc generation step: SBCL loads `cl-occt` via Quicklisp, runs Staple to generate docs into `docs/`
- [x] 2.8 Add deployment step using `peaceiris/actions-gh-pages` with `publish_dir: ./docs` and `publish_branch: gh-pages`

## 3. Verify

- [x] 3.1 Ensure `docs/` directory exists in `.gitignore` or is handled appropriately (generated files should be in `.gitignore`; deployed by CI only)
- [x] 3.2 Run `just test-core` to confirm no regression from justfile changes
- [x] 3.3 Validate workflow YAML syntax
