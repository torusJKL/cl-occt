# cl-occt API Reference

This file is extracted from README.md for AI agent consumption. See README.md for project overview.

## API Reference

### Primitives

| Function | Description |
|----------|-------------|
| `(make-box dx dy dz)` | Rectangular box |
| `(make-cylinder radius height)` | Cylinder |
| `(make-sphere radius)` | Sphere |
| `(make-cone r1 r2 height)` | Cone (r1=bottom, r2=top radius) |
| `(make-torus major-radius minor-radius)` | Torus (donut) |
| `(make-prism shape dx dy dz)` | Linear extrusion of a shape along a vector |
| `(make-revol shape ax ay az deg)` | Rotational extrusion of a shape around an axis |

Returns `nil` on invalid dimensions or degenerate parameters.

### Mechanical Features (BRepFeat)

Positional features that add or remove material relative to a specific face.

| Function | Description |
|----------|-------------|
| `(make-cylindrical-hole shape face radius depth &key through)` | Create a cylindrical hole. When `:through t`, creates a through hole; otherwise a blind hole of given depth |
| `(make-prism-feature shape base-face profile height &key operation direction)` | Linear extrusion from a face. `:operation` is `:cut` (depression) or `:add` (protrusion). `:direction` is a vector `(dx dy dz)` |
| `(make-revol-feature shape base-face profile axis angle &key operation)` | Rotational sweep from a face around `axis` by `angle` degrees. `:operation` is `:cut` or `:add` |
| `(make-pipe-feature shape base-face profile path &key operation)` | Pipe-shaped feature along a path wire. `:operation` is `:cut` or `:add` |

The `profile` argument is a wire defining the cross-section. The `base-face` must be a face of `shape`. All functions propagate nil on invalid inputs.

```lisp
;; Through hole on the first face of a box
(let* ((box (make-box 30 20 10))
       (faces (map-shape-subshapes box :face)))
  (make-cylindrical-hole box (first faces) 5 0 :through t))

;; Prismatic depression
(let* ((box (make-box 30 20 10))
       (faces (map-shape-subshapes box :face))
       (profile (make-wire (make-edge -5 -5 5 -5) (make-edge 5 -5 5 5)
                           (make-edge 5 5 -5 5) (make-edge -5 5 -5 -5))))
  (make-prism-feature box (first faces) profile 10 :operation :cut))
```

### Local Operations (LocOpe)

Lower-level local shape modifications on individual faces.

| Function | Description |
|----------|-------------|
| `(local-extrude face height)` | Extrude a single face by a given height along its normal |
| `(make-groove shape face axis angle)` | Create a revolved cut (groove) on a face around an axis (`angle` in degrees) |
| `(make-rib shape profile-face thickness &key direction)` | Create a rib by extruding a profile face and fusing it to the shape |

```lisp
(let* ((box (make-box 30 20 10))
       (faces (map-shape-subshapes box :face)))
  ;; Local extrusion of a face
  (local-extrude (first faces) 5)
  ;; Groove on a face
  (make-groove box (first faces) '(0 0 1) 45)
  ;; Rib from a profile fused to shape
  (make-rib box (first faces) 2 :direction '(0 0 1)))
```

### Booleans

| Function | Description |
|----------|-------------|
| `(cut a &rest others)` | Subtract shapes, left-to-right chaining |
| `(fuse a &rest others)` | Union shapes |
| `(common a &rest others)` | Intersect shapes |
| `(section a &rest others)` | Intersection curves/edges between shapes |

All propagate nil: if any argument is nil, result is nil.

### Edge Fillet

| Function | Description |
|----------|-------------|
| `(fillet-edge shape edge radius)` | Round a single edge with constant radius |
| `(fillet-edges shape edges radius)` | Round multiple edges with the same radius |
| `(fillet-edge-variable shape edge param-radius-pairs)` | Round an edge with variable radius. `param-radius-pairs` is a list of `(param radius)` where param is in [0,1] |
| `(fillet-wire-corner wire radius)` | Round the first corner of a planar wire (2D fillet) |
| `(fillet-wire-all-corners wire radius)` | Round all corners of a planar wire |

Edges are obtained via `(map-shape-subshapes shape :edge)`. All functions return `nil` on invalid inputs (nil shape, excessive radius, degenerate geometry).

```lisp
(let* ((box (make-box 30 20 10))
       (edges (map-shape-subshapes box :edge)))
  ;; Constant radius fillet on one edge
  (fillet-edge box (first edges) 5.0)
  ;; Variable radius fillet
  (fillet-edge-variable box (first edges)
                        '((0.0 3.0) (0.5 5.0) (1.0 3.0))))
```

### Chamfer

| Function | Description |
|----------|-------------|
| `(chamfer-edge shape edge distance)` | Bevel an edge with equal distance on both faces |
| `(chamfer-edges shape edges distance)` | Bevel multiple edges with equal distance |
| `(chamfer-edge-asymmetric shape edge d1 d2)` | Bevel an edge with different distances on each adjacent face |
| `(chamfer-edge-on-face shape edge distance face)` | Bevel an edge relative to a specific face |

```lisp
(let* ((box (make-box 30 20 10))
       (edges (map-shape-subshapes box :edge))
       (faces (map-shape-subshapes box :face)))
  (chamfer-edge box (first edges) 3.0)
  (chamfer-edge-asymmetric box (first edges) 4.0 2.0)
  (chamfer-edge-on-face box (first edges) 3.0 (first faces)))
```

### Sweep / Pipe

Sweep a profile (face or wire) along a spine, or sweep with multiple evolving sections.

| Function | Description |
|----------|-------------|
| `(sweep-profile profile spine &key mode)` | Sweep a single profile (face or wire) along a spine (wire). `:mode` is `:sliding` (Frenet, default) or `:fixed` (section orientation constant). |
| `(sweep-sections spine sections params &key mode)` | Sweep with multiple section wires at specified parameters along the spine. `:mode` is `:sliding` or `:fixed`. |
| `(sweep-with-aux-spine profile main-spine aux-spine)` | Sweep a profile along a main spine guided by an auxiliary spine. |

All return `nil` on invalid inputs (nil args, mismatched section/param counts).

```lisp
;; Simple pipe sweep: circle face along a line
(let* ((face (make-face (make-wire (make-circle-edge 0 0 5))))
       (spine (make-wire (make-edge-3d 0 0 0 20 0 0))))
  (sweep-profile face spine))

;; Fixed mode (section doesn't rotate with spine)
(sweep-profile face spine :mode :fixed)

;; Multi-section sweep: circle morphs from r=5 to r=10
(let* ((w1 (make-wire (make-circle-edge 0 0 5)))
       (w2 (make-wire (make-circle-edge 20 0 10)))
       (spine (make-wire (make-edge-3d 0 0 0 20 0 0))))
  (sweep-sections spine (list w1 w2) '(0.0 1.0)))
```

### Loft

Create a solid or shell through multiple section wires.

| Function | Description |
|----------|-------------|
| `(loft-sections wires &key solid ruled smooth initial-tangent final-tangent)` | Loft through a list of wire sections. `:solid t` (default) creates a closed solid, `:solid nil` creates a shell. `:ruled t` uses linear interpolation (no smoothing). `:smooth t` enables vertex smoothing. `:initial-tangent` and `:final-tangent` accept face references for tangency constraints. |

Returns `nil` on invalid inputs (nil wires, fewer than 2 wires).

```lisp
;; Loft two circular wires
(let* ((w1 (make-wire (make-circle-edge 0 0 5)))
       (w2 (make-wire (make-circle-edge 0 10 8))))
  (loft-sections (list w1 w2)))

;; Loft three wires with smooth interpolation
(let* ((w1 (make-wire (make-circle-edge 0 0 5)))
       (w2 (make-wire (make-circle-edge 0 10 8)))
       (w3 (make-wire (make-circle-edge 0 20 6))))
  (loft-sections (list w1 w2 w3) :smooth t))

;; Ruled loft (linear interpolation between sections)
(loft-sections (list w1 w2) :ruled t)

;; Open shell loft (not closed)
(loft-sections (list w1 w2) :solid nil)
```

### Face Filling

Fill an N-sided face from boundary edges or a boundary wire, with optional continuity constraints.

