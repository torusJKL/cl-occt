(in-package :cl-occt)

;; --- Math Solver Callback Helper ---

(defvar *math-callback* nil
  "Internal storage for the current math objective function callback.")

(cffi:defcallback %math-obj-fn :double ((n :int) (x :pointer))
  (let ((fn *math-callback*)
        (vec (loop for i from 0 below n
                   collect (cffi:mem-aref x :double i))))
    (if fn
        (coerce (funcall fn vec) 'double-float)
        0.0d0)))

;; --- BFGS ---

(defun bfgs-minimize (fn initial &key (tolerance 1.0d-7) (max-iterations 200))
  "Minimize a multi-variate function using BFGS quasi-Newton method.

  **fn** is a function accepting a list of doubles and returning a double.
  **initial** is the starting point as a list of doubles.
  Returns a plist (:converged bool :iterations int :minimum-value double :minimizer list)
  or nil on failure."
  (when (and fn (listp initial))
    (let* ((n (length initial))
           (init-arr (cffi:foreign-alloc :double :count n))
           (min-arr (cffi:foreign-alloc :double :count n))
           (min-val (cffi:foreign-alloc :double))
           (iters (cffi:foreign-alloc :int)))
      (unwind-protect
           (progn
             (loop for i from 0 below n
                   do (setf (cffi:mem-aref init-arr :double i)
                            (coerce (nth i initial) 'double-float)))
             (let ((*math-callback* fn))
               (when (= 1 (%math-bfgs-minimize
                           (cffi:callback %math-obj-fn) n init-arr
                           (coerce tolerance 'double-float) max-iterations
                           min-arr min-val iters))
                 (list :converged t
                       :iterations (cffi:mem-aref iters :int)
                       :minimum-value (cffi:mem-aref min-val :double)
                       :minimizer (loop for i from 0 below n
                                        collect (cffi:mem-aref min-arr :double i))))))
        (cffi:foreign-free init-arr)
        (cffi:foreign-free min-arr)
        (cffi:foreign-free min-val)
        (cffi:foreign-free iters)))))

;; --- FRPR (Fletcher-Reeves Polak-Ribiere) ---

(defun frpr-minimize (fn initial &key (tolerance 1.0d-7) (max-iterations 200))
  "Minimize a multi-variate function using FRPR conjugate gradient method.

  Parameters and return format match `bfgs-minimize`."
  (when (and fn (listp initial))
    (let* ((n (length initial))
           (init-arr (cffi:foreign-alloc :double :count n))
           (min-arr (cffi:foreign-alloc :double :count n))
           (min-val (cffi:foreign-alloc :double))
           (iters (cffi:foreign-alloc :int)))
      (unwind-protect
           (progn
             (loop for i from 0 below n
                   do (setf (cffi:mem-aref init-arr :double i)
                            (coerce (nth i initial) 'double-float)))
             (let ((*math-callback* fn))
               (when (= 1 (%math-frpr-minimize
                           (cffi:callback %math-obj-fn) n init-arr
                           (coerce tolerance 'double-float) max-iterations
                           min-arr min-val iters))
                 (list :converged t
                       :iterations (cffi:mem-aref iters :int)
                       :minimum-value (cffi:mem-aref min-val :double)
                       :minimizer (loop for i from 0 below n
                                        collect (cffi:mem-aref min-arr :double i))))))
        (cffi:foreign-free init-arr)
        (cffi:foreign-free min-arr)
        (cffi:foreign-free min-val)
        (cffi:foreign-free iters)))))

;; --- PSO (Particle Swarm Optimization) ---

(defun pso-minimize (fn lower upper initial &key (n-particles 25) (max-iterations 100)
                                              (tolerance 1.0d-5))
  "Minimize a multi-variate function using Particle Swarm Optimization.

  **fn** accepts a list of doubles and returns a double.
  **lower** and **upper** are bound lists. **initial** is the starting point.
  Returns plist or nil."
  (when (and fn (listp lower) (listp upper) (listp initial)
             (= (length lower) (length upper) (length initial)))
    (let* ((n (length initial))
           (low-arr (cffi:foreign-alloc :double :count n))
           (upp-arr (cffi:foreign-alloc :double :count n))
           (init-arr (cffi:foreign-alloc :double :count n))
           (min-arr (cffi:foreign-alloc :double :count n))
           (min-val (cffi:foreign-alloc :double))
           (iters (cffi:foreign-alloc :int)))
      (unwind-protect
           (progn
             (loop for i from 0 below n
                   do (setf (cffi:mem-aref low-arr :double i) (coerce (nth i lower) 'double-float)
                            (cffi:mem-aref upp-arr :double i) (coerce (nth i upper) 'double-float)
                            (cffi:mem-aref init-arr :double i) (coerce (nth i initial) 'double-float)))
             (let ((*math-callback* fn))
               (when (= 1 (%math-pso-minimize
                           (cffi:callback %math-obj-fn) n
                           low-arr upp-arr init-arr
                           n-particles max-iterations (coerce tolerance 'double-float)
                           min-arr min-val iters))
                 (list :converged t
                       :iterations (cffi:mem-aref iters :int)
                       :minimum-value (cffi:mem-aref min-val :double)
                       :minimizer (loop for i from 0 below n
                                        collect (cffi:mem-aref min-arr :double i))))))
        (cffi:foreign-free low-arr)
        (cffi:foreign-free upp-arr)
        (cffi:foreign-free init-arr)
        (cffi:foreign-free min-arr)
        (cffi:foreign-free min-val)
        (cffi:foreign-free iters)))))

;; --- GlobOptMin (Global Optimization) ---

(defun globoptmin-minimize (fn lower upper &key (tolerance 1.0d-7) (max-iterations 100))
  "Minimize a multi-variate function using math_GlobOptMin global optimizer.

  Parameters and return format match `pso-minimize` (without initial guess and n-particles).
  Returns plist or nil."
  (when (and fn (listp lower) (listp upper)
             (= (length lower) (length upper)))
    (let* ((n (length lower))
           (low-arr (cffi:foreign-alloc :double :count n))
           (upp-arr (cffi:foreign-alloc :double :count n))
           (min-arr (cffi:foreign-alloc :double :count n))
           (min-val (cffi:foreign-alloc :double))
           (iters (cffi:foreign-alloc :int)))
      (unwind-protect
           (progn
             (loop for i from 0 below n
                   do (setf (cffi:mem-aref low-arr :double i) (coerce (nth i lower) 'double-float)
                            (cffi:mem-aref upp-arr :double i) (coerce (nth i upper) 'double-float)))
               (let ((*math-callback* fn))
                (when (= 1 (%math-globoptmin-minimize
                            (cffi:callback %math-obj-fn) n
                            low-arr upp-arr
                            (coerce tolerance 'double-float) max-iterations
                            min-arr min-val iters))
                  (list :converged t
                        :iterations (cffi:mem-aref iters :int)
                        :minimum-value (cffi:mem-aref min-val :double)
                        :minimizer (loop for i from 0 below n
                                         collect (cffi:mem-aref min-arr :double i))))))
        (cffi:foreign-free low-arr)
        (cffi:foreign-free upp-arr)
        (cffi:foreign-free min-arr)
        (cffi:foreign-free min-val)
        (cffi:foreign-free iters)))))

;; --- 1D Math Solver Callback Helper ---

(defvar *math-1d-callback* nil
  "Internal storage for the current 1D math function callback.")

(cffi:defcallback %math-1d-fn :double ((x :double))
  (let ((fn *math-1d-callback*))
    (if fn
        (coerce (funcall fn x) 'double-float)
        0.0d0)))

;; --- function-root (BissecNewton) ---

(defun function-root (fn x0 x1 &key (ftol 1.0d-7) (max-iterations 100))
  "Find a root of a 1D function in the interval [X0, X1] using BissecNewton.

  Returns a plist (:converged t :root double :iterations int) or nil on failure."
  (when fn
    (let ((out-root (cffi:foreign-alloc :double))
          (out-iters (cffi:foreign-alloc :int)))
      (unwind-protect
           (let ((*math-1d-callback* fn))
             (when (= 1 (%math-function-root
                         (cffi:callback %math-1d-fn)
                         (coerce x0 'double-float)
                         (coerce x1 'double-float)
                         (coerce ftol 'double-float)
                         max-iterations
                         out-root out-iters))
               (list :converged t
                     :root (cffi:mem-aref out-root :double)
                     :iterations (cffi:mem-aref out-iters :int))))
        (cffi:foreign-free out-root)
        (cffi:foreign-free out-iters)))))

;; --- newton-minimum (NewtonMinimum) ---

(defun newton-minimum (fn x0 &key (tolerance 1.0d-7) (max-iterations 100))
  "Find a minimum of a 1D function starting from X0 using NewtonMinimum.

  Returns a plist (:converged t :min-x double :min-value double :iterations int)
  or nil on failure."
  (when fn
    (let ((out-min-x (cffi:foreign-alloc :double))
          (out-min-val (cffi:foreign-alloc :double))
          (out-iters (cffi:foreign-alloc :int)))
      (unwind-protect
           (let ((*math-1d-callback* fn))
             (when (= 1 (%math-newton-minimum
                         (cffi:callback %math-1d-fn)
                         (coerce x0 'double-float)
                         (coerce tolerance 'double-float)
                         max-iterations
                         out-min-x out-min-val out-iters))
               (list :converged t
                     :min-x (cffi:mem-aref out-min-x :double)
                     :min-value (cffi:mem-aref out-min-val :double)
                     :iterations (cffi:mem-aref out-iters :int))))
        (cffi:foreign-free out-min-x)
        (cffi:foreign-free out-min-val)
        (cffi:foreign-free out-iters)))))
