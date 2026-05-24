## 1. Extract API Reference to separate file

- [x] 1.1 Create `docs/api-reference.md` with exact content of README.md lines 163–1163 (from `## API Reference` heading through end of Color System section), plus a preamble: "This file is extracted from README.md for AI agent consumption. See README.md for project overview."

## 2. Update README.md

- [x] 2.1 Replace lines 163–1163 in README.md with a concise link section:
  `## API Reference\n\nSee [docs/api-reference.md](docs/api-reference.md) for the complete API reference (function signatures, descriptions, and examples).`

## 3. Update .gitignore

- [x] 3.1 Change `docs/` to `docs/index.html` in `.gitignore` so `docs/api-reference.md` is tracked

## 4. Verify

- [x] 4.1 Run `just test-core` to confirm no tests are broken by the change
- [x] 4.2 Verify `docs/api-reference.md` has no content lost by diffing key sections
- [x] 4.3 Confirm `docs/index.html` is still git-ignored and `docs/api-reference.md` is not
