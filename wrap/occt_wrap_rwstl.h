#ifndef OCCT_WRAP_RWSTL_H
#define OCCT_WRAP_RWSTL_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void* occt_triangulation;

occt_triangulation rwstl_read_file(const char* filename);
int rwstl_write_file(occt_triangulation tri, const char* filename);
void rwstl_free_triangulation(occt_triangulation tri);

#ifdef __cplusplus
}
#endif

#endif
