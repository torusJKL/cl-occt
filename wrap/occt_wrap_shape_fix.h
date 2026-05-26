#ifndef OCCT_WRAP_SHAPE_FIX_H
#define OCCT_WRAP_SHAPE_FIX_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Shape Fix ---

occt_shape fix_shape(occt_shape shape);
occt_shape fix_wire(occt_shape wire, occt_shape face, double tolerance);
occt_shape fix_solid(occt_shape shape);
occt_shape fix_edge(occt_shape edge);
occt_shape fix_face(occt_shape face);
occt_shape shape_analysis_free_edges(occt_shape shape);
int shape_analysis_check_intersections(occt_shape shape);
int shape_analysis_wire_contains(occt_shape wire, double x, double y);
const char* shape_analysis_contents(occt_shape shape);

// --- Shape Rebuild ---

occt_shape substitute_single(occt_shape shape, occt_shape old_sub, occt_shape new_sub);
occt_shape substitute_batch(occt_shape shape, occt_shape* old_shapes, occt_shape* new_shapes, int count);
occt_shape shape_to_nurbs(occt_shape shape);
occt_shape shape_reduce_degree(occt_shape shape, int max_degree);
occt_shape shape_to_rational_bspline(occt_shape shape);
occt_shape shape_split_u(occt_shape shape, int num_splits);
occt_shape shape_upgrade_continuity(occt_shape shape, int continuity);

// --- Shape Process Pipeline ---

occt_shape apply_shape_process(occt_shape shape, const char* operator_name);
occt_shape apply_operator_sequence(occt_shape shape, const char** operators, int count);
occt_shape apply_healing_pipeline(occt_shape shape, const char* pipeline_name, const char* resource);
occt_shape heal_shape_default(occt_shape shape);

// --- Sewing ---

occt_shape sew_shapes(occt_shape* shapes, int num_shapes, double tolerance, int allow_non_manifold);

// --- Defeaturing ---

occt_shape defeature_shape(occt_shape shape, occt_shape* faces, int num_faces);

// --- Shape Check & Builder ---

const char* check_shape_validity(occt_shape shape);
occt_shape boolean_builder(occt_shape shape1, occt_shape shape2, int operation);
int   shape_bounding_box(occt_shape shape,
                         double* xmin, double* ymin, double* zmin,
                         double* xmax, double* ymax, double* zmax);

#ifdef __cplusplus
}
#endif

#endif
