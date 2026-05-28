## 1. Update docs/api-reference.md

- [x] 1.1 Update `make-text-shape-3d` description to state that extrusion follows the plane normal when `:normal` is provided (currently says "Same position/normal/x-direction args as `make-text-shape`")
- [x] 1.2 Verify all other text function descriptions in `docs/api-reference.md` are consistent with source docstrings

## 2. Add text API section to doc/api-reference.md

- [x] 2.1 Add "### 3D Text" section to `doc/api-reference.md` with function signature table matching `docs/api-reference.md` lines 1239-1263
- [x] 2.2 Add font size note and code examples mirroring `docs/api-reference.md` lines 1265-1310
- [x] 2.3 Verify `doc/api-reference.md` text section is consistent with `docs/api-reference.md`

## 3. Review

- [ ] 3.1 Run `just test-core` to confirm no test regressions (pre-existing build issue: `precision_confusion` undefined alien function in `geometry-evaluation`, unrelated to doc changes)
- [x] 3.2 Manually inspect both files for formatting consistency
