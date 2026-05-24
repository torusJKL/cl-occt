## 1. Primer & Staple Setup

- [x] 1.1 Convert `primitives.lisp` docstrings to Markdown as a style primer and get approval before proceeding
- [x] 1.2 Create `staple.ext.lisp` in project root with custom page class, `format-documentation` method (markdown compile + xref markup), and packages override for `:cl-occt` / `:cl-occt.impl`
- [x] 1.3 Verify docstrings render correctly by running Staple generation on the project

## 2. Core Primitives & Shape Files

- [x] 2.1 Convert `booleans.lisp` docstrings to Markdown
- [x] 2.2 Convert `transforms.lisp` docstrings to Markdown
- [x] 2.3 Convert `compounds.lisp` docstrings to Markdown
- [x] 2.4 Convert `shape.lisp` docstrings to Markdown
- [x] 2.5 Convert `errors.lisp` docstrings to Markdown
- [x] 2.6 Verify: `just test-core` passes

## 3. Curves, Surfaces & 2D Geometry

- [x] 3.1 Convert `curves.lisp` docstrings to Markdown
- [x] 3.2 Convert `surfaces.lisp` docstrings to Markdown
- [x] 3.3 Convert `geom2d.lisp` docstrings to Markdown
- [x] 3.4 Verify: `just test-core` passes

## 4. Faces & Topology

- [x] 4.1 Convert `faces.lisp` docstrings to Markdown
- [x] 4.2 Convert `topology.lisp` docstrings to Markdown
- [x] 4.3 Verify: `just test-core` passes

## 5. Features (Fillets, Chamfers, Blends, Draft, Sweep, Loft, Pipe, Shell, Offset, Holes, Helix)

- [x] 5.1 Convert `fillet.lisp` docstrings to Markdown
- [x] 5.2 Convert `chamfer.lisp` docstrings to Markdown
- [x] 5.3 Convert `blend.lisp` docstrings to Markdown
- [x] 5.4 Convert `draft.lisp` docstrings to Markdown
- [x] 5.5 Convert `sweep.lisp` docstrings to Markdown
- [x] 5.6 Convert `loft.lisp` docstrings to Markdown
- [x] 5.7 Convert `pipe-feature.lisp` docstrings to Markdown
- [x] 5.8 Convert `shell.lisp` docstrings to Markdown
- [x] 5.9 Convert `offset.lisp` docstrings to Markdown
- [x] 5.10 Convert `local-ops.lisp` docstrings to Markdown
- [x] 5.11 Convert `hole-prism-revol.lisp` docstrings to Markdown
- [x] 5.12 Convert `face-filling.lisp` docstrings to Markdown
- [x] 5.13 Convert `helix.lisp` docstrings to Markdown
- [x] 5.14 Verify: `just test-core` passes

## 6. I/O & Assembly

- [x] 6.1 Convert `io.lisp` docstrings to Markdown
- [x] 6.2 Convert `assembly.lisp` docstrings to Markdown
- [x] 6.3 Verify: `just test-core` passes

## 7. Text

- [x] 7.1 Convert `text.lisp` docstrings to Markdown
- [x] 7.2 Verify: `just test-core` passes

## 8. Geometric Algorithms & Mass Properties

- [x] 8.1 Convert `geom-algorithms.lisp` docstrings to Markdown
- [x] 8.2 Convert `mass-properties.lisp` docstrings to Markdown
- [x] 8.3 Convert `shape-analysis.lisp` docstrings to Markdown
- [x] 8.4 Verify: `just test-core` passes

## 9. Shape Healing (Fix, Process, Rebuild)

- [x] 9.1 Convert `shape-fix.lisp` docstrings to Markdown
- [x] 9.2 Convert `shape-process.lisp` docstrings to Markdown
- [x] 9.3 Convert `shape-rebuild.lisp` docstrings to Markdown
- [x] 9.4 Verify: `just test-core` passes

## 10. Viewer Base (Viewer, Camera, Rendering, Grid, Background)

- [x] 10.1 Convert `viewer.lisp` docstrings to Markdown
- [x] 10.2 Convert `viewer-camera.lisp` docstrings to Markdown
- [x] 10.3 Convert `viewer-rendering.lisp` docstrings to Markdown
- [x] 10.4 Convert `viewer-grid.lisp` docstrings to Markdown
- [x] 10.5 Convert `viewer-background.lisp` docstrings to Markdown
- [x] 10.6 Verify: `just test-core` passes

## 11. Viewer Styling (Colors, Defaults, Lighting, Object Props, Drawer, Dimensions, Text Labels)

- [x] 11.1 Convert `viewer-colors.lisp` docstrings to Markdown
- [x] 11.2 Convert `viewer-defaults.lisp` docstrings to Markdown
- [x] 11.3 Convert `viewer-lighting.lisp` docstrings to Markdown
- [x] 11.4 Convert `viewer-object-props.lisp` docstrings to Markdown
- [x] 11.5 Convert `viewer-drawer.lisp` docstrings to Markdown
- [x] 11.6 Convert `viewer-dimensions.lisp` docstrings to Markdown
- [x] 11.7 Convert `viewer-text-labels.lisp` docstrings to Markdown
- [x] 11.8 Verify: `just test-core` passes

## 12. Final Verification

- [x] 12.1 Run `just test-core` — all tests pass
- [x] 12.2 Run `just test-all` — all tests pass (including viewer tests under xvfb)
