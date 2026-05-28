## 1. Core Implementation (src/core/text.lisp)

- [x] 1.1 Extend `%compute-gp-ax3` to accept optional `x-direction` and return 9 values (px, py, pz, nx, ny, nz, xx, xy, xz) when provided
- [x] 1.2 Unify `make-text-shape` into a single code path: always call plane variant, dispatch to `%make-text-shape-on-plane` or `%make-text-shape-on-plane-full` based on whether `x-direction` is provided
- [x] 1.3 Add `:x-direction` keyword argument (default `nil`) to `make-text-shape`
- [x] 1.4 Add `:x-direction` keyword to `make-text-shape-on-plane`, forward to `make-text-shape`
- [x] 1.5 Add `:x-direction` keyword to `make-text-shape-3d`, forward to `make-text-shape`
- [x] 1.6 Add `:x-direction` keyword to `make-multi-line-text` and `make-formatted-text`, forward to `make-text-shape`
- [x] 1.7 Verify `%make-text-shape` FFI binding is retained (no removal — dead code but needed for C ABI)

## 2. Documentation

- [x] 2.1 Update `docs/api-reference.md` — add `x-direction` to signatures for `make-text-shape`, `make-text-shape-3d`, `make-text-shape-on-plane`, `make-multi-line-text`, `make-formatted-text`
- [x] 2.2 Add an example of using `:x-direction` on a non-XY plane to `docs/api-reference.md`

## 3. Verification

- [x] 3.1 Run `just test-core` to confirm no regressions
- [x] 3.2 Run `just test-all` to confirm full test suite passes