| Function | Description |
|----------|-------------|
| `(fill-face boundary-wire &key support-faces continuity)` | Fill a surface from a closed boundary wire. `:support-faces` is a list of reference faces. `:continuity` is a list of continuity keywords (`:c0`, `:tangent`, `:curvature`, `:g3`), one per support face. |
| `(fill-n-sided-face edges &key continuity)` | Fill an N-sided face from a list of boundary edges. `:continuity` is a keyword (`:c0`, `:tangent`, `:curvature`, `:g3`). |

Returns `nil` on invalid inputs (nil wire, fewer than 3 edges).

```lisp
;; Fill a square boundary wire
(let* ((w (make-wire (make-edge-3d 0 0 0 10 0 0)
                      (make-edge-3d 10 0 0 10 10 0)
                      (make-edge-3d 10 10 0 0 10 0)
                      (make-edge-3d 0 10 0 0 0 0))))
  (fill-face w))

;; Fill an N-sided face from four edges
(let* ((e1 (make-edge-3d 0 0 0 10 0 0))
       (e2 (make-edge-3d 10 0 0 10 10 0))
       (e3 (make-edge-3d 10 10 0 0 10 0))
       (e4 (make-edge-3d 0 10 0 0 0 0)))
  (fill-n-sided-face (list e1 e2 e3 e4)))
```

### Shell / Thicken (Hollow)

Create thin-walled shells by removing faces from a solid.

| Function | Description |
|----------|-------------|
| `(shell-shape shape faces &key thickness offset)` | Hollow a solid by removing specified faces. `:thickness` (default 1.0) is wall thickness. `:offset` is `:inward` (default, material removed inward) or `:outward` (material added outward). |

Faces are obtained via `(map-shape-subshapes shape :face)`. Returns `nil` on nil shape, nil faces, or excessive thickness.

```lisp
(let* ((box (make-box 30 20 10))
       (faces (map-shape-subshapes box :face)))
  ;; Remove the top face, 2mm wall thickness
  (shell-shape box (list (first faces)) :thickness 2.0)
  ;; Outward offset
  (shell-shape box (list (first faces)) :thickness 2.0 :offset :outward))
```

### Sewing

Stitch adjacent faces/shells into a single watertight shape.

| Function | Description |
|----------|-------------|
| `(sew-shapes shapes &key tolerance allow-non-manifold)` | Sew multiple shapes together. `:tolerance` (default 1e-6) controls gap tolerance. `:allow-non-manifold` (default nil) permits non-manifold topology. |

Returns `nil` on nil or empty shapes list.

```lisp
;; Sew two adjacent boxes together
(let* ((box1 (make-box 10 10 10))
       (box2 (translate (make-box 10 10 10) 10 0 0)))
  (sew-shapes (list box1 box2) :tolerance 0.1))
```

### Defeaturing

Remove selected features (holes, protrusions, fillets, etc.) from a shape by specifying faces to remove.

| Function | Description |
|----------|-------------|
| `(defeature-shape shape faces)` | Remove features from a shape. `faces` is a list of faces to remove. |

Returns `nil` on nil shape, nil/empty faces list, or if defeaturing fails.

```lisp
;; Remove the first face of a box
(let* ((box (make-box 30 20 10))
       (faces (map-shape-subshapes box :face)))
  (defeature-shape box (list (first faces))))
```

### Shape Check / Builder Algo

Validate shape validity and perform boolean operations via the general BuilderAlgo.

| Function | Description |
|----------|-------------|
| `(check-shape-validity shape)` | Check shape validity for boolean operations. Returns error description string or nil. |
| `(boolean-builder shape1 shape2 &key operation)` | General boolean builder. `:operation` is `:fuse`, `:cut`, `:common`, or `:section`. |

`check-shape-validity` returns nil for valid shapes or nil input. `boolean-builder` returns nil on nil inputs.

```lisp
;; Check shape validity
(check-shape-validity (make-box 10 20 30))   ; => nil (valid)

;; Boolean builder
(boolean-builder (make-box 10 10 10) (make-cylinder 5 15) :operation :cut)
```

### HLR (Hidden Line Removal)

Project a 3D shape onto a plane and classify edges as visible or hidden.

| Function | Description |
|----------|-------------|
| `(hlr-project shape &key direction position)` | Project shape edges with HLR. `:direction` is `(dx dy dz)` projection direction (default `(0 0 1)`, top view). `:position` is `(px py pz)` projection plane origin (default `(0 0 0)`). |

Returns a compound of visible and hidden edges, or nil on nil input. HLR edges are 2D projected edges — use `edge->curve` to extract the 2D curve; the 3D curve may not exist for hidden edges.

```lisp
;; Top-down HLR projection of a box
(hlr-project (make-box 30 20 10) :direction '(0 0 -1) :position '(0 0 5))
```

### Shape Conversion

Convert shape surfaces between analytic representations.

| Function | Description |
|----------|-------------|
| `(convert-to-revolution shape)` | Convert elementary surfaces to revolution surfaces where possible. |
| `(convert-swept-to-elementary shape)` | Convert swept surfaces to elementary surfaces where possible. |

Both return nil on nil input or when conversion is not applicable.

```lisp
(convert-to-revolution (make-cylinder 5 20))
(convert-swept-to-elementary (make-cylinder 5 20))
```

### 3D Shape Offset

Offset a solid or shell outward (enlarged) or inward (reduced).

| Function | Description |
|----------|-------------|
| `(offset-shape shape distance &key join)` | Offset a 3D shape by distance (positive = outward, negative = inward). `:join` is `:arc` (default), `:tangent`, or `:intersection`. |

Returns `nil` on nil shape.

```lisp
(offset-shape (make-box 10 10 10) 3.0)                   ; outward
(offset-shape (make-box 10 10 10) -2.0)                  ; inward
(offset-shape (make-box 10 10 10) 3.0 :join :arc)        ; rounded corners
(offset-shape (make-box 10 10 10) 3.0 :join :intersection) ; sharp corners
```

### 2D Wire Offset

Offset a planar wire in its plane.

| Function | Description |
|----------|-------------|
| `(offset-wire wire distance)` | Offset a planar wire by distance (positive = outward, negative = inward). Returns a shape or nil. |

```lisp
(let* ((w (make-wire (make-edge 0 0 10 0)
                      (make-edge 10 0 10 10)
                      (make-edge 10 10 0 10)
                      (make-edge 0 10 0 0))))
  (offset-wire w 3.0)   ; outward
  (offset-wire w -2.0)) ; inward
```

### Draft Angle

Apply a taper (draft) angle to faces of a solid.

| Function | Description |
|----------|-------------|
| `(draft-face shape face angle pull-direction neutral-plane)` | Apply draft angle (in degrees) to a face. `pull-direction` is a 3D vector `(dx dy dz)`. `neutral-plane` is a point `(x y z)` on the neutral plane. The neutral plane normal is set to the pull direction. |

Returns `nil` on nil inputs or excessive draft angle.

```lisp
(let* ((box (make-box 30 20 10))
       (faces (map-shape-subshapes box :face)))
  (draft-face box (first faces) 10.0 '(0 0 -1) '(0 0 0)))
```

### Evolved Solid

Construct an evolved solid by sweeping a profile along a spine.

| Function | Description |
|----------|-------------|
| `(make-evolved profile spine &key offset join)` | Sweep profile (wire) along spine (wire). `:offset` (default 0.0) applies further offset. `:join` is `:arc` (default), `:tangent`, or `:intersection`. |

Returns `nil` on nil inputs.

```lisp
(let* ((profile (make-wire (make-circle-edge 0 0 5)))
       (spine (make-wire (make-edge-3d 0 0 0 20 0 0))))
  (make-evolved profile spine)
  (make-evolved profile spine :offset 2.0))
```

### Transforms

| Function | Description |
|----------|-------------|
| `(translate shape dx dy dz)` | Move shape by vector |
| `(rotate shape ax ay az deg)` | Rotate around axis by degrees |

Original shape is unchanged. Nil in → nil out.

### STEP I/O

| Function | Description |
|----------|-------------|
| `(write-step shape path)` | Export to STEP AP203 file |
| `(read-step path)` | Import from STEP file |

### STL I/O

