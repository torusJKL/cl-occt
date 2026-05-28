# cl-occt API Reference

## OCAF Document & Label Tree

OCAF (Open CASCADE Application Framework) document with label tree navigation.

### Classes

- **`ocaf-doc`** — CLOS class wrapping a `TDocStd_Document` handle.
- **`ocaf-label`** — Struct wrapping a `TDF_Label` handle. Labels are lightweight (no finalizer).

### Document Lifecycle

- **`(make-ocaf-doc)`** → `ocaf-doc` or `nil`
  Create a new OCAF document.
- **`(ocaf-free-doc doc)`** → `t`
  Free an OCAF document created with `make-ocaf-doc`.
- **`(ocaf-doc-p obj)`** → `boolean`
  Predicate for `ocaf-doc` type.

### Label Tree Navigation

- **`(ocaf-root-label doc)`** → `ocaf-label` or `nil`
  Return the root label (label 0:1) of the document.
- **`(ocaf-find-label doc tags &key create)`** → `ocaf-label` or `nil`
  Find or create a label by tag path. `tags` is a list of integers (e.g., `'(0 1 0)` for path 0:1:0). If `create` is true, missing labels are created.
- **`(ocaf-label-children label)`** → list of `ocaf-label` or `nil`
  Return the child labels of the given label.
- **`(ocaf-label-tag label)`** → integer
  Return the tag (integer) of the label.
- **`(ocaf-label-depth label)`** → integer
  Return the depth of the label in the label tree.
- **`(ocaf-label-p obj)`** → `boolean`
  Predicate for `ocaf-label` type.

### Document Transactions

- **`(ocaf-begin-transaction doc &optional name)` 
  Begin a transaction on the document.
- **`(ocaf-commit-transaction doc)` 
  Commit the current transaction.
- **`(ocaf-undo-transaction doc)` 
  Undo the last committed transaction.

---

## OCAF Attributes

Typed data attributes attached to labels.

### Integer Attributes

- **`(ocaf-set-integer label value)` 
  Set an integer attribute on the label.
- **`(ocaf-get-integer label)`** → integer
  Get the integer value from the label.
- **`(ocaf-has-integer-p label)`** → `boolean`
  Check if the label has an integer attribute.

### Real (Double) Attributes

- **`(ocaf-set-real label value)` 
  Set a real (double) attribute on the label.
- **`(ocaf-get-real label)`** → double
  Get the real value from the label.
- **`(ocaf-has-real-p label)`** → `boolean`
  Check if the label has a real attribute.

### String Attributes

- **`(ocaf-set-string label value)` 
  Set a string attribute on the label.
- **`(ocaf-get-string label)`** → string
  Get the string value from the label.
- **`(ocaf-has-string-p label)`** → `boolean`
  Check if the label has a string attribute.

### Name Attribute

- **`(ocaf-set-name label name)` 
  Set a name (extended string) attribute on the label.
- **`(ocaf-get-name label)`** → string or `nil`
  Get the name from the label.

---

## Topological Naming

Track shape identity through operations using `TNaming`.

### Evolution Keywords

The evolution of a named shape is specified by one of:
- `:primitive` — original shape
- `:generated` — shape generated from a previous shape
- `:modified` — shape modified from a previous shape
- `:deleted` — shape was deleted
- `:selected` — shape selected for an operation

### Functions

- **`(ocaf-name-shape label shape evolution)` 
  Name (tag) a shape on a label under the given evolution.
- **`(ocaf-get-named-shape label &optional (evolution :generated))`** → `shape` or `nil`
  Retrieve the named shape from the label. Returns `nil` if no shape is stored.
- **`(ocaf-shape-deleted-p label)`** → `boolean`
  Check if the named shape on this label was deleted.

---

## Parametric Functions

Define parametric function drivers and trigger recomputation.

- **`(ocaf-add-function label driver-guid)`** → `boolean`
  Create a `TFunction_Function` attribute on the label with the given driver GUID (string).
- **`(ocaf-set-function-input func-label input-label)`** → `boolean`
  Register `input-label` as an input to the function.
- **`(ocaf-set-function-output func-label output-label)`** → `boolean`
  Register `output-label` as an output of the function.
- **`(ocaf-recompute doc)`** → integer
  Recomputed all dirty functions in the document and returns the count.
- **`(ocaf-recompute-function func-label)`** → `boolean`
  Recompute a single function by its label.

---

## XCAF GD&T (Dimensions, Tolerances, Datums)

Geometric Dimensioning & Tolerancing via `XCAFDimTolObjects` and `XCAFDoc_DimTolTool`. All GD&T is attached to shapes within an XCAF document and persists through STEP round-trips.

