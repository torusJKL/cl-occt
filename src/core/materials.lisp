(in-package :cl-occt)

;; --- PBR Material ---

(defclass pbr-material ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_PBRMaterial handle with GC via tg:finalize."))

(defun pbr-material-p (obj)
  "Returns `t` if **obj** is a `pbr-material` instance."
  (typep obj 'pbr-material))

(defun make-pbr-material ()
  "Create a `Graphic3d_PBRMaterial` with default values.
Returns a `pbr-material` instance or nil.

**Example:**
    (make-pbr-material)"
  (let* ((ptr (%make-pbr-material))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'pbr-material :handle ptr))))
    (when obj
      (tg:finalize obj (lambda () (%free-pbr-material (%handle obj)))))
    obj))

(defun set-pbr-albedo (mat r g b)
  "Set the albedo (base color) of a PBR material. RGB values in [0,1].

**Example:**
    (set-pbr-albedo mat 1.0 0.0 0.0)"
  (when (pbr-material-p mat)
    (let ((ptr (%handle mat)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%pbr-material-set-albedo ptr
          (coerce r 'double-float)
          (coerce g 'double-float)
          (coerce b 'double-float))))))

(defun set-pbr-metallic (mat v)
  "Set the metalness of a PBR material. **v** in [0,1] (0 = dielectric, 1 = metal).

**Example:**
    (set-pbr-metallic mat 0.0)"
  (when (pbr-material-p mat)
    (let ((ptr (%handle mat)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%pbr-material-set-metallic ptr (coerce v 'double-float))))))

(defun set-pbr-roughness (mat v)
  "Set the roughness of a PBR material. **v** in [0,1] (0 = smooth, 1 = rough).

**Example:**
    (set-pbr-roughness mat 0.3)"
  (when (pbr-material-p mat)
    (let ((ptr (%handle mat)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%pbr-material-set-roughness ptr (coerce v 'double-float))))))

(defun set-pbr-emissive (mat r g b)
  "Set the emissive color. RGB values in [0,1].

**Example:**
    (set-pbr-emissive mat 1.0 0.5 0.0)"
  (when (pbr-material-p mat)
    (let ((ptr (%handle mat)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%pbr-material-set-emissive ptr
          (coerce r 'double-float)
          (coerce g 'double-float)
          (coerce b 'double-float))))))

(defun set-pbr-ior (mat v)
  "Set the index of refraction. **v** >= 1.0.

**Example:**
    (set-pbr-ior mat 1.5)"
  (when (pbr-material-p mat)
    (let ((ptr (%handle mat)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%pbr-material-set-refraction-index ptr (coerce v 'double-float))))))

(defun set-pbr-transparency (mat v)
  "Set the transparency factor. **v** in [0,1].

**Example:**
    (set-pbr-transparency mat 0.5)"
  (when (pbr-material-p mat)
    (let ((ptr (%handle mat)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%pbr-material-set-transparency ptr (coerce v 'double-float))))))

;; --- BSDF Material ---

(defclass bsdf ()
  ((%handle :initarg :handle :reader %handle))
  (:documentation "Wraps a Graphic3d_BSDF handle with GC via tg:finalize."))

(defun bsdf-p (obj)
  "Returns `t` if **obj** is a `bsdf` instance."
  (typep obj 'bsdf))

(defun make-bsdf ()
  "Create a `Graphic3d_BSDF` with default values.
Returns a `bsdf` instance or nil.

**Example:**
    (make-bsdf)"
  (let* ((ptr (%make-bsdf))
         (obj (when (and ptr (not (cffi:null-pointer-p ptr)))
                (make-instance 'bsdf :handle ptr))))
    (when obj
      (tg:finalize obj (lambda () (%free-bsdf (%handle obj)))))
    obj))

(defun set-bsdf-ambient (bsdf r g b)
  "Set the ambient color of a BSDF material. RGB in [0,1].

**Example:**
    (set-bsdf-ambient bsdf 0.2 0.2 0.2)"
  (when (bsdf-p bsdf)
    (let ((ptr (%handle bsdf)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%bsdf-set-ambient ptr
          (coerce r 'double-float)
          (coerce g 'double-float)
          (coerce b 'double-float))))))

(defun set-bsdf-diffuse (bsdf r g b)
  "Set the diffuse color of a BSDF material. RGB in [0,1].

**Example:**
    (set-bsdf-diffuse bsdf 0.8 0.8 0.8)"
  (when (bsdf-p bsdf)
    (let ((ptr (%handle bsdf)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%bsdf-set-diffuse ptr
          (coerce r 'double-float)
          (coerce g 'double-float)
          (coerce b 'double-float))))))

(defun set-bsdf-specular (bsdf r g b)
  "Set the specular color of a BSDF material. RGB in [0,1].

**Example:**
    (set-bsdf-specular bsdf 1.0 1.0 1.0)"
  (when (bsdf-p bsdf)
    (let ((ptr (%handle bsdf)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%bsdf-set-specular ptr
          (coerce r 'double-float)
          (coerce g 'double-float)
          (coerce b 'double-float))))))

(defun set-bsdf-transmission (bsdf r g b)
  "Set the transmission color of a BSDF material. RGB in [0,1].

**Example:**
    (set-bsdf-transmission bsdf 0.9 0.9 1.0)"
  (when (bsdf-p bsdf)
    (let ((ptr (%handle bsdf)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%bsdf-set-transmission ptr
          (coerce r 'double-float)
          (coerce g 'double-float)
          (coerce b 'double-float))))))

(defun set-bsdf-reflection (bsdf r g b)
  "Set the reflection color of a BSDF material. RGB in [0,1].

**Example:**
    (set-bsdf-reflection bsdf 1.0 1.0 1.0)"
  (when (bsdf-p bsdf)
    (let ((ptr (%handle bsdf)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%bsdf-set-reflection ptr
          (coerce r 'double-float)
          (coerce g 'double-float)
          (coerce b 'double-float))))))

(defun set-bsdf-refraction-index (bsdf v)
  "Set the index of refraction. **v** >= 1.0.

**Example:**
    (set-bsdf-refraction-index bsdf 2.42)"
  (when (bsdf-p bsdf)
    (let ((ptr (%handle bsdf)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%bsdf-set-refraction-index ptr (coerce v 'double-float))))))

(defun set-bsdf-absorption (bsdf r g b coeff)
  "Set the absorption color and coefficient. RGB in [0,1], coefficient >= 0.

**Example:**
    (set-bsdf-absorption bsdf 0.0 1.0 0.0 0.5)"
  (when (bsdf-p bsdf)
    (let ((ptr (%handle bsdf)))
      (when (and ptr (not (cffi:null-pointer-p ptr)))
        (%bsdf-set-absorption ptr
          (coerce r 'double-float)
          (coerce g 'double-float)
          (coerce b 'double-float)
          (coerce coeff 'double-float))))))
