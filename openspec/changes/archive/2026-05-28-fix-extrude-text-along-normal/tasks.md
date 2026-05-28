## 1. Core Fix

- [x] 1.1 Modify `make-text-shape-3d` in `src/core/text.lisp` to extrude along the plane normal when `:normal` is provided, instead of always extruding along global Z

## 2. Test Improvement

- [x] 2.1 Update `text-shape-3d-on-rotated-plane` in `t/font-text-tests.lisp` to verify extrusion direction using `shape-extent-along` along Y and Z axes

## 3. Verification

- [x] 3.1 Run `just test-core` to confirm all text tests pass