### Dimensions

- **`(xcaf-add-linear-dimension doc shape points &key value)`** → `boolean`
  Create a linear dimension between two 3D points. `points` is a list of two `(x y z)` coordinates. Example: `(xcaf-add-linear-dimension doc box (list p1 p2) :value 50.0)`.
- **`(xcaf-add-angular-dimension doc shape edges &key value)`** → `boolean`
  Create an angular dimension between two edges. `edges` is a list of two `shape` objects.
- **`(xcaf-add-diameter-dimension doc shape subshape &key value)`** → `boolean`
  Create a diameter dimension on a cylindrical face or circular edge.

### Tolerances

- **`(xcaf-add-tolerance doc shape type &key value modifiers)`** → `boolean`
  Create a tolerance (manufacturing tolerance). `type` is a keyword: `:flatness`, `:position`, `:parallelism`, `:perpendicularity`, `:concentricity`, `:circular-runout`, `:total-runout`, `:circularity`, `:cylindricity`, `:profile-of-line`, `:profile-of-surface`, `:angularity`, `:symmetry`, `:straightness`. Optional `modifiers` is a list like `'(:mmc :rfs)`.

### Datums

- **`(xcaf-add-datum doc shape &key label)`** → `boolean`
  Create a datum reference. `label` is a string like `"A"` or `"A-B"` for compound datums.

### Geometric Tolerances

- **`(xcaf-add-geometric-tolerance doc shape type value &key datums)`** → `boolean`
  Create a geometric tolerance with optional datum references. `type` uses the same keywords as `xcaf-add-tolerance`. `datums` is a list of datum label strings, e.g., `'("A")`.

### Query Functions

- **`(xcaf-get-dimensions doc shape)`** → list of plists or `nil`
  Return all dimensions on the shape. Each plist has `:type` (integer code), `:value`, `:nb-points`, `:points`.
- **`(xcaf-get-tolerances doc shape)`** → list of plists or `nil`
  Return all tolerances on the shape. Each plist has `:type`, `:value`, `:geom-tolerance-p`.
- **`(xcaf-get-datums doc shape)`** → list of strings or `nil`
  Return datum labels attached to the shape.

---

## Topology Data Access

Low-level queries on shape topology via OCCT's `BRep_Tool`.

### Vertex Point

- **`(vertex-point vertex)`** → x, y, z or `nil` (three values)
  Return the 3D coordinates of a `vertex` via `BRep_Tool::Pnt`.

### Edge Curve & Range

- **`(edge-curve-range edge)`** → curve, first, last or `nil` (three values)
  Return the `Geom_Curve` and its parameter range `(first, last)` for an `edge` via `BRep_Tool::Curve`.
- **`(edge-curve edge)`** → curve or `nil`
  Convenience alias returning only the curve.

### Face Surface & UV Bounds

- **`(face-surface-uv-bounds face)`** → surface, u-min, u-max, v-min, v-max or `nil` (five values)
  Return the `Geom_Surface` and its UV domain bounds for a `face` via `BRep_Tool::Surface` + `BRepAdaptor_Surface`.
- **`(face-surface face)`** → surface or `nil`
  Convenience alias returning only the surface.

### Tolerance

- **`(shape-tolerance shape)`** → double-float or `nil`
  Return the tolerance of a shape (edge, face, or vertex) via `BRep_Tool::Tolerance`.

### Natural Restriction

- **`(face-natural-restriction-p face)`** → `boolean`
  Return whether the face has natural restriction (its UV bounds match the full surface parameterization) via `BRep_Tool::NaturalRestriction`.

### Orientation

- **`(reverse-orientation shape)`** → shape or `nil`
  Return a new shape with reversed orientation via `TopoDS::Reversed`.
- **`(shape-orientation shape)`** → `:forward`, `:reversed`, `:internal`, `:external` or `nil`
  Return the orientation keyword of any shape.

---

## Geometry Evaluation

Curve and surface evaluation at parameter/UV, plus OCCT precision constants.

### Curve Evaluation

- **`(curve-value curve t)`** → x, y, z or `nil` (three values)
  Evaluate a `curve` at parameter `t` and return the 3D point via `Geom_Curve::Value`.

### Surface Evaluation

- **`(surface-value surface u v)`** → x, y, z or `nil` (three values)
  Evaluate a `surface` at parameters `(u, v)` and return the 3D point via `Geom_Surface::Value`.

### Precision Constants

- **`+precision-confusion+`** — double-float constant (typical `1e-7`)
  `Precision::Confusion()` — default tolerance for shape coincidence checks.