| Function | Description |
|----------|-------------|
| `(write-stl shape path &key deflection angle relative)` | Export to binary STL file (deflection=0.1, angle=0.5 rad, relative=nil) |
| `(read-stl path)` | Import from STL file |

### IGES I/O

| Function | Description |
|----------|-------------|
| `(write-iges shape path)` | Export to IGES file |
| `(read-iges path)` | Import from IGES file |
| `(write-iges-assembly root path)` | Export assembly tree to IGES preserving colors |
| `(read-iges-assembly path)` | Read IGES file with assembly structure |

### OBJ Mesh I/O

| Function | Description |
|----------|-------------|
| `(write-obj shape path &key coordinate-system name-format per-vertex-colors)` | Export to OBJ file |
| `(read-obj path &key coordinate-system)` | Import from OBJ file |

### VRML Export

| Function | Description |
|----------|-------------|
| `(write-vrml shape path &key deflection)` | Export to VRML file (deflection=0.1) |

### PLY Export

| Function | Description |
|----------|-------------|
| `(write-ply shape path &key coordinate-system per-vertex-colors)` | Export to PLY file |

### glTF I/O

Requires OCCT built with `-DUSE_RAPIDJSON=ON -DBUILD_MODULE_DEGLTF=ON` and `librapidjson-dev` installed.

| Function | Description |
|----------|-------------|
| `(write-gltf shape path &key coordinate-system per-vertex-colors)` | Export to glTF file (coordinate-system: `:zup` or `:yup`) |
| `(read-gltf path &key coordinate-system)` | Import from glTF file |

### Mesh Operations

Control shape tessellation and access mesh data (vertices, triangles, normals, connectivity).

| Function | Description |
|----------|-------------|
| `(mesh-shape shape &key deflection angle relative)` | Explicitly triangulate shape using BRepMesh_IncrementalMesh. Returns shape for chaining, nil on invalid input |
| `(mesh-get-vertices shape)` | Extract vertex positions as list of `(x y z)` triples. Returns nil if unmeshed |
| `(mesh-get-triangles shape)` | Extract triangle indices as list of `(i0 i1 i2)` 0-based triples. Returns nil if unmeshed |
| `(mesh-get-normals shape)` | Extract per-vertex normals as list of `(nx ny nz)` vectors. Returns nil if unavailable |
| `(mesh-get-triangle-count shape)` | Number of triangles (nil instead of 0 if unmeshed) |
| `(mesh-triangle-adjacent shape tri-index edge-index)` | Get adjacent triangle index across edge (0-2). Returns nil on boundary |
| `(mesh-triangle-elements shape tri-index)` | Three vertex indices of a triangle as multiple values. Returns nil on invalid index |

```lisp
;; Mesh a box with fine tessellation
(let ((box (mesh-shape (make-box 10 20 30) :deflection 0.05 :angle 0.2)))
  (mesh-get-vertices box))  ; → ((x y z) ...)

;; Chain mesh with STL export
(write-stl (mesh-shape (make-box 10 20 30) :deflection 0.02) "fine.stl")
```

### MeshVS Display (Raw Mesh Viewer)

Display polygonal meshes directly in the viewer without requiring a TopoDS_Shape.

| Function | Description |
|----------|-------------|
| `(make-meshvs-mesh vertices triangles &key colors)` | Create a MeshVS displayable mesh from vertices and triangles |
| `(meshvs-display ctx mesh)` | Display a meshvs-mesh in an AIS context |
| `(meshvs-free mesh)` | Explicitly free a meshvs-mesh's C handle; safe to call on nil |

```lisp
(with-viewer (v)
  (let* ((ctx (ais-create-context v))
         (mesh (make-meshvs-mesh '((0 0 0) (10 0 0) (10 10 0) (0 10 0))
                                 '((0 1 2) (0 2 3)))))
    (meshvs-display ctx mesh)))
```

### Compounds

| Function | Description |
|----------|-------------|
| `(make-compound list-of-shapes)` | Collect shapes into a `TopoDS_Compound` for multi-shape I/O |
| `(add-to-compound compound shape)` | Add a shape to an existing compound; returns updated compound |
| `(compound-shape-p obj)` | Predicate: returns `t` for compound shapes, `nil` otherwise |

Nil shapes in the input list are silently skipped. If all shapes are nil or the list is empty, returns nil. Pass the result directly to `(write-stl ...)` to export all sub-shapes as a single STL file.

```lisp
;; Export multiple shapes as one STL
(let ((c (make-compound (list (make-box 30 20 10)
                               (translate (make-sphere 8) 15 10 5)))))
  (write-stl c "assembly.stl" :deflection 0.05))

;; Incremental building
(let ((c (make-compound (list (make-box 10 20 30)))))
  (add-to-compound c (make-cylinder 5 20))
  (write-stl c "parts.stl"))
```

### Assembly Tree (Colored STEP I/O)

| Function | Description |
|----------|-------------|
| `(make-part shape &key name color location)` | Create a leaf node with geometry and optional metadata |
| `(make-assembly &key name children)` | Create a branch node with children and optional name |
| `(assembly-shape node)` | Get the shape of a node (nil for pure assemblies) |
| `(assembly-name node)` | Get the name string (nil if unset) |
| `(assembly-color node)` | Get color plist `(:type r g b a)` or nil |
| `(assembly-location node)` | Get 4×4 transformation matrix or nil |
| `(assembly-children node)` | Get list of child nodes (nil for leaves) |
| `(setf (assembly-name node) val)` | Set the name |
| `(setf (assembly-color node) val)` | Set the color |
| `(setf (assembly-children node) val)` | Set the children list |
| `(assembly-leaf-p node)` | True if node has no children |
| `(assembly-branch-p node)` | True if node has children |
| `(read-step-assembly path)` | Read a STEP file with colors and assembly structure |
| `(write-step-assembly assembly path)` | Write an assembly tree to STEP preserving colors |

Colors are plists: `(:generic r g b a)`, `(:surf r g b a)`, `(:curv r g b a)` with components in [0,1]. Locations are row-major 4×4 matrices as `#(16 double-floats)` or nil for identity.

### 2D Geometry (Geom2d)

| Function | Description |
|----------|-------------|
| `(make-pnt2d x y)` | 2D point |
| `(make-vec2d x y)` | 2D vector |
| `(make-dir2d x y)` | 2D direction (unit vector; nil on zero input) |
| `(make-line2d x y dx dy)` | 2D infinite line through point with direction |
| `(make-circle2d x y radius)` | 2D circle curve (nil on non-positive radius) |

Returns `geom2d` objects (distinct from `shape`), GC-managed via `tg:finalize`.

### 3D Curves

| Function | Description |
|----------|-------------|
| `(make-line-3d x y z dx dy dz)` | Infinite 3D line through point with direction (nil on zero direction) |
| `(make-circle-3d x y z radius)` | 3D circle centered at point in XY plane |
| `(make-ellipse x y z major-r minor-r)` | 3D ellipse in XY plane |
| `(make-hyperbola x y z major-r minor-r)` | 3D hyperbola in XY plane |
| `(make-parabola x y z focal)` | 3D parabola in XY plane |
| `(make-bezier-curve points)` | Bezier curve through list of `(x y z)` points |
| `(make-bspline-curve poles knots mults degree)` | BSpline curve from poles, knot vector, multiplicities, and degree |
| `(make-gc-line x1 y1 z1 x2 y2 z2)` | Trimmed line segment between two points |
| `(make-gc-arc-of-circle x1 y1 z1 x2 y2 z2 x3 y3 z3)` | Circular arc through three points |
| `(curve-type curve)` | Return keyword type (`:line`, `:circle`, `:ellipse`, `:hyperbola`, `:parabola`, `:bezier-curve`, `:bspline-curve`, `:gc-line`, `:gc-arc-of-circle`, `:helix`) or nil |
| `(convert-curve-to-bspline curve)` | Convert elementary curve to BSpline representation |
| `(curve-bounding-box curve)` | Returns `(values xmin ymin zmin xmax ymax zmax)` or nil |

Returns `curve` objects (distinct from `shape` and `geom2d`), GC-managed via `tg:finalize`.

### 3D Surfaces

