(in-package :cl-occt.impl)

;; --- Mechanical Features (BRepFeat) ---

(defcfun (%make-cylindrical-hole "make_cylindrical_hole") :pointer
  (shape :pointer)
  (face :pointer)
  (radius :double)
  (depth :double)
  (through :int))

(defcfun (%make-prism-feature "make_prism_feature") :pointer
  (shape :pointer)
  (base-face :pointer)
  (profile :pointer)
  (height :double)
  (dx :double) (dy :double) (dz :double)
  (operation :int))

(defcfun (%make-revol-feature "make_revol_feature") :pointer
  (shape :pointer)
  (base-face :pointer)
  (profile :pointer)
  (ax :double) (ay :double) (az :double)
  (angle :double)
  (operation :int))

(defcfun (%make-pipe-feature "make_pipe_feature") :pointer
  (shape :pointer)
  (base-face :pointer)
  (profile :pointer)
  (path :pointer)
  (operation :int))

;; --- Local Operations (LocOpe) ---

(defcfun (%local-extrude "local_extrude") :pointer
  (face :pointer)
  (height :double)
  (dx :double) (dy :double) (dz :double))

(defcfun (%make-groove "make_groove") :pointer
  (shape :pointer)
  (face :pointer)
  (ax :double) (ay :double) (az :double)
  (angle :double))

(defcfun (%make-rib "make_rib") :pointer
  (shape :pointer)
  (profile :pointer)
  (thickness :double)
  (dx :double) (dy :double) (dz :double))

;; --- BOPAlgo Operations ---

(defcfun (%split-shape "split_shape") :pointer
  (shape :pointer)
  (tools :pointer)
  (num-tools :int))

(defcfun (%make-volume "make_volume") :pointer
  (shapes :pointer)
  (num-shapes :int))

(defcfun (%cells-builder "cells_builder") :pointer
  (shapes :pointer)
  (num-shapes :int)
  (operation :int)
  (selection :pointer)
  (sel-count :int))

;; --- BOPAlgo Utilities ---

(defcfun (%argument-analyzer "argument_analyzer") :string
  (shapes :pointer)
  (num-shapes :int))

(defcfun (%make-connected-shapes "make_connected_shapes") :pointer
  (shapes :pointer)
  (num-shapes :int))

(defcfun (%make-shape-periodic "make_shape_periodic") :pointer
  (shape :pointer)
  (dx :double) (dy :double) (dz :double))