- **`+precision-angular+`** — double-float constant (typical `1e-12`)
  `Precision::Angular()` — default angular tolerance.
- **`+precision-intersection+`** — double-float constant (typical `1e-9`)
  `Precision::Intersection()` — default intersection tolerance.

---

## Shape Copy

Deep copy of shapes with full independence.

- **`(copy-shape shape)`** → shape or `nil`
  Create an independent deep copy of any shape via `BRepBuilderAPI_Copy`. The copy shares no data with the original — modifying or garbage-collecting the original does not affect the copy.

---

## Uniform Point Distribution

Compute evenly-spaced points along a curve via `GCPnts_UniformAbscissa` (fixed count) or `GCPnts_UniformDeflection` (maximum chordal deviation).

### Functions

- **`(uniform-abscissa-points curve first last num-points)`** → list of (x y z) triples or `nil`
  Compute `num-points` evenly-spaced points along `curve` between `first` and `last` parameter values. Returns a list of (x y z) coordinate triples.

- **`(uniform-deflection-points curve first last deflection)`** → list of (x y z) triples or `nil`
  Compute points along `curve` with maximum chordal deviation `deflection` between `first` and `last` parameter values.

---

## Assembly Location

Query and manipulate shape locations (`TopLoc_Location`). Locations represent coordinate transformations.

### Functions

- **`(make-location dx dy dz)`** → location or `nil`
  Create a location from a translation vector (dx, dy, dz).

- **`(compose-locations loc1 loc2)`** → location or `nil`
  Compose two locations: `loc1 · loc2`.

- **`(invert-location loc)`** → location or `nil`
  Return the inverse of a location.

- **`(shape-location shape)`** → location or `nil`
  Return the `TopLoc_Location` of a shape.

- **`(move-shape shape location)`** → shape or `nil`
  Return a new shape moved by `location` without mutating the original.

---

## Edge Finding

Find edges in a shape by geometric criteria via `BRepLib_FindEdges`.

### Functions

- **`(find-edges-by-type shape curve-type)`** → list of shapes or `nil`
  Find edges whose curve type matches `curve-type`. Use `6` for linear edges, `5` for circular, `4` for elliptical.

- **`(find-edges-by-radius shape radius)`** → list of shapes or `nil`
  Find circular edges with the given `radius`.

---

## Normal Projection

Project a shape (wire or edge) onto a face along the face surface normal via `BRepAlgo_NormalProjection`.

### Functions

- **`(normal-project shape face)`** → shape or `nil`
  Project `shape` onto `face` along the surface normal. Returns the projected shape.

---

## Transfer Parameters

Map a parameter from an edge to a target curve via `ShapeAnalysis_TransferParameters`.

### Functions

- **`(transfer-parameter source-edge target-curve param)`** → `double-float` or `nil`, `boolean`
  Transfer parameter `param` from `source-edge` to `target-curve`. Returns the mapped parameter and a success flag.

---

## BREP Native I/O

Read and write the OCCT-native `.brep` format via `BRepTools::Write` and `BRepTools::Read`.

### Functions

- **`(write-brep shape filename)`** → `boolean`
  Write `shape` to a `.brep` file. Returns `t` on success.

- **`(read-brep filename)`** → shape or `nil`
  Read a shape from a `.brep` file.

---

## Wedge Primitive

Create a wedge (tapered box) via `BRepPrimAPI_MakeWedge`.

### Functions

- **`(make-wedge dx dy dz ltx)`** → shape or `nil`
  Create a full wedge with dimensions dx × dy × dz and front-face taper `ltx` along X.

- **`(make-wedge dx dy dz xmin zmin xmax zmax)`** → shape or `nil`
  Create a corner wedge with the given corner coordinates.

---

## Drafted Prism

Create a drafted prismatic feature (additive or subtractive) via `BRepFeat_MakeDPrism`.

### Functions

- **`(make-drafted-prism shape face profile height angle operation)`** → shape or `nil`
  Create a drafted prism on `shape`. `face` is the base face, `profile` is the profile shape, `height` is extrusion distance, `angle` is the draft angle in degrees, and `operation` is `0` for subtractive or `1` for additive.

---

## Remove Features

Remove specified features (holes, protrusions) from a shape via `BRepAlgoAPI_RemoveFeatures`.

### Functions

- **`(remove-features shape faces)`** → shape or `nil`
  Remove the list of `faces` (features) from `shape`. Returns the shape without the specified features.

---

## Fix Small Faces

Fix (remove) small faces on a shape via `ShapeFix_FixSmallFace`.

### Functions

- **`(fix-small-faces shape)`** → shape or `nil`
  Detect and remove small faces from `shape`.

---