| Function | Description |
|----------|-------------|
| `(make-plane x y z nx ny nz)` | Infinite plane through point with normal |
| `(make-cylindrical-surface x y z dx dy dz radius)` | Cylindrical surface along axis |
| `(make-conical-surface x y z dx dy dz radius semi-angle)` | Conical surface (semi-angle in degrees) |
| `(make-spherical-surface x y z radius)` | Spherical surface |
| `(make-toroidal-surface x y z major-r minor-r)` | Toroidal surface |
| `(make-bezier-surface poles num-u num-v)` | Bezier surface from grid of poles |
| `(make-bspline-surface poles num-u-poles num-v-poles uknots umults vknots vmults udeg vdeg)` | BSpline surface |
| `(surface-type surface)` | Return keyword type (`:plane`, `:cylindrical-surface`, `:conical-surface`, `:spherical-surface`, `:toroidal-surface`, `:bezier-surface`, `:bspline-surface`) or nil |
| `(convert-surface-to-bspline surface)` | Convert elementary surface to BSpline representation |
| `(surface-bounding-box surface)` | Returns `(values xmin ymin zmax ymax zmax)` or nil |

Returns `surface` objects, GC-managed via `tg:finalize`.

### Geometric Algorithms

| Function | Description |
|----------|-------------|
| `(project-point-on-curve curve x y z)` | Project point onto 3D curve. Returns `(values x y z dist param)` or nil |
| `(project-point-on-surface surface x y z)` | Project point onto surface. Returns `(values x y z u v dist)` or nil |
| `(intersect-curves curve1 curve2)` | Intersect two 3D curves. Returns list of `(x y z)` points or nil |
| `(intersect-curve-surface curve surface)` | Intersect curve with surface. Returns list of `(x y z)` points or nil |
| `(intersect-surfaces surface1 surface2)` | Intersect two surfaces. Returns list of `curve` objects or nil |
| `(extrema-curve-curve curve1 curve2)` | Min distance between two curves. Returns `(values dist point1 point2)` or nil |
| `(extrema-curve-surface curve surface)` | Min distance from curve to surface. Returns `(values dist point u v)` or nil |
| `(intersect-curves-2d curve1 curve2)` | Intersect two 2D curves. Returns list of `(x y)` points or nil |
| `(project-point-on-curve-2d curve x y)` | Project 2D point onto 2D curve. Returns `(values x y dist param)` or nil |
| `(points-to-bspline points &key degree)` | Approximate points with BSpline curve. Returns `curve` or nil |
| `(interpolate-points points &key initial-tangent final-tangent)` | Interpolate points exactly. Returns `curve` or nil |

All functions accept nil inputs and return nil, propagating errors gracefully.

### Helix

| Function | Description |
|----------|-------------|
| `(make-helix-curve &key radius pitch height left-handed angle)` | Create helical parametric curve. Returns `curve` or nil |
| `(make-helix-edge &key radius pitch height left-handed angle on-surface)` | Create helical BRep edge. Returns `shape` or nil |

Keyword arguments: `:radius` (mandatory), `:pitch` (mandatory), `:height` (mandatory), `:left-handed` (default nil), `:angle` (taper angle in degrees, default 0.0), `:on-surface` (for edge, optional surface constraint).

### Face Construction

| Function | Description |
|----------|-------------|
| `(make-edge x1 y1 x2 y2)` | Linear edge between two 2D points |
| `(make-edge-3d x1 y1 z1 x2 y2 z2)` | Linear edge between two 3D points |
| `(make-circle-edge x y radius)` | Full circle edge from 2D center and radius |
| `(make-circular-arc x1 y1 x2 y2 x3 y3)` | Circular arc through three 2D points |
| `(make-wire &rest edges)` | Connect edges into a wire |
| `(make-face wire)` | Planar face from a closed wire (auto-detects plane) |
| `(make-face-on-plane wire ox oy oz nx ny nz)` | Planar face on an explicit plane |

Returns `nil` on invalid input. Use `make-wire` → `make-face` → `make-prism`/`make-revol` to create solids from 2D profiles.

### Mass Properties

Query physical properties of solid shapes via BRepGProp.

| Function | Description |
|----------|-------------|
| `(shape-volume shape)` | Volume of a solid. Returns double or nil |
| `(shape-area shape)` | Surface area of a shape. Returns double or nil |
| `(shape-center-of-mass shape)` | Center of mass as 3 values: `(x y z)`. Returns nil on error |
| `(shape-gprops shape)` | Batch compute all mass properties. Returns `gprops` instance |
| `(shape-inertia shape)` | Alias for `shape-gprops` |

The `gprops` class has readers: `gprops-volume`, `gprops-area`, `gprops-center-of-mass`,
`gprops-inertia-matrix` (6-component list: Ixx Iyy Izz Ixy Ixz Iyz),
`gprops-principal-moments` (3 values), `gprops-principal-axes` (9 values, 3x3 matrix).

```lisp
(let ((g (shape-gprops (make-box 10 20 30))))
  (gprops-volume g))                ; → 6000.0
(multiple-value-bind (x y z)
    (shape-center-of-mass (make-box 10 20 30))
  (list x y z))                     ; → (5.0 10.0 15.0)
```

All functions accept nil and return nil.

### Shape Healing

OCCT's shape healing toolkit for repairing topological defects, replacing sub-shapes, converting NURBS, and applying healing pipelines.

#### Shape Fix

Repair common topological defects in shapes. All functions return a repaired shape or `nil` on error/nil input.

| Function | Description |
|----------|-------------|
| `(fix-shape shape)` | General repair via `ShapeFix_Shape`. Fixes wires, solids, edges, and faces internally. Returns a repaired shape or nil. |
| `(fix-wire wire face &key tolerance)` | Fix wire issues (gaps, self-intersections, orientation). `face` is the supporting face (can be nil). `:tolerance` defaults to 0.1. |
| `(fix-solid shape)` | Fix solid validity issues. |
| `(fix-edge edge)` | Fix edge problems (missing 3D curve, vertex tolerances). |
| `(fix-face face)` | Fix face problems (wire orientation, missing geometry). |

```lisp
(fix-shape (make-box 10 20 30))          ; → shape (no-op on valid shape)
(fix-wire wire face :tolerance 0.1)      ; → fixed wire
(fix-solid (make-box 10 20 30))          ; → solid or nil
(fix-edge edge)                          ; → edge or nil
(fix-face face)                          ; → face or nil
```

#### Shape Analysis Diagnostics

Diagnose geometry and topology issues.

| Function | Description |
|----------|-------------|
| `(shape-analysis-free-edges shape)` | Return a compound of free (unconnected) edges, or nil if none. |
| `(shape-analysis-check-intersections shape)` | Count pairs of faces that incorrectly intersect. Returns integer or nil. |
| `(shape-analysis-wire-contains-p wire point)` | Check if a 2D point `(x y)` is inside the wire boundary. Returns t or nil. |
| `(shape-analysis-contents shape)` | Return a plist of sub-shape counts: `(:solids N :shells N :faces N :wires N :edges N :vertices N)`. |

```lisp
(shape-analysis-free-edges shape)              ; → compound of free edges or nil
(shape-analysis-check-intersections shape)     ; → 0 (no intersections)
(shape-analysis-wire-contains-p wire '(5 5))   ; → t
(shape-analysis-contents (make-box 10 20 30))  ; → (:FACES 6 :EDGES 24 ...)
```

#### Sub-shape Substitution

Replace individual sub-shapes (faces, edges) within a shape using `ShapeBuild_ReShape`.

| Function | Description |
|----------|-------------|
| `(substitute-shape orig old new)` | Single replacement: replace `old` sub-shape with `new` in `orig`. Returns a shape or nil. |
| `(substitute-shape orig pairs)` | Batch replacement: `pairs` is a list of `(old new)` lists. All replacements applied before returning. |

```lisp
;; Single face replacement
(substitute-shape box old-face new-face)

;; Batch replacement of multiple faces
(substitute-shape box '((face1 new-face1) (face2 new-face2)))
```

#### NURBS Conversion

Convert elementary curves and surfaces to BSpline (NURBS) representation.

