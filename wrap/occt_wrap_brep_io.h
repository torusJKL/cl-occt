#ifndef OCCT_WRAP_BREP_IO_H
#define OCCT_WRAP_BREP_IO_H

#ifdef __cplusplus
extern "C" {
#endif

int brep_write_shape(occt_shape shape, const char* filename);
occt_shape brep_read_shape(const char* filename);

#ifdef __cplusplus
}
#endif

#endif
