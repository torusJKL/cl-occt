(in-package :cl-occt)

(defun run-core-tests ()
  "Run tests that do not require an X display (geometry, I/O, DAG, colors, text shapes)."
  (setq *test-result* (make-test-result))
  (let ((*params* nil))
    (format t "~&=== cl-occt core tests (no display needed) ===~2%")
    (dolist (test-sym
             '(set-background-cubemap-creation set-cube-map-alias
               make-box-valid make-box-zero-dim make-box-negative
               make-cylinder-valid make-sphere-valid make-cone-valid
               make-torus-valid make-torus-zero-major make-torus-zero-minor
               make-prism-zero-vector make-prism-nil-shape
               make-revol-zero-angle make-revol-nil-shape
               shape-distinct
               make-pnt2d-valid make-vec2d-valid make-dir2d-valid make-dir2d-zero
               make-line2d-valid make-circle2d-valid make-circle2d-zero-radius
               make-edge-valid make-edge-3d-valid make-circle-edge-valid
               make-circular-arc-valid make-circular-arc-collinear
               make-wire-two-edges make-wire-empty
               make-face-square make-face-nil make-face-on-plane-valid
               cut-two-boxes cut-nil-first cut-nil-second
               fuse-two-boxes common-overlap common-no-overlap
               boolean-variadic
               section-intersecting-boxes section-non-intersecting
               section-nil-first section-nil-second
               section-variadic section-solid-plane
               face-cut-overlapping face-fuse-overlapping
               face-common-overlapping face-common-no-overlap face-cut-nil
               translate-shape translate-preserves-original translate-nil
               rotate-shape
               write-step-valid write-step-nil
               read-step-roundtrip read-step-nonexistent read-step-corrupted
               write-stl-valid write-stl-nil
               read-stl-roundtrip read-stl-nonexistent read-stl-corrupted write-stl-deflection
               make-compound-two-boxes make-compound-skips-nil
               make-compound-all-nil make-compound-empty-list
               add-to-compound-valid add-to-compound-nil-shape add-to-compound-nil-compound
               compound-shape-p-returns-t compound-shape-p-returns-nil-for-simple-shape
               compound-shape-p-returns-nil-for-nil
               write-stl-compound write-stl-empty-compound
               make-part-valid make-assembly-valid
               assembly-leaf-predicate assembly-branch-predicate
               assembly-setf-name assembly-setf-color assembly-setf-children
               assembly-color-components assembly-no-color assembly-no-name
               write-step-assembly-valid write-step-assembly-nil
               read-step-assembly-nonexistent read-step-assembly-roundtrip
                read-step-assembly-multi-part read-step-assembly-nested
                write-iges-valid write-iges-nil
                read-iges-roundtrip read-iges-nonexistent
                write-iges-assembly-valid write-iges-assembly-nil
                read-iges-assembly-nonexistent read-iges-assembly-roundtrip
                write-obj-valid write-obj-nil
                read-obj-roundtrip read-obj-nonexistent
                write-obj-with-coordsys write-obj-per-vertex-colors
                write-vrml-valid write-vrml-nil write-vrml-deflection
                write-gltf-valid write-gltf-nil
                read-gltf-roundtrip read-gltf-nonexistent
                write-gltf-with-coordsys
                write-ply-valid write-ply-nil write-ply-with-coordsys

               ais-create-shape-from-box ais-create-shape-nil-shape
               ais-free-on-nil-safe ais-create-shape-nil-input
               make-trihedron-defaults make-trihedron-zero-normal
               make-light-ambient-valid make-light-directional-valid
               make-light-positional-valid make-light-spot-valid
               set-light-position-angle-concentration
               set-light-color-intensity set-light-direction-valid
               set-headlight-valid
                named-color-red named-color-blue named-color-white
               named-color-unknown named-color-exists-p-true named-color-exists-p-false
               hex-to-rgb-6-digit hex-to-rgb-3-digit hex-to-rgb-invalid
               normalize-color-keyword normalize-color-rgb-list normalize-color-hex
               make-color-from-keyword make-color-from-rgb make-color-from-hls
               color-delta-same color-delta-different color-delta-nil-input
               viewer-color-p-predicate list-named-colors-includes-red
               make-brep-font-from-file-valid
               make-brep-font-from-file-nonexistent
               make-brep-font-from-file-zero-size
               make-text-shape-valid
               make-text-shape-nil-font
               make-text-shape-empty-string
               make-text-shape-3d-valid
               make-text-shape-3d-nil-font
               make-text-shape-3d-zero-depth
               brep-font-p-valid
               brep-font-p-nil
               text-step-roundtrip
               text-stl-export
               text-shape-on-yz-plane
               text-shape-with-position-only
               text-shape-on-plane-convenience
               text-shape-3d-on-rotated-plane
               text-bounding-box-valid
               text-bounding-box-empty-string
               list-available-fonts-valid
               font-info-valid
               make-multi-line-text-valid
               make-multi-line-text-single-line
               make-formatted-text-valid
               make-ais-text-label-valid
               ais-text-label-predicate
               text-glyph-as-shape-valid
               text-glyph-as-shape-3d-valid
               text-font-ascender-valid
               text-font-descender-valid
               text-font-line-spacing-valid
               text-font-advance-x-valid
               text-font-advance-y-valid
               text-font-set-width-scaling-valid
               text-font-set-composite-curve-mode-valid
               write-step-skips-ais-label
               write-stl-skips-ais-label
                make-dimension-edge-keyword
                 make-line-3d-valid make-line-3d-zero-dir
                make-circle-3d-valid make-circle-3d-zero-radius
                make-ellipse-3d-valid make-ellipse-3d-zero-major
                make-hyperbola-valid
                make-parabola-valid make-parabola-zero-focal
                make-bezier-curve-valid
                make-bspline-curve-valid
                curve-type-line curve-type-circle curve-type-ellipse
                curve-type-bezier curve-type-bspline
                make-plane-valid make-plane-zero-normal
                make-cylindrical-surface-valid make-cylindrical-surface-zero-radius
                make-conical-surface-valid
                make-spherical-surface-valid make-spherical-surface-zero-radius
                make-toroidal-surface-valid
                surface-type-plane surface-type-cylindrical
                make-gc-line-valid make-gc-arc-of-circle-valid
                convert-curve-to-bspline-valid convert-surface-to-bspline-valid
                curve-bounding-box-valid surface-bounding-box-valid
                project-point-on-curve-valid project-point-on-surface-valid
                intersect-curves-valid intersect-curves-no-intersection
                intersect-curve-surface-valid
                points-to-bspline-valid points-to-bspline-degree
                interpolate-points-valid interpolate-points-with-tangents
                make-helix-curve-valid make-helix-curve-left-handed
                make-helix-curve-zero-radius
                make-helix-edge-valid make-helix-edge-zero-radius
                curve-gc-cancel-and-free curve-gc-cancel-and-free-bezier
                curve-gc-nil-ptr-skip-finalizer
                surface-gc-cancel-and-free surface-gc-cancel-and-free-cylinder
                surface-gc-nil-ptr-skip-finalizer
                gprops-volume-box gprops-volume-nil gprops-area-sphere
                gprops-com-box gprops-com-nil gprops-gprops-box
                gprops-gprops-nil gprops-inertia-box
                shape-analysis-distance shape-analysis-distance-nil
                shape-analysis-distance-extrema
                shape-analysis-point-in-solid-inside
                shape-analysis-point-in-solid-outside
                shape-analysis-point-in-solid-on
                shape-analysis-classify
                shape-analysis-valid-p shape-analysis-valid-p-nil
                shape-analysis-check
                topology-map-faces topology-map-edges topology-map-vertices
                topology-count-faces topology-count-edges
                topology-dump-shape topology-dump-shape-nil
                topology-make-vertex
                topology-make-polygon-closed topology-make-polygon-open
                topology-make-polygon-too-few-points
                topology-triangle-count topology-wire-order-check
                topology-edge->curve topology-face->surface
                topology-face-edges-box topology-face-edges-nil
                topology-edge-vertices-box topology-edge-vertices-nil
                topology-vertex-edges-box topology-vertex-edges-nil
                topology-edge-faces-box topology-edge-faces-nil
                topology-face-wires-box topology-face-wires-nil
                topology-wire-edges-box topology-wire-edges-nil
                topology-shape-type-box topology-shape-type-wire topology-shape-type-nil
                topology-orientation-face topology-orientation-nil
                topology-face-area-box topology-face-area-known topology-face-area-nil
                topology-edge-length-box topology-edge-length-nil
                topology-face-normal-box
                topology-face-surface-type-planar topology-edge-curve-type-linear
                topology-face-bounding-box topology-edge-bounding-box topology-subshape-bounding-box-vertex
                topology-face-center-box topology-shape-extent-along
                fillet-edge-constant fillet-edge-nil-shape
                fillet-edges-multiple fillet-edge-variable-valid
                fillet-wire-corner-valid fillet-wire-all-corners-valid
                chamfer-edge-constant chamfer-edge-nil-shape
                chamfer-edges-multiple chamfer-edge-asymmetric-valid
                chamfer-edge-on-face-valid
                blend-faces-valid make-blend-constant-valid
                fillet-edge-excessive-radius chamfer-edge-excessive-distance
                sweep-profile-circle-along-line
                sweep-profile-nil-profile sweep-profile-nil-spine
                sweep-profile-fixed-mode
                sweep-sections-two-sections
                sweep-sections-nil-spine sweep-sections-mismatched-counts
                sweep-with-aux-spine-valid sweep-with-aux-spine-nil
                loft-sections-two-wires loft-sections-nil
                loft-sections-solid-true loft-sections-ruled
                loft-sections-smooth loft-sections-three-wires
                fill-face-valid fill-face-nil
                 fill-n-sided-face-valid fill-n-sided-face-nil-edges
                 fill-n-sided-face-too-few fill-n-sided-face-curvature
                 shell-shape-box-single-face shell-shape-multiple-faces
                 shell-shape-outward-offset shell-shape-nil-shape
                  shell-shape-excessive-thickness
                  sew-shapes-two-boxes sew-shapes-nil-input
                  sew-shapes-empty-list sew-shapes-non-manifold
                  defeature-shape-remove-one-face defeature-shape-nil-shape
                  defeature-shape-nil-faces defeature-shape-empty-faces
                  check-shape-validity-valid check-shape-validity-nil
                  boolean-builder-fuse boolean-builder-cut boolean-builder-common
                  boolean-builder-nil-first boolean-builder-nil-second
                  hlr-project-box hlr-project-nil
                  convert-to-revolution-cylinder convert-to-revolution-nil
                  convert-swept-to-elementary-cylinder convert-swept-to-elementary-nil
                  offset-shape-outward offset-shape-inward
                 offset-shape-arc-join offset-shape-intersection-join
                 offset-shape-excessive offset-shape-excessive-outward offset-shape-nil
                 offset-wire-outward offset-wire-inward offset-wire-nil
                 draft-face-valid draft-face-excessive-angle draft-face-nil-shape
                 make-evolved-valid make-evolved-with-offset make-evolved-nil-profile
                 make-cylindrical-hole-through make-cylindrical-hole-blind
                 make-cylindrical-hole-nil-shape make-cylindrical-hole-nil-depth
                 make-prism-feature-depression make-prism-feature-protrusion
                 make-prism-feature-nil
                 make-revol-feature-depression make-revol-feature-protrusion
                 make-revol-feature-nil
                 make-pipe-feature-depression make-pipe-feature-protrusion
                 make-pipe-feature-nil
                 local-extrude-valid local-extrude-nil
                 make-groove-valid make-groove-nil
                 make-rib-valid make-rib-nil
                 fix-shape-valid-box fix-shape-nil
                 fix-wire-valid fix-wire-nil
                 fix-solid-valid fix-solid-nil
                 fix-edge-valid fix-edge-nil
                 fix-face-valid fix-face-nil
                 shape-analysis-free-edges-valid shape-analysis-free-edges-nil
                 shape-analysis-check-intersections-valid shape-analysis-check-intersections-nil
                 shape-analysis-wire-contains-p-valid shape-analysis-wire-contains-p-outside shape-analysis-wire-contains-p-nil
                 shape-analysis-contents-valid shape-analysis-contents-nil
                 substitute-shape-single-valid substitute-shape-nil-shape substitute-shape-batch-valid
                 shape-to-nurbs-valid shape-to-nurbs-nil
                 shape-reduce-degree-valid shape-reduce-degree-nil
                 shape-to-rational-bspline-valid shape-to-rational-bspline-nil
                 shape-split-u-valid shape-split-u-nil
                 shape-upgrade-continuity-valid shape-upgrade-continuity-nil
                 apply-shape-process-single-valid apply-shape-process-sequence-valid apply-shape-process-nil
                  heal-shape-valid heal-shape-nil
                  fix-shaped-nil-input-all
                make-colored-shape-from-box make-colored-shape-nil-shape
                make-manipulator-created make-manipulator-set-position make-manipulator-set-size
                make-connected-interactive-from-shape make-connected-interactive-nil
                make-point-cloud-valid make-point-cloud-nil make-point-cloud-empty
                make-ais-plane-valid make-ais-axis-valid make-ais-line-valid make-ais-circle-valid
                make-view-cube-created make-view-cube-set-size make-view-cube-set-corner
                make-color-scale-created make-color-scale-set-range make-color-scale-set-size
                make-color-scale-set-title make-color-scale-set-intervals
                 make-multiple-connected-created make-multiple-connected-connect
                 make-triangulation-valid
                 mesh-shape-default mesh-shape-custom-deflection
                 mesh-shape-custom-angle mesh-shape-relative mesh-shape-nil
                 mesh-get-vertices-valid mesh-get-triangles-valid
                 mesh-get-triangle-count-valid mesh-get-vertices-unmeshed
                 mesh-get-vertices-nil
                 mesh-triangle-adjacent-valid mesh-triangle-elements-valid
                 mesh-triangle-elements-out-of-range
                 write-stl-angle-param write-stl-relative-param
                 meshvs-create-mesh-valid meshvs-create-mesh-nil-input
                 meshvs-free-valid meshvs-free-nil
                 make-xcaf-doc-valid xcaf-add-shape-t xcaf-add-shape-to-layer-t
                 xcaf-add-view-t xcaf-nil-doc-nil xcaf-remove-shape-from-layer-t
                 xcaf-get-visual-material-t xcaf-get-clipping-planes-t
                   xcaf-expand-assembly-t
                   ;; XCAF DimTol tests
                   xcaf-dimtol-linear-dimension-on-box-face
                   xcaf-dimtol-linear-dimension-nil-doc
                   xcaf-dimtol-linear-dimension-nil-shape
                   xcaf-dimtol-linear-dimension-too-few-points
                   xcaf-dimtol-angular-dimension-on-edges
                   xcaf-dimtol-angular-dimension-nil-input
                   xcaf-dimtol-diameter-dimension-on-cylinder
                   xcaf-dimtol-diameter-dimension-nil-input
                   xcaf-dimtol-tolerance-flatness
                   xcaf-dimtol-tolerance-position-with-modifiers
                   xcaf-dimtol-tolerance-nil-input
                   xcaf-dimtol-datum-single
                   xcaf-dimtol-datum-compound
                   xcaf-dimtol-datum-nil-input
                   xcaf-dimtol-geometric-tolerance-position-with-datum
                   xcaf-dimtol-geometric-tolerance-nil-input
                   xcaf-dimtol-step-roundtrip
                   xcaf-dimtol-get-dimensions-after-add
                   xcaf-dimtol-get-dimensions-nil-input
                    ;; Animation (core)
                   animation-make-valid animation-make-nil-name
                   animation-free-nil-safe animation-free-double-safe
                   animation-duration-set-get animation-progress-set-get
                   animation-start-pause-set
                   animation-add-remove-child
                   ;; Graphic3d ClipPlane (core)
                   clip-plane-make-valid clip-plane-make-with-equation
                   clip-plane-free-nil-safe clip-plane-free-double-safe
                   clip-plane-p-nil clip-plane-p-non-plane
                   clip-plane-set-equation clip-plane-get-equation
                   clip-plane-set-on-off clip-plane-set-capping
                   ;; Graphic3d ShaderProgram (core)
                   shader-program-make-valid
                   shader-program-free-nil-safe shader-program-free-double-safe
                   shader-program-set-vertex-source
                   shader-program-set-fragment-source
                   shader-program-set-header
                   ;; Graphic3d Aspects (core)
                   aspect-fill-area-make-valid aspect-fill-area-free-nil-safe
                   aspect-fill-area-get-color
                   aspect-line-make-valid aspect-line-get-color
                   aspect-marker-make-valid aspect-marker-get-type
                    aspect-text-make-valid aspect-text-get-font
                    ;; Prs3d Tools & Primitives
                    prs3d-cylinder-mesh-valid prs3d-cylinder-mesh-nil-radius
                    prs3d-sphere-mesh-valid prs3d-sphere-mesh-nil-radius
                    prs3d-torus-mesh-valid prs3d-torus-mesh-nil-radius
                    prs3d-disk-mesh-valid prs3d-disk-mesh-annular
                    prs3d-disk-mesh-nil-outer
                    prs3d-triangulation-accessors
                    prs3d-triangulation-free-nil-safe
                    prs3d-arrow-valid prs3d-arrow-nil-input
                    prs3d-bndbox-valid prs3d-bndbox-nil-input
                    shape-bounding-box-display-valid shape-bounding-box-display-nil
                    ;; Math Optimization
                    bfgs-minimize-quadratic-1d bfgs-minimize-nil-input
                    frpr-minimize-quadratic-2d frpr-minimize-nil-input
                    pso-minimize-quadratic-1d pso-minimize-nil-input
                    globoptmin-minimize-quadratic-1d globoptmin-minimize-nil-input
                    ;; IntTools Intersection
                    inttools-edge-edge-intersecting inttools-edge-edge-disjoint
                    inttools-edge-edge-nil-input
                    inttools-edge-face-intersecting inttools-edge-face-disjoint
                    inttools-edge-face-nil-input
                     inttools-face-face-intersecting inttools-face-face-disjoint
                     inttools-face-face-nil-input
                     ;; BOPAlgo operations
                     split-shape-box-by-plane split-shape-multiple-tools split-shape-nil-shape
                     make-volume-two-shells make-volume-nil-input
                     cells-builder-select-all cells-builder-with-selection cells-builder-nil-input
                     argument-analyzer-valid-shapes argument-analyzer-nil-input
                      make-connected-two-boxes make-connected-nil-input
                      make-periodic-box-along-x make-periodic-nil-shape
                      ;; BRepExtrema + BRepLProp analysis tests
                      brep-proximity-near-boxes brep-proximity-nil-input brep-proximity-far-shapes
                      brep-overlap-overlapping brep-overlap-non-overlapping brep-overlap-nil-input
                      brep-overlap-detail-overlapping brep-overlap-detail-non-overlapping brep-overlap-detail-nil-input
                      brep-self-intersect-valid-box brep-self-intersect-nil-input
                      brep-face-distance-parallel brep-face-distance-nil-input
                      brep-curve-tangent-line brep-curve-tangent-nil-input
                      brep-curve-curvature-circle brep-curve-curvature-nil-input
                      brep-surface-normal-plane brep-surface-normal-nil-input
                      brep-surface-curvature-sphere brep-surface-curvature-nil-input
                      brep-face-normal-valid brep-face-normal-nil-input
                       brep-face-curvature-valid brep-face-curvature-nil-input
                       ;; FairCurve + GeomPlate tests
                       fair-curve-batten-3-points fair-curve-batten-with-tangents
                       fair-curve-batten-free-ends fair-curve-batten-nil-input
                       fair-curve-batten-too-few
                       fair-curve-minvar-3-points fair-curve-minvar-with-slopes
                       fair-curve-minvar-nil-input fair-curve-minvar-too-few
                       fill-surface-from-4-curves fill-surface-from-curves-g1
                       fill-surface-from-curves-too-few                        fill-surface-from-curves-nil-input
                       ;; OCAF tests
                       ocaf-create-doc-valid
                       ocaf-root-label-depth
                       ocaf-find-label-creates-child
                       ocaf-find-label-existing
                       ocaf-label-children-returns-list
                       ocaf-label-children-empty
                       ocaf-label-tag-returns-tag
                       ocaf-label-depth-returns-depth
                       ocaf-begin-commit-transaction-works
                       ocaf-undo-transaction-callable
                       ocaf-integer-set-get-works
                       ocaf-integer-has-p-works
                       ocaf-real-set-get-works
                       ocaf-real-has-p-works
                       ocaf-string-set-get-works
                       ocaf-string-has-p-works
                       ocaf-name-set-get-works
                       ocaf-name-shape-primitive-works
                       ocaf-named-shape-not-deleted
                       ocaf-add-function-valid-works))
      (funcall test-sym))
    (format t "~2&=== Core results: ~D pass, ~D fail, ~D errors ===~%"
            (test-result-pass *test-result*)
            (test-result-fail *test-result*)
            (test-result-errors *test-result*))
    (values (test-result-pass *test-result*)
            (test-result-fail *test-result*))))