| Function | Description |
|----------|-------------|
| `(shape-to-nurbs shape)` | Convert all elementary curves/surfaces to BSpline. |
| `(shape-reduce-degree shape max-degree)` | Reduce BSpline degree to at most `max-degree`. |
| `(shape-to-rational-bspline shape)` | Convert to rational BSpline form. |

```lisp
(shape-to-nurbs (make-box 10 20 30))            ; → NURBS shape
(shape-reduce-degree nurbs-shape 2)             ; → reduced degree
(shape-to-rational-bspline (make-box 10 20 30)) ; → rational BSpline
```

#### Surface Splitting and Continuity

Split faces and upgrade surface continuity using `ShapeUpgrade`.

| Function | Description |
|----------|-------------|
| `(shape-split-u shape num-splits)` | Split faces along U iso-lines. `num-splits` is a hint for the number of segments. |
| `(shape-upgrade-continuity shape &key continuity)` | Upgrade surface continuity. `:continuity` is `:c0`, `:c1`, `:c2`, or `:c3` (default `:c1`). |

```lisp
(shape-split-u shape 2)                             ; → split shape
(shape-upgrade-continuity shape :continuity :c2)    ; → C2 continuous
```

#### Healing Pipeline

Scriptable healing via `ShapeProcess` operators and convenience pipeline.

| Function | Description |
|----------|-------------|
| `(apply-shape-process shape operator)` | Apply a single `ShapeProcess` operator by name (string). Pass a list of strings to apply multiple operators in sequence. |
| `(apply-healing-pipeline shape pipeline &key resource)` | Apply a named healing pipeline from a resource file. `:resource` is the resource file name. |
| `(heal-shape shape)` | Default healing pipeline: `ShapeFix_Shape` + `SameParameter` + `ShapeFix_Solid`. Convenience for common STEP/STL import defects. |

```lisp
;; Single operator
(apply-shape-process (make-box 10 20 30) "FixShape")

;; Operator sequence
(apply-shape-process shape '("FixShape" "SameParameter" "FixWire" "FixSolid"))

;; Default convenience
(heal-shape shape)  ; one-call healing
```

### Shape Analysis Queries

Minimum distance, point-in-solid classification, validity checking, and curve-surface intersection.

| Function | Description |
|----------|-------------|
| `(shape-distance shape1 shape2)` | Minimum distance between two shapes. Returns double or nil |
| `(shape-distance-extrema shape1 shape2)` | Distance + closest points. Returns `shape-extrema` or nil |
| `(point-in-solid-p point shape)` | Classify point as `:inside`, `:outside`, or `:on` |
| `(classify-point-in-solid point shape)` | Returns two values: keyword and optional face (if `:on`) |
| `(shape-valid-p shape)` | Check topological validity. Returns t or nil |
| `(shape-check shape)` | Detailed validity report. Returns list of issues or nil |
| `(intersect-curve-shape curve shape)` | Intersect curve with BRep shape. Returns list of `(point u v face)` |

```lisp
(shape-distance box1 box2)                     ; → 10.0
(point-in-solid-p '(5 10 15) box)              ; → :inside
(multiple-value-bind (state face)
    (classify-point-in-solid '(0 10 15) box)
  state)                                       ; → :on
(shape-valid-p (make-box 10 20 30))            ; → t
```

The `shape-extrema` class has readers: `extrema-distance`, `extrema-point-on-shape1`, `extrema-point-on-shape2`.

### Topology Navigation

Walk, inspect, and construct topological entities.

| Function | Description |
|----------|-------------|
| `(map-shape-subshapes shape type &key stop-at)` | Explore sub-shapes. Returns list of shapes |
| `(count-shape-subshapes shape type &key stop-at)` | Count sub-shapes of a type |
| `(dump-shape shape)` | BRepTools text dump. Returns string or nil |
| `(shape-triangle-count shape)` | Triangle count after meshing. Returns integer or nil |
| `(wire-order-check-p wire &optional face)` | Check wire edge ordering. Returns t or nil |
| `(edge->curve edge)` | Extract 3D curve from edge. Returns `curve` or nil |
| `(face->surface face)` | Extract surface from face. Returns `surface` or nil |
| `(make-vertex x y z)` | Construct a vertex shape. Returns shape |
| `(make-polygon points &key closed)` | Polygon wire from point triples. Returns shape or nil |

Type keywords: `:compound`, `:compsolid`, `:solid`, `:shell`, `:face`, `:wire`, `:edge`, `:vertex`, `:shape`.

```lisp
(map-shape-subshapes box :face)        ; → list of 6 faces
(map-shape-subshapes box :edge)        ; → list of 24 edge entries
(count-shape-subshapes box :face)      ; → 6
(make-polygon '((0 0 0) (10 0 0) (10 10 0)) :closed nil)
                                       ; → open wire with 3 edges
(make-vertex 1.0 2.0 3.0)             ; → vertex shape
```

Note: `TopExp_Explorer` visits every sub-shape at each parent level. A box's 12 unique edges appear as 24 entries (one per face that uses them).

### Viewer

| Function | Description |
|----------|-------------|
| `(make-viewer)` | Create a 3D viewport |
| `(free-viewer v)` | Explicitly destroy a viewer |
| `(with-viewer (v) body...)` | Macro: auto-create and auto-free viewer |
| `(fit-all v &optional shape)` | Zoom to fit all displayed objects, or a specific shape when provided |
| `(must-be-resized v)` | Call after window resize |

### Display

| Function | Description |
|----------|-------------|
| `(ais-create-context viewer)` | Create an AIS interactive context from a viewer |
| `(ais-free-context ctx)` | Destroy an AIS context |
| `(ais-create-shape shape)` | Create an interactive shape object from a geometry shape |
| `(ais-display ctx shape-or-obj &key update)` | Display a shape or ais-object; returns ais-object |
| `(ais-erase ctx obj &key update)` | Hide an object (remains in context) |
| `(ais-remove ctx obj &key update)` | Permanently remove an object from context |
| `(ais-remove-all ctx &key update)` | Remove all objects from context |
| `(ais-displayed-p ctx obj)` | Check if an object is currently displayed |
| `(ais-free obj)` | Free an ais-object's C handle |

### AIS Interactive Types

| Function | Description |
|----------|-------------|
| `(make-colored-shape shape)` | Create an AIS colored shape with per-subshape color support |
| `(set-colored-shape-color cs sub-shape color)` | Set color of a sub-shape within a colored shape |
| `(make-manipulator)` | Create an interactive manipulator gizmo |
| `(attach-manipulator manip ais-obj)` | Attach a manipulator to an AIS object |
| `(set-manipulator-position manip x y z)` | Set manipulator position in world coordinates |
| `(set-manipulator-size manip size)` | Set manipulator visual size |
| `(set-manipulator-active-axes manip &key translate rotate scale)` | Enable/disable manipulator mode axes |
| `(make-connected-interactive source)` | Create a connected interactive object sharing another's geometry |
| `(make-point-cloud vertices)` | Create a point cloud from a list of (x y z) triples |
| `(set-point-cloud-colors pc colors)` | Set per-point colors for a point cloud |
| `(set-point-cloud-size pc size)` | Set point rendering size in pixels |
| `(make-ais-plane position normal &key size)` | Create an AIS plane overlay |
| `(make-ais-axis origin direction)` | Create an AIS axis overlay |
| `(make-ais-line point1 point2)` | Create an AIS line segment |
| `(make-ais-circle center normal radius)` | Create an AIS circle overlay |
| `(make-textured-shape shape filename)` | Create a shape with an image texture applied |
| `(set-texture-repeat obj u v)` | Set texture repeat count in UV directions |
| `(set-texture-origin obj u v)` | Set texture mapping origin offset |
| `(make-view-cube)` | Create a 3D orientation cube widget |
| `(set-view-cube-size vc size)` | Set view cube size |
| `(set-view-cube-box-color vc color)` | Set view cube face color |
| `(set-view-cube-corner vc corner)` | Position view cube in a view corner |
| `(make-ais-triangulation vertices triangles &key colors)` | Create a colored mesh display |
| `(make-color-scale)` | Create a color scale legend bar widget |
| `(set-color-scale-range cs min max)` | Set color scale value range |
| `(set-color-scale-size cs width height)` | Set color scale display dimensions |
| `(set-color-scale-title cs title)` | Set color scale title |
| `(set-color-scale-intervals cs n)` | Set number of color intervals |
| `(make-light-source light)` | Create an interactive light source representation |
| `(make-multiple-connected)` | Create a multiple-connected composite object |
| `(connect-to-multiple mc source)` | Connect an AIS object to a multiple-connected composite |

