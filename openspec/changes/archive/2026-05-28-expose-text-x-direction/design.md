## Context

The C wrapper and FFI bindings expose `make_text_shape_on_plane_full` (accepting explicit X-direction vector) but the Lisp core API never calls it. The X-direction controls which way text reads ("rightward") on an arbitrary plane, which auto-computation (`gp_Ax3(pnt, zDir)`) handles unpredictably for non-XY planes.

Current call flow:

```
make-text-shape
  ├─ position/normal given → %compute-gp-ax3 → %make-text-shape-on-plane
  └─ neither given          → %make-text-shape (wraps _on_plane w/ defaults)
```

This dual-path design means `:x-direction` would be silently ignored in the "no-plane" branch — a correctness trap.

## Goals / Non-Goals

**Goals:**
- Add `:x-direction` keyword argument to `make-text-shape`, `make-text-shape-3d`, `make-text-shape-on-plane`, `make-multi-line-text`, `make-formatted-text`
- When `:x-direction` is non-nil, call `%make-text-shape-on-plane-full`
- When `:x-direction` is nil (default), retain current behavior via `%make-text-shape-on-plane`
- Unify the two internal code paths into one to eliminate silent-ignore risk

**Non-Goals:**
- Do not add new C wrapper or FFI bindings (already exist)
- Do not remove the dead `%make-text-shape` FFI binding (retained for C ABI compatibility)
- Do not validate X-direction input (OCCT handles degenerate cases)

## Decisions

### Decision 1: Single internal code path

Instead of `(if (or position normal) ... %make-text-shape ...)`, always call the plane variant with defaults:

```lisp
;; Before
(if (or position normal)
    (multiple-value-bind (px py pz nx ny nz)
        (%compute-gp-ax3 ...)
      (%make-text-shape-on-plane ... px py pz nx ny nz))
    (%make-text-shape font text h-align v-align))

;; After
(multiple-value-bind (px py pz nx ny nz xx xy xz)
    (%compute-gp-ax3 (or position '(0 0 0))
                     (or normal '(0 0 1))
                     x-direction)
  (if x-direction
      (%make-text-shape-on-plane-full ... xx xy xz)
      (%make-text-shape-on-plane ...)))
```

**Rationale**: Eliminates the branch where `:x-direction` would be silently ignored. The "no-plane" call was always equivalent to `_on_plane` with origin (0,0,0) and normal (0,0,1).

### Decision 2: `x-direction` default is nil

When nil, the system calls `%make-text-shape-on-plane` which lets OCCT auto-compute X from `gp_Ax3(pnt, zDir)`. This preserves existing behavior without requiring callers to understand X-direction.

When non-nil (a 3-element list of reals), the system calls `%make-text-shape-on-plane-full` with explicit X.

**Rationale**: No fixed default value (like `'(1 0 0)`) is correct for all planes — a good X for XY plane may be degenerate on YZ plane. Letting OCCT auto-compute is the safest default.

### Decision 3: Extend `%compute-gp-ax3` to handle x-direction

Current helper returns 6 values (px, py, pz, nx, ny, nz). Extended version optionally returns 9 values:

```lisp
(defun %compute-gp-ax3 (position normal &optional x-direction)
  ...)
```

When `x-direction` is nil, returns 6 values as before (backward compat with multi-value-bind callers). When non-nil, returns 9 values.

**Rationale**: Clean extension of existing pattern. Single-function keeps related logic together.

### Decision 4: Forward `:x-direction` through all text functions

`make-text-shape-3d`, `make-text-shape-on-plane`, `make-multi-line-text`, and `make-formatted-text` all accept `:x-direction` and pass it to `make-text-shape`.

**Rationale**: Consistency — if a user places text on a plane, they should be able to control the X direction at any entry point.

## Risks / Trade-offs

- **Degenerate X-direction** → OCCT `gp_Dir` constructor throws on zero vector; `gp_Ax3` accepts parallel X but produces garbled geometry. Mitigation: Document the constraint ("non-zero, not parallel to normal") in the docstring. No runtime validation — consistent with how `normal` and `position` are handled.
- **Dead code** → `%make-text-shape` FFI binding is no longer called from Lisp but kept for C ABI compatibility. No functional impact.
- **API surface growth** → Adding one keyword to 5 functions is minimal. The functions already accept `:position` and `:normal`, so `:x-direction` fits the existing pattern naturally.
