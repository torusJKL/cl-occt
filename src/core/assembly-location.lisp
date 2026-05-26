(in-package :cl-occt)

(defun make-location (dx dy dz)
  "Create a location (transformation) from a translation vector (dx dy dz).

  Returns an opaque location handle, or nil on failure.

  **Example:**

      (make-location 10 20 30)

  **See also:** `compose-locations`, `invert-location`, `move-shape`"
  (let ((ptr (%location-from-translation (coerce dx 'double-float)
                                         (coerce dy 'double-float)
                                         (coerce dz 'double-float))))
    (if (cffi:null-pointer-p ptr)
        nil
        ptr)))

(defun compose-locations (loc1 loc2)
  "Compose two locations (multiply transformations).

  Returns a new location representing **loc1** followed by **loc2**.
  Returns nil if either argument is nil.

  **See also:** `make-location`, `invert-location`"
  (if (or (null loc1) (null loc2))
      nil
      (%location-multiply loc1 loc2)))

(defun invert-location (loc)
  "Return the inverse of a location transformation.

  Returns nil if **loc** is nil.

  **See also:** `make-location`, `compose-locations`"
  (if (null loc)
      nil
      (%location-inverted loc)))

(defun shape-location (shape)
  "Get the location (transformation) applied to a **shape**.

  Returns an opaque location handle, or nil if the shape has no
  location or **shape** is nil.

  **See also:** `move-shape`, `make-location`"
  (if (null shape)
      nil
      (%shape-get-location (%ptr shape))))

(defun move-shape (shape location)
  "Apply a **location** transformation to **shape**, returning a new shape.

  The original shape is unchanged. Returns nil if either argument is nil.

  **Example:**

      (let ((loc (make-location 10 0 0)))
        (move-shape my-box loc))

  **See also:** `shape-location`, `make-location`, `compose-locations`"
  (if (or (null shape) (null location))
      nil
      (make-shape (%shape-moved (%ptr shape) location))))