(defun run-viewer-tests ()
  "Run tests that require an X display (viewer, AIS, rendering, camera, grid, lighting)."
  (setq *test-result* (make-test-result))
  (let ((*params* nil))
    (format t "~&=== cl-occt viewer tests (display required) ===~2%")
    (dolist (test-sym
             '(make-viewer-returns-viewer with-viewer-creates-and-cleans-up
               free-viewer-nil-safe
               ais-create-context-returns-ais-context
               ais-display-shape-in-context
               ais-displayed-p-returns-t-after-display
               ais-erase-hides-without-removing
               ais-remove-removes-from-context
               set-background-valid
               ais-set-color-on-displayed-shape
               ais-set-display-mode-wireframe
               set-view-projection-iso
               set-msaa-roundtrip
               set-antialiasing-roundtrip
               activate-grid-rectangular-lines
               activate-grid-circular-points
               set-trihedron-mode-shaded
               set-trihedron-arrows-nil
               set-trihedron-size-100
               set-trihedron-corner-lower-right
               show-trihedron-in-context
               set-trihedron-axis-colors-red-blue-green
               set-trihedron-axis-colors-partial
               set-trihedron-text-color-white
               set-trihedron-text-color-nil-tri
               ais-set-transparency-valid ais-set-transparency-zero
               ais-set-material-gold ais-set-material-plastic ais-set-material-unknown
               ais-set-line-width-valid
               ais-show-edges-valid ais-set-edge-styling-color
               ais-set-selection-mode-face ais-set-selection-mode-nil
               ais-set-tessellation-valid
               make-material-valid ais-set-custom-material-valid
               viewer-add-and-toggle-light
               viewer-default-lights-valid
               grid-active-p-after-activate grid-active-p-after-deactivate
               set-gradient-background-valid set-gradient-background-style
               reset-background-valid
               set-computed-mode-toggle set-back-face-model-valid
               set-frustum-culling-valid set-transparency-method-valid redraw-view-valid
               set-immediate-update-valid
               set-text-label-angle-valid set-text-label-hjustification-valid
               set-text-label-vjustification-valid set-text-label-subtitle-color-valid
               set-text-label-display-type-valid
               make-text-label-convenience
               set-default-background-valid set-default-projection-valid
               set-default-view-size-valid set-default-view-type-valid
               set-default-bg-gradient-valid
               set-rectangular-grid-values-valid set-grid-xy-size-valid
               set-grid-offset-valid grid-display-valid
               ais-set-drawer-line-color-valid ais-set-drawer-line-width-valid ais-set-drawer-line-type-valid
               ais-set-drawer-point-color-valid ais-set-drawer-point-type-valid ais-set-drawer-point-scale-valid
               ais-set-drawer-text-color-valid ais-set-drawer-text-font-valid ais-set-drawer-text-height-valid
               ais-set-drawer-iso-display-valid ais-set-drawer-wire-color-valid
               ais-set-drawer-shading-color-valid
               ais-set-drawer-face-boundaries-valid ais-set-drawer-free-boundaries-valid
               set-camera-eye-target-up set-camera-partial-eye-only
               set-perspective-toggles
               set-fov-valid set-fov-zero
               set-clip-planes-valid
               reset-view-valid fit-all-shape-valid
               viewer-camera-predicate
               viewer-camera-roundtrip
               viewer-lights-and-active
               set-trihedron-wireframe-color-valid
               set-default-gradient-alias
               set-default-lights-modes
               set-grid-color-convenience
               set-grid-size-convenience
               grid-getter-stubs
               ais-set-selection-mode-keywords
               selection-baseline-zero
               selection-set-selected
               selection-clear-selected
               selection-is-selected
               selection-add-or-remove
                selection-selected-objects
                selection-selected-shapes
                selection-hilight
                make-edge-filter-valid
                make-face-filter-valid
                make-shape-type-filter-valid
                filter-predicates-nil-on-null
                filter-add-to-context
                filter-set-edge-type-valid
                filter-set-face-type-valid
                filter-free-explicit
                entity-owner-selected-owner
                entity-owner-priority-valid
                brep-owner-shape-extraction
                owner-free-explicit
                set-text-label-align-convenience
                set-transparent-shading-alias
                make-length-dimension-2p make-angle-dimension-3p
                set-dimension-text-position-valid set-dimension-units-valid
                set-dimension-arrow-length-valid set-dimension-extension-size-valid
                set-dimension-custom-value-valid
                set-dimension-text-alias
                set-dimension-arrows-convenience
                set-dimension-extension-convenience
                 ;; Animation (needs viewer)
                 animation-object-make-valid animation-axis-rotation-make-valid
                 ;; Graphic3d Structure (needs viewer)
                 graphic-structure-make-valid graphic-structure-free-nil-safe
                 graphic-structure-free-double-safe graphic-structure-set-visible
                 graphic-structure-display-erase graphic-structure-add-remove-child
                 ;; Graphic3d Group (needs viewer)
                 graphic-group-make-valid graphic-group-set-visible
                 graphic-group-add-primitives graphic-group-add-triangles-valid
                 graphic-group-set-aspect
                 ;; Graphic3d RenderingParams (needs viewer)
                 viewer-rendering-params-valid rendering-params-method-roundtrip
                 rendering-params-shadows-toggle
                 rendering-params-reflections-toggle
                 rendering-params-antialiasing-toggle))
      (funcall test-sym))
    (format t "~2&=== Viewer results: ~D pass, ~D fail, ~D errors ===~%"
            (test-result-pass *test-result*)
            (test-result-fail *test-result*)
            (test-result-errors *test-result*))
    (values (test-result-pass *test-result*)
            (test-result-fail *test-result*))))

(defun run-tests ()
  "Run all tests (core + viewer). For viewer tests an X display is required."
  (let ((core-pass 0) (core-fail 0)
        (viewer-pass 0) (viewer-fail 0))
    (multiple-value-setq (core-pass core-fail) (run-core-tests))
    (multiple-value-setq (viewer-pass viewer-fail) (run-viewer-tests))
    (format t "~2&=== All results: ~D pass, ~D fail, ~D errors ===~%"
            (+ core-pass viewer-pass)
            (+ core-fail viewer-fail)
            (test-result-errors *test-result*))
    (values (+ core-pass viewer-pass)
            (+ core-fail viewer-fail))))
