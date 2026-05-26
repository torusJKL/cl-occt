(in-package :cl-occt.impl)

;; --- Image / AlienPixMap ---

(defcfun (%image-from-file "image_from_file") :pointer
  (filename :string))

(defcfun (%free-image "free_image") :void
  (img :pointer))

(defcfun (%image-save "image_save") :int
  (img :pointer)
  (filename :string))

(defcfun (%image-width "image_width") :int
  (img :pointer))

(defcfun (%image-height "image_height") :int
  (img :pointer))

;; --- Texture 2D ---

(defcfun (%texture-2d-from-file "texture_2d_from_file") :pointer
  (filename :string))

(defcfun (%texture-2d-from-image "texture_2d_from_image") :pointer
  (img :pointer))

(defcfun (%free-texture "free_texture") :void
  (tex :pointer))

(defcfun (%texture-get-params "texture_get_params") :pointer
  (tex :pointer))

;; --- Texture 2D Plane ---

(defcfun (%texture-2dplane-from-file "texture_2dplane_from_file") :pointer
  (filename :string))

(defcfun (%texture-2dplane-set-repeat "texture_2dplane_set_repeat") :void
  (tex :pointer) (u-repeat :int) (v-repeat :int))

(defcfun (%texture-2dplane-set-origin "texture_2dplane_set_origin") :void
  (tex :pointer) (u :double) (v :double))

(defcfun (%texture-2dplane-set-scale "texture_2dplane_set_scale") :void
  (tex :pointer) (u :double) (v :double))

(defcfun (%texture-2dplane-set-rotation "texture_2dplane_set_rotation") :void
  (tex :pointer) (angle-deg :double))

;; --- Texture Params ---

(defcfun (%make-texture-params "texture_params_create") :pointer)

(defcfun (%free-texture-params "free_texture_params") :void
  (params :pointer))

(defcfun (%texture-params-set-filter "texture_params_set_filter") :void
  (params :pointer) (filter :int))

(defcfun (%texture-params-set-repeat "texture_params_set_repeat") :void
  (params :pointer) (on :int))

(defcfun (%texture-params-set-aniso "texture_params_set_aniso") :void
  (params :pointer) (level :int))

;; --- PBR Material ---

(defcfun (%make-pbr-material "pbr_material_create") :pointer)

(defcfun (%free-pbr-material "free_pbr_material") :void
  (mat :pointer))

(defcfun (%pbr-material-set-albedo "pbr_material_set_albedo") :void
  (mat :pointer) (r :double) (g :double) (b :double))

(defcfun (%pbr-material-set-metallic "pbr_material_set_metallic") :void
  (mat :pointer) (v :double))

(defcfun (%pbr-material-set-roughness "pbr_material_set_roughness") :void
  (mat :pointer) (v :double))

(defcfun (%pbr-material-set-emissive "pbr_material_set_emissive") :void
  (mat :pointer) (r :double) (g :double) (b :double))

(defcfun (%pbr-material-set-refraction-index "pbr_material_set_refraction_index") :void
  (mat :pointer) (v :double))

(defcfun (%pbr-material-set-transparency "pbr_material_set_transparency") :void
  (mat :pointer) (v :double))

;; --- BSDF ---

(defcfun (%make-bsdf "bsdf_create") :pointer)

(defcfun (%free-bsdf "free_bsdf") :void
  (bsdf :pointer))

(defcfun (%bsdf-set-ambient "bsdf_set_ambient") :void
  (bsdf :pointer) (r :double) (g :double) (b :double))

(defcfun (%bsdf-set-diffuse "bsdf_set_diffuse") :void
  (bsdf :pointer) (r :double) (g :double) (b :double))

(defcfun (%bsdf-set-specular "bsdf_set_specular") :void
  (bsdf :pointer) (r :double) (g :double) (b :double))

(defcfun (%bsdf-set-transmission "bsdf_set_transmission") :void
  (bsdf :pointer) (r :double) (g :double) (b :double))

(defcfun (%bsdf-set-reflection "bsdf_set_reflection") :void
  (bsdf :pointer) (r :double) (g :double) (b :double))

(defcfun (%bsdf-set-refraction-index "bsdf_set_refraction_index") :void
  (bsdf :pointer) (v :double))

(defcfun (%bsdf-set-absorption "bsdf_set_absorption") :void
  (bsdf :pointer) (r :double) (g :double) (b :double) (coeff :double))
