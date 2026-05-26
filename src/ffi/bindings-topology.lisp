(in-package :cl-occt.impl)

(defcfun (%make-edge-line-2d "make_edge_line_2d") :pointer
  (x1 :double) (y1 :double)
  (x2 :double) (y2 :double))

(defcfun (%make-edge-line-3d "make_edge_line_3d") :pointer
  (x1 :double) (y1 :double) (z1 :double)
  (x2 :double) (y2 :double) (z2 :double))

(defcfun (%make-edge-circle-2d "make_edge_circle_2d") :pointer
  (x :double) (y :double)
  (radius :double))

(defcfun (%make-edge-arc-2d "make_edge_arc_2d") :pointer
  (x1 :double) (y1 :double)
  (x2 :double) (y2 :double)
  (x3 :double) (y3 :double))

(defcfun (%make-compound "make_compound") :pointer
  (shapes :pointer)
  (count :int))

(defcfun (%add-to-compound "add_to_compound") :pointer
  (compound :pointer)
  (shape :pointer))

(defcfun (%compound-is-empty "compound_is_empty") :int
  (shape :pointer))

(defcfun (%shape-is-compound "shape_is_compound") :int
  (shape :pointer))

(defcfun (%make-wire "make_wire") :pointer
  (edges :pointer)
  (count :int))

(defcfun (%make-face "make_face") :pointer
  (wire :pointer))

(defcfun (%make-face-on-plane "make_face_on_plane") :pointer
  (wire :pointer)
  (ox :double) (oy :double) (oz :double)
  (nx :double) (ny :double) (nz :double))

(defcfun (%free-shape-array "free_shape_array") :void
  (arr :pointer))

(defcfun (%face-edges "face_edges") :int
  (face :pointer)
  (out-edges :pointer)
  (out-count :pointer))

(defcfun (%edge-vertices "edge_vertices") :int
  (edge :pointer)
  (out-start :pointer)
  (out-end :pointer))

(defcfun (%vertex-edges "vertex_edges") :int
  (vertex :pointer)
  (parent :pointer)
  (out-edges :pointer)
  (out-count :pointer))

(defcfun (%edge-faces "edge_faces") :int
  (edge :pointer)
  (parent :pointer)
  (out-faces :pointer)
  (out-count :pointer))

(defcfun (%face-wires "face_wires") :int
  (face :pointer)
  (out-wires :pointer)
  (out-count :pointer))

(defcfun (%wire-edges "wire_edges") :int
  (wire :pointer)
  (out-edges :pointer)
  (out-count :pointer))

(defcfun (%shape-type-int "shape_type_int") :int
  (shape :pointer))

(defcfun (%shape-orientation-int "shape_orientation_int") :int
  (shape :pointer))