### Styling

| Function | Description |
|----------|-------------|
| `(set-background viewer r g b)` | Set viewer background color (RGB in [0,1]) |
| `(ais-set-color ctx obj color)` | Set object color as `(r g b)` list |
| `(ais-unset-color ctx obj)` | Revert object to default color |
| `(ais-set-display-mode ctx obj mode)` | Set display mode (`:wireframe` or `:shaded`) |

### Camera

| Function | Description |
|----------|-------------|
| `(set-view-projection view orientation)` | Set camera orientation (`:iso-pers`, `:z-pos`, `:x-pos`, etc.) |
| `(viewer-camera view)` | Capture current camera state as a `viewer-camera` value object (eye, target, up, projection-type, fov). |
| `(viewer-camera-p obj)` | Predicate for `viewer-camera` instances. |
| `(set-viewer-camera view cam)` | Apply a `viewer-camera` instance to a view. Returns the view. |
| `(set-camera view &key eye target up)` | Position camera with optional eye, target (look-at), and up vectors. Each is `(x y z)`. Partial calls update only the specified values. |
| `(set-perspective view bool)` | Switch between perspective (`t`) and orthographic (`nil`) projection. |
| `(perspective-p view)` | Return `t` if view uses perspective projection, `nil` for orthographic. |
| `(set-fov view degrees)` | Set vertical field of view in degrees. |
| `(set-clip-planes view &key near far)` | Set Z-clipping near and far plane distances. |
| `(pan-camera view dx dy)` | Pan (shift) the view by screen-space pixel amounts. |
| `(zoom-camera view factor)` | Set camera zoom scale factor. |
| `(rotate-camera view ax ay az)` | Rotate camera by angles in radians around X, Y, Z axes. |
| `(reset-view view)` | Restore default view orientation and mapping. |
| `(fit-all view &optional shape-or-obj)` | Zoom to fit all displayed objects, or a specific shape/ais-object when provided. |

### Object Properties

| Function | Description |
|----------|-------------|
| `(ais-set-transparency ctx obj value)` | Set object transparency (0.0 = opaque, 1.0 = fully transparent) |
| `(ais-set-material ctx obj preset)` | Set material preset by keyword (`:gold`, `:plastic`, `:glass`, `:chrome`, `:copper`, etc.) |
| `(make-material &key ambient diffuse specular shininess transparency)` | Create a custom material with ambient/diffuse/specular colors. |
| `(ais-set-custom-material ctx obj material)` | Apply a custom `material` instance to an object. |
| `(material-p obj)` | Predicate for material instances. |
| `(material-ambient mat)`, `(material-diffuse mat)`, `(material-specular mat)`, `(material-shininess mat)`, `(material-transparency mat)` | Access material component colors and shininess. |
| `(material-preset-list)` | Return list of available material preset keywords |
| `(ais-set-line-width ctx obj width)` | Set wireframe/edge line width in pixels |
| `(ais-show-edges ctx obj bool)` | Show/hide edges on shaded display |
| `(ais-set-edge-styling ctx obj &key color width)` | Configure edge appearance (color and width) |
| `(ais-set-selection-mode ctx obj mode)` | Set selection mode (nil = deactivate, 0=shape, 1=face, 2=edge, 3=vertex). Accepts keywords: `:shape`, `:face`, `:edge`, `:vertex`. |
| `(ais-set-tessellation obj &key quality deviation)` | Set tessellation quality (lower = finer mesh, default 0.1) |

### Selection

| Function | Description |
|----------|-------------|
| `(ais-set-selected ctx obj &key update)` | Replace selection with a single object |
| `(ais-add-or-remove-selected ctx obj &key update)` | Toggle object in/out of selection |
| `(ais-clear-selected ctx &key update)` | Deselect all objects |
| `(ais-is-selected ctx obj)` | Check if object is selected |
| `(ais-nb-selected ctx)` | Return number of selected objects |
| `(ais-selected-objects ctx)` | Return list of all selected `ais-object` instances |
| `(ais-selected-shapes ctx)` | Return list of all selected `shape` instances |
| `(ais-selected-interactive ctx)` | Return current `ais-object` during iteration |
| `(ais-selected-shape ctx)` | Return current `shape` during iteration |
| `(ais-has-selected-shape ctx)` | Check if current selection holds a shape |
| `(ais-init-selected ctx)` | Begin iteration over selected objects |
| `(ais-more-selected ctx)` | Check if more selected objects remain |
| `(ais-next-selected ctx)` | Advance to next selected object |
| `(ais-move-to ctx view x y)` | Detect objects under pixel `(x, y)`. Returns `AIS_StatusOfDetection` int. |
| `(ais-select-detected ctx &optional scheme)` | Confirm detected object as selected. Returns `AIS_StatusOfPick` int. |
| `(ais-select-point ctx view x y &optional scheme)` | Select topmost object at pixel `(x, y)`. Returns `AIS_StatusOfPick` int. |
| `(ais-hilight-selected ctx &key update)` | Highlight all selected objects |
| `(ais-unhilight-selected ctx &key update)` | Remove highlight from selected objects |
| `(ais-fit-selected ctx view &optional margin)` | Zoom camera to fit selected objects |
| `(ais-detected-interactive ctx)` | Return the currently detected `ais-object` |
| `(ais-has-detected ctx)` | Check if an object is detected |
| `(ais-clear-detected ctx)` | Clear detected (pre-selection) state |
| `(ais-set-selection-sensitivity ctx obj mode sensitivity)` | Set selection sensitivity for object+mode |
| `(ais-set-pixel-tolerance ctx pixels)` | Set pixel tolerance for mouse detection |
| `(ais-set-automatic-hilight ctx bool)` | Enable/disable automatic highlighting |
| `(ais-set-to-hilight-selected ctx bool)` | Enable/disable hilight-on-detection |

Selection schemes (`scheme` parameter above): `:replace` (default), `:add`, `:remove`, `:xor`, `:clear`, `:replace-extra`. See `*selection-scheme-map*`.

Status return values from `ais-move-to` can be decoded with `*status-of-detection-map*`. Status from `ais-select-detected`/`ais-select-point` with `*status-of-pick-map*`.

### Lighting

| Function | Description |
|----------|-------------|
| `(make-light type &key color intensity direction position)` | Create a light (`:ambient`, `:directional`, `:positional`, or `:spot`). `:color` accepts any color format, `:direction` is `(dx dy dz)` for directional/spot, `:position` is `(x y z)` for positional/spot. |
| `(viewer-light-p obj)` | Predicate for `viewer-light` instances. |
| `(free-light light)` | Free a light's C handle. |
| `(light-type light)` | Return `:ambient`, `:directional`, `:positional`, or `:spot`. |
| `(viewer-add-light viewer light)` | Register a light with a viewer. |
| `(viewer-remove-light viewer light)` | Unregister a light. |
| `(viewer-light-on viewer light)` | Enable a registered light. |
| `(viewer-light-off viewer light)` | Disable a registered light. |
| `(viewer-light-active-p viewer light)` | Check if a light is enabled. |
| `(set-light-color light color)` | Change light color (any color format). |
| `(set-light-intensity light v)` | Set light brightness (0.0-1.0). |
| `(set-light-direction light direction)` | Set direction for directional/spot lights. |
| `(set-light-position light position)` | Set position for positional/spot lights. |
| `(set-light-angle light degrees)` | Set spot light cone angle in degrees. |
| `(set-light-concentration light v)` | Set spot light falloff concentration (0.0-1.0). |
| `(set-headlight light bool)` | Attach/detach light from camera. |
| `(set-light-shadows light bool)` | Enable/disable shadow casting (ray-tracing). |
| `(viewer-lights viewer)` | List all registered lights for a viewer (returns list of `viewer-light`). |
| `(viewer-active-lights viewer)` | List registered lights that are currently enabled. |
| `(viewer-default-lights viewer)` | Restore default ambient + directional lights. |