## Shape Tolerance Tools

Set tolerance on subshapes by type via `ShapeFix_ShapeTolerance`.

### Functions

- **`(set-shape-tolerance shape tolerance shape-type)`** → `boolean`
  Set `tolerance` on all subshapes of `shape-type` (e.g., `6` for edges, `7` for vertices, `4` for faces).

---

## RWStl I/O

Low-level STL file read/write via `RWStl`, providing direct access to the triangulation data.

### Functions

- **`(read-stl-triangulation filename)`** → triangulation handle or `nil`
  Read an STL file and return a triangulation handle.

- **`(write-stl-triangulation triangulation filename)`** → `boolean`
  Write a triangulation handle to an STL file.

- **`(free-stl-triangulation triangulation)`** 
  Free a triangulation handle returned by `read-stl-triangulation`.

---

## Constrained 2D Geometry

Compute analytical 2D geometry constraints via `GccAna` — circle tangent to two lines, line through two points.

### Functions

- **`(circle-tangent-two-lines line1-pt line1-dir line2-pt line2-dir radius)`** → list of plists or `nil`
  Compute circles of `radius` tangent to two 2D lines. Each line is a point `(x y)` and direction `(dx dy)`. Returns a list of `(:center-x double :center-y double :radius double)` plists, or `nil` on invalid input.

- **`(line-through-two-points p1 p2)`** → `(x y dx dy)` or `nil`
  Compute a 2D line passing through two points `p1 (x1 y1)` and `p2 (x2 y2)`. Returns `(point-x point-y dir-x dir-y)` or `nil` on coincident points.

---

## Units API

Convert numeric values between unit systems via `UnitsAPI`.

### Functions

- **`(convert-units value from-unit to-unit)`** → `double-float`
  Convert `value` from `from-unit` to `to-unit`. Units are strings like `"mm"`, `"inch"`, `"kg"`, `"lbm"`.

- **`(convert-to-si value unit)`** → `double-float`
  Convert `value` from `unit` to SI base units.

- **`(convert-from-si value unit)`** → `double-float`
  Convert `value` from SI base units to `unit`.

---

## Expression Interpreter

Parse and evaluate mathematical expression strings via `ExprIntrp`.

### Functions

- **`(evaluate-expression expr)`** → `double-float` or `nil`
  Evaluate a mathematical expression string. Supports arithmetic (`+`, `-`, `*`, `/`), trigonometric functions (`sin`, `cos`, `tan`), constants (`PI`), and standard math functions. Returns `nil` on invalid expressions.

---

## Math Solvers (1D)

Find roots and minima of 1D functions via `math_BissecNewton` and `math_NewtonMinimum`.

### Functions

- **`(function-root fn x0 x1 &key ftol max-iterations)`** → plist or `nil`
  Find a root of a 1D function in the interval `[x0, x1]`. `fn` is a function of one argument returning a double. Returns `(:converged t :root double :iterations int)` or `nil` on failure.

- **`(newton-minimum fn x0 &key tolerance max-iterations)`** → plist or `nil`
  Find a local minimum of a 1D function starting from `x0`. Returns `(:converged t :min-x double :min-value double :iterations int)` or `nil` on failure.

---

## 3D Text

Font loading and text shape creation via OCCT's `Font_BRepFont`. All font and text functions are in the `cl-occt` package.

### Font Lifecycle

- **`(make-brep-font-from-file path size &optional face-id)`** → `brep-font` or `nil`
  Load a TrueType/OpenType font from a file path. Returns a BREP font object or `nil`.
- **`(make-brep-font-from-name name size &key aspect)`** → `brep-font` or `nil`
  Look up a system font by name. `aspect` is `:regular`, `:bold`, `:italic`, or `:bold-italic` (default `:regular`).
- **`(brep-font-p obj)`** → `boolean`
  Predicate: returns `t` for `brep-font` objects, `nil` otherwise.

### Flat & 3D Text Shapes

- **`(make-text-shape font text &key h-align v-align position normal x-direction)`** → `shape` or `nil`
  Render text as a flat BRep shape. Supports optional `:position` `(x y z)`, `:normal` `(dx dy dz)`, and `:x-direction` `(dx dy dz)` for arbitrary plane placement. When `:x-direction` is provided, controls the text baseline direction on the plane (OCCT auto-computes when omitted). Returns a `shape` or `nil`.

- **`(make-text-shape-3d font text depth &key h-align v-align position normal x-direction)`** → `shape` or `nil`
  Render and extrude text. Extrusion follows the plane normal when `:normal` is provided; otherwise extrusion is along Z. Same position/normal/x-direction args as `make-text-shape`.

