#ifndef OCCT_WRAP_OPERATIONS_H
#define OCCT_WRAP_OPERATIONS_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Fillet / Chamfer / Blend ---

occt_shape fillet_edge_constant(occt_shape shape, occt_shape edge, double radius);
occt_shape fillet_edges_constant(occt_shape shape, occt_shape* edges, int num_edges, double radius);
occt_shape fillet_edge_variable(occt_shape shape, occt_shape edge, double* params_and_radii, int num_pairs);
occt_shape fillet_wire_corner(occt_shape wire, double radius);
occt_shape fillet_wire_all_corners(occt_shape wire, double radius);

occt_shape chamfer_edge_equal(occt_shape shape, occt_shape edge, double distance);
occt_shape chamfer_edges_equal(occt_shape shape, occt_shape* edges, int num_edges, double distance);
occt_shape chamfer_edge_asym(occt_shape shape, occt_shape edge, double distance1, double distance2);
occt_shape chamfer_edge_on_face(occt_shape shape, occt_shape edge, double distance, occt_shape face);

occt_shape blend_faces_constant(occt_shape face1, occt_shape face2, double radius);
occt_shape blend_make_constant(occt_shape face1, occt_shape face2, double radius);

// --- Sweep / Pipe ---

occt_shape sweep_pipe(occt_shape profile, occt_shape spine);
occt_shape sweep_pipe_fixed(occt_shape profile, occt_shape spine);
occt_shape sweep_pipe_shell(occt_shape spine, occt_shape* sections, double* params, int count);
occt_shape sweep_pipe_shell_sliding(occt_shape spine, occt_shape* sections, double* params, int count);
occt_shape sweep_pipe_shell_fixed(occt_shape spine, occt_shape* sections, double* params, int count);
occt_shape sweep_pipe_shell_aux(occt_shape profile, occt_shape main_spine, occt_shape aux_spine);

// --- Loft ---

occt_shape loft_sections(occt_shape* wires, int count, int solid);
occt_shape loft_sections_ruled(occt_shape* wires, int count, int solid, int ruled);
occt_shape loft_sections_smooth(occt_shape* wires, int count, int solid, int smooth);
occt_shape loft_sections_tangency(occt_shape* wires, int count, int solid, occt_shape init_face, occt_shape final_face);

// --- Face Filling ---

occt_shape fill_face(occt_shape wire);
occt_shape fill_face_constrained(occt_shape wire, occt_shape* support_faces, int* continuities, int count);
occt_shape fill_n_sided_face(occt_shape* edges, int count, int continuity);

// --- Shell / Thicken ---

occt_shape shell_shape(occt_shape shape, occt_shape* faces, int num_faces, double thickness);

// --- Offset ---

occt_shape offset_shape_3d(occt_shape shape, double offset, int join);
occt_shape offset_wire_2d(occt_shape wire, double offset);

// --- Draft ---

occt_shape draft_face(occt_shape shape, occt_shape face, double angle,
                      double dx, double dy, double dz,
                      double px, double py, double pz,
                      double nx, double ny, double nz);
occt_shape make_evolved(occt_shape profile, occt_shape spine, double offset, int join);

#ifdef __cplusplus
}
#endif

#endif
