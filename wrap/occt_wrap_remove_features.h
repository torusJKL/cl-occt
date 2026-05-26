#ifndef OCCT_WRAP_REMOVE_FEATURES_H
#define OCCT_WRAP_REMOVE_FEATURES_H

#ifdef __cplusplus
extern "C" {
#endif

occt_shape remove_features(occt_shape shape, occt_shape* faces, int num_faces);

#ifdef __cplusplus
}
#endif

#endif