### Grid

| Function | Description |
|----------|-------------|
| `(activate-grid viewer grid-type draw-mode)` | Show grid (`:rectangular`/`:circular`, `:lines`/`:points`) |
| `(deactivate-grid viewer)` | Hide grid |
| `(grid-active-p viewer)` | Return `t` if grid is active, `nil` otherwise |
| `(set-rectangular-grid-values viewer &key x-origin y-origin x-step y-step rotation-angle)` | Set grid spacing, offset, and rotation. |
| `(set-grid-xy-size viewer x y)` | Set grid X and Y spacing. |
| `(set-grid-offset viewer x y)` | Set grid origin offset. |
| `(grid-display view &key color size-x size-y)` | Display GPU shader grid with color and cell size. |
| `(set-grid-color viewer color)` | Convenience: set grid color only (wraps `grid-display`). |
| `(set-grid-size viewer size)` | Convenience: set uniform grid spacing (wraps `set-grid-xy-size`). |
| `(grid-color viewer)` | Stub: returns `nil` (no OCCT getter available). |
| `(grid-size viewer)` | Stub: returns `nil`. |
| `(grid-offset viewer)` | Stub: returns `nil`. |

### Background

| Function | Description |
|----------|-------------|
| `(set-gradient-background view &key color1 color2 style)` | Two-color gradient background. `:style` is `:x-pos`, `:x-neg`, `:y-pos`, `:y-neg`, `:z-pos`, or `:z-neg`. |
| `(set-image-background view path)` | Load an image file as the view background. |
| `(set-background-cubemap view &key pos-x neg-x pos-y neg-y pos-z neg-z)` | Set a cube-map environment from 6 image files (requires ray-tracing). |
| `(set-cube-map view &key pos-x neg-x pos-y neg-y pos-z neg-z)` | Alias for `set-background-cubemap`. |
| `(reset-background view)` | Reset background to solid black. |

### Rendering

| Function | Description |
|----------|-------------|
| `(set-msaa view samples)` | Set MSAA sample count (0, 2, 4, 8). |
| `(msaa view)` | Get current MSAA sample count. |
| `(set-antialiasing view bool)` | Enable/disable anti-aliasing. |
| `(antialiasing-p view)` | Check if anti-aliasing is enabled. |
| `(invalidate-view view)` | Request view redraw after property changes. |
| `(set-computed-mode view bool)` | Enable/disable ray-traced rendering. |
| `(computed-mode-p view)` | Return `t` if ray-tracing is enabled. |
| `(set-back-face-model view model)` | Set back-face model (`:auto`, `:force`, `:disable`). |
| `(set-frustum-culling view bool)` | Enable/disable frustum culling. |
| `(set-transparency-method view method)` | Set transparency sorting method (`:blend-unordered`, `:blend-oit`, `:depth-peeling-oit`). |
| `(set-transparent-shading view method)` | Alias for `set-transparency-method`. |
| `(redraw-view view)` | Force immediate redraw of main and overlay content. |
| `(set-immediate-update view bool)` | Control immediate flush of display changes. |

### Text Labels (Viewer)

| Function | Description |
|----------|-------------|
| `(set-text-label-angle label degrees)` | Rotate a text label by degrees. |
| `(set-text-label-hjustification label align)` | Set horizontal alignment (`:left`, `:center`, `:right`). |
| `(set-text-label-vjustification label align)` | Set vertical alignment (`:top`, `:cap`, `:half`, `:base`, `:bottom`). |
| `(set-text-label-display-type label type)` | Set display type (`:ordinary`, `:subtitle`, `:dekale`, `:blend`, `:dimension`). |
| `(set-text-label-subtitle-color label color)` | Set subtitle/background box color. |
| `(set-text-label-align label &key horizontal vertical)` | Set both horizontal (`:left`, `:center`, `:right`) and vertical (`:top`, `:cap`, `:half`, `:base`, `:bottom`) alignment in one call. |
| `(make-text-label ctx text position &key color font height angle)` | Create, configure, and display a text label in one call. |

### Dimensions

| Function | Description |
|----------|-------------|
| `(make-dimension type &key from to vertex point1 point2 shape edge edge1 edge2)` | Create a dimension. `:length` takes `:from` `:to` (points) or `:edge` (shape), `:angle` takes `:vertex` `:point1` `:point2` or `:edge1` `:edge2`, `:diameter`/`:radius` take `:shape`. |
| `(set-dimension-text-position dim (x y z))` | Set the position of the dimension label text. |
| `(set-dimension-units dim string)` | Set display units string (e.g. `"mm"`). |
| `(set-dimension-flyout dim v)` | Set flyout distance between dimension line and measured geometry. |
| `(set-dimension-arrow-length dim v)` | Set dimension arrow length. |
| `(set-dimension-extension-size dim v)` | Set dimension extension line length. |
| `(set-dimension-custom-value dim string)` | Override the displayed dimension text. |
| `(set-dimension-angle-edges dim edge1 edge2)` | Set measured edges for an angle dimension. |
| `(set-dimension-text dim value)` | Alias for `set-dimension-custom-value`. |
| `(set-dimension-arrows dim &key style size)` | Set arrow style (`:filled`, `:open`, `:none`) and size. |
| `(set-dimension-extension dim &key offset length)` | Set extension line offset and length. |

Dimensions are `ais-object` instances displayed with `ais-display`:

```lisp
(with-viewer (v)
  (let* ((ctx (ais-create-context v))
         (dim (make-dimension :length :from '(0 0 0) :to '(50 0 0))))
    (ais-display ctx dim)))
```

### Drawer (Prs3d) — Per-Object Aspect Control

| Function | Description |
|----------|-------------|
| `(ais-set-drawer-line-color obj color)` | Set line/wireframe color. |
| `(ais-set-drawer-line-width obj width)` | Set line/wireframe width in pixels. |
| `(ais-set-drawer-line-type obj type)` | Set line type (`:solid`, `:dash`, `:dot`, `:dot-dash`). |
| `(ais-set-drawer-shading-color obj color)` | Set surface shading color. |
| `(ais-set-drawer-point-color obj color)` | Set vertex/marker color. |
| `(ais-set-drawer-point-type obj type)` | Set marker type (`:point`, `:plus`, `:star`, `:o`, `:x`, `:ball`, `:ring`). |
| `(ais-set-drawer-point-scale obj scale)` | Set marker size multiplier. |
| `(ais-set-drawer-text-color obj color)` | Set text annotation color via drawer. |
| `(ais-set-drawer-text-font obj font)` | Set text annotation font name. |
| `(ais-set-drawer-text-height obj height)` | Set text annotation height. |
| `(ais-set-drawer-iso-display obj &key u-on v-on)` | Show/hide U/V iso-lines. |
| `(ais-set-drawer-wire-color obj color)` | Set wireframe color. |
| `(ais-set-drawer-face-boundaries obj bool)` | Show/hide face boundary edges. |
| `(ais-set-drawer-free-boundaries obj bool)` | Show/hide free boundary edges. |

### Viewer Defaults

| Function | Description |
|----------|-------------|
| `(set-default-background viewer color)` | Set default background color for new views. |
| `(set-default-bg-gradient viewer color1 color2 &key style)` | Set default gradient background for new views. |
| `(set-default-projection viewer orientation)` | Set default view orientation for new views. |
| `(set-default-view-size viewer size)` | Set default camera distance for new views. |
| `(set-default-view-type viewer type)` | Set default projection type (`:perspective` or `:orthographic`). |
| `(default-lights viewer)` | Restore the viewer's default lights. |
| `(set-default-gradient viewer color1 color2 &key style)` | Alias for `set-default-bg-gradient`. |
| `(set-default-lights viewer mode)` | Control default lights (`:on` restores, `:off` disables, `:custom` no-op placeholder). |

> **`set-default-drawer`**: Blocked. `V3d_Viewer` in OCCT 8.0 has no `SetDefaultDrawer` method. The alternative is through `AIS_InteractiveContext::DefaultDrawer()`, which is accessible via `ais-drawer`. See the Drawer table above for per-object aspect control.

### Trihedron

