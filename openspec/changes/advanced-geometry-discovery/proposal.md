## Why

Phase 1 established core topology data access (vertex coords, edge ranges, UV bounds). This phase adds the next layer: tools for programmatic shape discovery and advanced CAD modeling — uniform point sampling along curves, assembly-aware shape locations, edge finding by geometric properties, normal projection, BREP native I/O, additional primitives (wedge), mechanical features (drafted prism), defeaturing (remove features), and shape healing enhancements (fix small faces, shape tolerance manipulation). These are essential for an AI agent to reason about shapes without vision and for advanced CAD workflows.

## What Changes

- **Uniform point distribution on curve**: C wrapper + CFFI + core for `GCPnts_UniformAbscissa` and `GCPnts_UniformDeflection`
- **Shape location in assemblies**: C wrapper + CFFI + core for `TopLoc_Location` — get/set/apply location on shapes
- **Find edges by geometry**: C wrapper + CFFI + core for `BRepLib_FindEdges` — find edges matching geometric criteria (circular, line, etc.)
- **Normal projection**: C wrapper + CFFI + core for `BRepAlgo_NormalProjection` — project shape onto face along normal
- **Transfer parameters**: C wrapper + CFFI + core for `ShapeAnalysis_TransferParameters` — map parameters between edge and curve
- **BREP native I/O**: C wrapper + CFFI + core for `BRepTools::Read`/`BRepTools::Write` — .brep format
- **Wedge primitive**: C wrapper + CFFI + core for `BRepPrimAPI_MakeWedge`
- **Drafted prism feature**: C wrapper + CFFI + core for `BRepFeat_MakeDPrism`
- **Remove features**: C wrapper + CFFI + core for `BRepAlgoAPI_RemoveFeatures`
- **Fix small faces**: C wrapper + CFFI + core for `ShapeFix_FixSmallFace`
- **Shape tolerance manipulation**: C wrapper + CFFI + core for `ShapeFix_ShapeTolerance` — set/get tolerance per subshape type
- **RWStl (low-level STL)**: C wrapper + CFFI + core for `RWStl` — lower-level STL control
- **Documentation**: Update `doc/api-reference.md` with all new function signatures

## Capabilities

### New Capabilities
- `uniform-point-distribution`: Evenly-spaced point sampling on curves via GCPnts
- `assembly-location`: TopLoc_Location query and manipulation for assembly-aware transforms
- `edge-geometry-finding`: Find edges by geometric properties via BRepLib_FindEdges
- `normal-projection`: Project shapes onto faces along surface normals
- `brep-native-io`: Read/write the native OCCT BREP format
- `wedge-primitive`: BRepPrimAPI_MakeWedge for tapered box shapes
- `drafted-prism`: BRepFeat_MakeDPrism for drafted prismatic features
- `remove-features`: BRepAlgoAPI_RemoveFeatures for selective defeaturing
- `shape-healing-small-faces`: Fix small faces via ShapeFix_FixSmallFace
- `shape-tolerance-tools`: ShapeFix_ShapeTolerance for tolerance manipulation
- `rwstl-io`: Low-level STL read/write via RWStl

### Modified Capabilities
- *(no existing capabilities have requirement changes)*

## Impact

- **C wrapper** (`wrap/`): ~20 new `extern "C"` functions across multiple new files
- **CFFI layer** (`src/ffi/`): ~20 new `defcfun` bindings
- **Core layer** (`src/core/`): ~11 new Lisp files
- **Tests** (`tests/`): ~80+ new tests
- **Docs** (`doc/api-reference.md`): ~11 new sections
