#ifndef OCCT_WRAP_FEATURES_H
#define OCCT_WRAP_FEATURES_H

#ifdef __cplusplus
extern "C" {
#endif

// --- Mechanical Features (BRepFeat) ---

occt_shape make_cylindrical_hole(occt_shape shape, occt_shape face,
                                 double radius, double depth, int through);
occt_shape make_prism_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                              double height, double dx, double dy, double dz, int operation);
occt_shape make_revol_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                              double ax, double ay, double az, double angle, int operation);
occt_shape make_pipe_feature(occt_shape shape, occt_shape base_face, occt_shape profile,
                             occt_shape path, int operation);

// --- Local Operations (LocOpe) ---

occt_shape local_extrude(occt_shape face, double height, double dx, double dy, double dz);
occt_shape make_groove(occt_shape shape, occt_shape face,
                        double ax, double ay, double az, double angle);
occt_shape make_rib(occt_shape shape, occt_shape profile, double thickness,
                    double dx, double dy, double dz);

// --- BOPAlgo Operations ---

occt_shape split_shape(occt_shape shape, occt_shape* tools, int num_tools);
occt_shape make_volume(occt_shape* shapes, int num_shapes);
occt_shape cells_builder(occt_shape* shapes, int num_shapes, int operation,
                          int* selection, int sel_count);

#ifdef __cplusplus
}
#endif

#endif