| Function | Description |
|----------|-------------|
| `(make-trihedron &key origin normal x-direction)` | Create a 3D axis indicator |
| `(set-trihedron-mode obj mode)` | Set datum mode (`:wireframe` or `:shaded`) |
| `(set-trihedron-arrows obj bool)` | Show/hide arrowheads |
| `(set-trihedron-size obj size)` | Set visual size |
| `(set-trihedron-corner obj corner &key x-offset y-offset)` | Pin to screen corner (`:lower-left`, `:upper-right`, etc.) |
| `(set-trihedron-axis-colors obj &key x y z)` | Set per-axis colors (accepts named colors or (r g b) lists; partial update: unspecified axes keep defaults) |
| `(set-trihedron-text-color obj color)` | Set the color of XYZ axis label text |
| `(set-trihedron-wireframe-color obj color)` | Set the wireframe color of the trihedron's attributes drawer. |
| `(show-trihedron ctx viewer &key corner size)` | Create, configure, and display a trihedron in one call |

### 3D Text

| Function | Description |
|----------|-------------|
| `(make-brep-font-from-file path size &optional face-id)` | Load a TrueType/OpenType font from a file path. Returns `brep-font` or nil. |
| `(make-brep-font-from-name name size &key aspect)` | Look up a system font by name. `aspect` is `:regular`, `:bold`, `:italic`, or `:bold-italic` (default `:regular`). Returns `brep-font` or nil. |
| `(brep-font-p obj)` | Predicate: returns t for `brep-font` objects, nil otherwise |
| `(make-text-shape font text &key h-align v-align position normal)` | Render text as a flat BRep shape. Supports optional `:position` `(x y z)` and `:normal` `(dx dy dz)` for arbitrary plane placement. Returns a `shape` or nil. |
| `(make-text-shape-3d font text depth &key h-align v-align position normal)` | Render and extrude text. Same position/normal args as `make-text-shape`. |
| `(make-text-shape-on-plane font text &key h-align v-align position normal)` | Convenience — explicit position/normal defaults for plane placement. |
| `(text-bounding-box font text &key h-align v-align)` | Query text extent without rendering. Returns `(values width height)` or nil. |
| `(list-available-fonts)` | Return a list of available system font name strings. |
| `(font-info name)` | Query font information (`:name`, `:key` plist) by name. |
| `(text-glyph-as-shape font codepoint)` | Render a single glyph by Unicode codepoint as a shape. |
| `(text-glyph-as-shape-3d font codepoint depth)` | Render and extrude a single glyph. |
| `(text-font-ascender font)` | Font ascender height above baseline. |
| `(text-font-descender font)` | Font descender depth below baseline. |
| `(text-font-line-spacing font)` | Default line spacing (baseline to baseline). |
| `(text-font-advance-x font c1 c2)` | Horizontal advance between two glyph codepoints (with kerning). |
| `(text-font-advance-y font c1 c2)` | Vertical advance between two glyph codepoints. |
| `(text-font-set-width-scaling font scale)` | Set glyph width scaling factor for subsequent rendering. |
| `(text-font-set-composite-curve-mode font bool)` | Toggle composite BSpline curves for glyph contours. |
| `(make-multi-line-text font text &key h-align v-align position normal line-spacing)` | Render multi-line text (split on `#\Newline`), lines stacked vertically by `line-spacing`. |
| `(make-formatted-text font text &key h-align v-align position normal line-spacing)` | Alias for `make-multi-line-text`. |
| `(make-ais-text-label text &key position color font height)` | Create an interactive 3D text label (`AIS_TextLabel`) for viewer display. Not exported to STL/STEP. |
| `(ais-text-label-p obj)` | Predicate for ais-text-label objects. |
| `(ais-free-text-label label)` | Free an ais-text-label's C handle. |

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

;; Per-glyph rendering
(let* ((font   (make-brep-font-from-name "Arial" 10.0))
       (glyphA (text-glyph-as-shape font (char-code #\A))))
  (write-step glyphA "glyph-A.step"))

;; Font metrics
(let* ((font (make-brep-font-from-name "Arial" 10.0)))
  (format t "Ascender: ~,2f  Descender: ~,2f  LineSpacing: ~,2f~%"
          (text-font-ascender font)
          (text-font-descender font)
          (text-font-line-spacing font)))

;; Interactive 3D text label (viewer only, not exported)
(with-viewer (v)
  (let* ((ctx   (ais-create-context v))
         (label (make-ais-text-label "My Label" :position '(0 0 0))))
    (ais-display ctx label)
    (fit-all v)))
```

### Interactive 3D Text Labels (Viewer)

| Function | Description |
|----------|-------------|
| `(make-ais-text-label text &key position color font height)` | Create an interactive 3D text label (`AIS_TextLabel`) for viewer display. Not exported to STL/STEP. |
| `(ais-text-label-p obj)` | Predicate for ais-text-label objects. |
| `(ais-free-text-label label)` | Free an ais-text-label's C handle. |

### Color System

| Function | Description |
|----------|-------------|
| `(named-color name)` | Look up a named color by keyword (e.g., `:red`, `:steel-blue`, `:gold`). Returns `(r g b)` or nil. |
| `(named-color-exists-p name)` | Check if a named color exists. |
| `(list-named-colors)` | Return a list of all ~160 named color keywords. |
| `(hex-to-rgb hex)` | Parse `#RRGGBB` or `#RGB` hex string. Returns `(r g b)` or nil. |
| `(normalize-color color)` | Accepts keyword, `(r g b)` list, `#RRGGBB` hex string, or `viewer-color` instance. Returns `(r g b)`. |
| `(make-color &key keyword rgb hls)` | Create a `viewer-color` instance. `:keyword` looks up a named color, `:rgb` takes `(r g b)`, `:hls` takes `(h l s)`. |
| `(viewer-color-p obj)` | Predicate for `viewer-color` instances. |
| `(color-rgb color)` | Get `(r g b)` from any color input type. |
| `(color-r c)` / `(color-g c)` / `(color-b c)` | Red, green, blue components from `viewer-color`. |
| `(color-name c)` | The keyword name of a `viewer-color` (or nil if unnamed). |
| `(color-delta c1 c2)` | Euclidean color difference between two colors (any input types). Returns nil on invalid input. |

Named colors include the standard X11/web color palette (`:alice-blue`, `:bisque`, `:crimson`, `:dark-olive-green`, `:gold`, `:indian-red`, `:khaki`, `:lavender`, `:medium-aquamarine`, `:navy`, `:olive-drab`, `:pale-goldenrod`, `:sienna`, `:tomato`, `:wheat`, etc.) plus numbered variants (`:blue-1`, `:gray-50`, `:orange-1`) and grey spellings (`:grey`, `:dark-grey`).

### XCAF Document Tools

Document-level metadata management for XCAF documents — layers, views, visual materials, clipping planes, and assembly editing.

| Function | Description |
|----------|-------------|
| `(make-xcaf-doc)` | Create a new XCAF document. Returns `xcaf-doc` or nil |
| `(xcaf-doc-p obj)` | Predicate for `xcaf-doc` instances |
| `(xcaf-free-doc doc)` | Free a document's C handle |
| `(xcaf-add-shape doc shape)` | Register a shape in the document's shape tree. Returns t or nil |
| `(xcaf-add-shape-to-layer doc shape layer)` | Assign a named layer to a shape. Returns t or nil |
| `(xcaf-remove-shape-from-layer doc shape layer)` | Remove a named layer from a shape. Returns t or nil |
| `(xcaf-get-shape-layers doc shape)` | Get layer names for a shape. Returns list of strings or nil |
| `(xcaf-has-material doc shape)` | Check if a shape has material density assigned. Returns t or nil |
| `(xcaf-add-view doc)` | Create a new named view. Returns t or nil |
| `(xcaf-get-views doc)` | List all views. Returns list of view plists or nil |
| `(xcaf-get-visual-material doc shape)` | Get visual material color for a shape. Returns plist `(:color (r g b) :alpha a)` or nil |
| `(xcaf-get-clipping-planes doc)` | List all clipping planes. Returns list of plane plists or nil |
| `(xcaf-expand-assembly doc)` | Expand all compound shapes to assemblies. Returns t or nil |

All functions accept nil for doc and return nil gracefully. Errors at the C level are available via `(get-error-message)`.

