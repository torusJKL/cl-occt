#ifndef OCCT_WRAP_IO_H
#define OCCT_WRAP_IO_H

#ifdef __cplusplus
extern "C" {
#endif

int write_step(occt_shape shape, const char* filename);
occt_shape read_step(const char* filename);

int write_stl(occt_shape shape, const char* filename, double deflection, double angle, int relative);
occt_shape read_stl(const char* filename);

// --- IGES I/O ---

int write_iges(occt_shape shape, const char* filename);
occt_shape read_iges(const char* filename);

// --- IGES Assembly (XDE) I/O ---

xde_doc xde_read_iges(const char* filename);
int    xde_write_iges(xde_doc doc, const char* filename);

// --- OBJ Mesh I/O ---

int write_obj(occt_shape shape, const char* filename,
              int coordinate_system, int name_format, int per_vertex_colors);
occt_shape read_obj(const char* filename, int coordinate_system);

// --- VRML Export ---

int write_vrml(occt_shape shape, const char* filename, double deflection);

// --- glTF I/O ---

int write_gltf(occt_shape shape, const char* filename,
               int coordinate_system, int per_vertex_colors);
occt_shape read_gltf(const char* filename, int coordinate_system);

// --- PLY Export ---

int write_ply(occt_shape shape, const char* filename,
              int coordinate_system, int per_vertex_colors);

// --- RWMesh Utility Enums ---

int rwmesh_coordinate_system_zup(void);
int rwmesh_coordinate_system_yup(void);
int rwmesh_name_format_auto(void);
int rwmesh_name_format_short(void);
int rwmesh_name_format_full(void);

#ifdef __cplusplus
}
#endif

#endif