- **`(make-text-shape-on-plane font text &key h-align v-align position normal x-direction)`** → `shape` or `nil`
  Convenience — explicit position/normal defaults for plane placement. Also accepts `:x-direction`.

- **`(text-bounding-box font text &key h-align v-align)`** → values `width`, `height` or `nil`
  Query text extent without rendering.

### Font & Glyph Queries

- **`(list-available-fonts)`** → list of strings
  Return a list of available system font name strings.
- **`(font-info name)`** → plist
  Query font information (`:name`, `:key` plist) by name.
- **`(text-glyph-as-shape font codepoint)`** → `shape` or `nil`
  Render a single glyph by Unicode codepoint as a shape.
- **`(text-glyph-as-shape-3d font codepoint depth)`** → `shape` or `nil`
  Render and extrude a single glyph.
- **`(text-font-ascender font)`** → double-float or `nil`
  Font ascender height above baseline.
- **`(text-font-descender font)`** → double-float or `nil`
  Font descender depth below baseline.
- **`(text-font-line-spacing font)`** → double-float or `nil`
  Default line spacing (baseline to baseline).
- **`(text-font-advance-x font c1 c2)`** → double-float or `nil`
  Horizontal advance between two glyph codepoints (with kerning).
- **`(text-font-advance-y font c1 c2)`** → double-float or `nil`
  Vertical advance between two glyph codepoints.

### Font Rendering Controls

- **`(text-font-set-width-scaling font scale)`** → double-float or `nil`
  Set glyph width scaling factor for subsequent rendering.
- **`(text-font-set-composite-curve-mode font bool)`** → `boolean` or `nil`
  Toggle composite BSpline curves for glyph contours.

### Multi-line Text

- **`(make-multi-line-text font text &key h-align v-align position normal x-direction line-spacing)`** → `shape` or `nil`
  Render multi-line text (split on `#\Newline`), lines stacked vertically by `line-spacing`. Accepts `:x-direction` for each line.
- **`(make-formatted-text font text &key h-align v-align position normal x-direction line-spacing)`** → `shape` or `nil`
  Alias for `make-multi-line-text`.

### AIS Text Labels

- **`(make-ais-text-label text &key position color font height)`** → `ais-text-label` or `nil`
  Create an interactive 3D text label (`AIS_TextLabel`) for viewer display. Not exported to STL/STEP.
- **`(ais-text-label-p obj)`** → `boolean`
  Predicate for `ais-text-label` objects.
- **`(ais-free-text-label label)`** 
  Free an `ais-text-label`'s C handle.

Font size is in **model units** (e.g., millimeters). To convert from typographic points: `sizeInMeters = 0.0254 * pt / 72.0`.

```lisp
;; From a font file — create flat text
(let* ((font (make-brep-font-from-file "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf" 10.0))
       (flat (make-text-shape font "Hello 3D!")))
  (write-step flat "flat-text.step"))

;; From a font file — create 3D text (one step)
(let* ((font   (make-brep-font-from-file "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf" 10.0))
       (text3d (make-text-shape-3d font "Hello 3D!" 2.0)))
  (write-step text3d "hello-3d.step")
  (write-stl text3d "hello-3d.stl" :deflection 0.05))

;; System font with bold style
(let* ((font   (make-brep-font-from-name "Arial" 12.0 :aspect :bold))
       (text3d (make-text-shape-3d font "Centered" 1.5
                                    :h-align :center :v-align :center)))
  (write-step text3d "centered.step"))

;; Text on a rotated plane (YZ plane in this example)
(let* ((font   (make-brep-font-from-name "Arial" 10.0))
       (rotated (make-text-shape font "Angled" :position '(0 0 0) :normal '(1 0 0))))
  (write-step rotated "angled-text.step"))

;; Text on XZ plane with explicit X-direction (text reads rightward along +X)
(let* ((font   (make-brep-font-from-name "Arial" 10.0))
       (shaped (make-text-shape font "Hello"
                                :position '(0 0 0) :normal '(0 1 0)
                                :x-direction '(1 0 0))))
  (write-step shaped "xdir-text.step"))

;; Multi-line text (lines stacked vertically)
(let* ((font (make-brep-font-from-name "Arial" 10.0))
       (multi (make-multi-line-text font "Line1\nLine2\nLine3")))
  (write-step multi "multiline-text.step"))

;; Bounding box query (useful for layout)
(let* ((font (make-brep-font-from-name "Arial" 10.0)))
  (multiple-value-bind (w h) (text-bounding-box font "Hello")
    (format t "Text is ~,1f × ~,1f model units~%" w h)))

;; List available system fonts
(list-available-fonts)
```
