#include "occt_wrap_internal.h"
#include "occt_wrap_hlr_conversion.h"

occt_shape hlr_project(occt_shape shape,
                        double proj_dx, double proj_dy, double proj_dz,
                        double px, double py, double pz) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        occ::handle<HLRBRep_Algo> algo = new HLRBRep_Algo();
        algo->Add(*to_shape(shape));
        algo->Projector(HLRAlgo_Projector(gp_Ax2(gp_Pnt(px, py, pz),
                                                     gp_Dir(proj_dx, proj_dy, proj_dz))));
        algo->Update();
        algo->Hide();

        HLRBRep_HLRToShape shapesExtractor(algo);

        TopoDS_Compound compound;
        BRep_Builder builder;
        builder.MakeCompound(compound);

        TopoDS_Shape sv = shapesExtractor.VCompound();
        if (!sv.IsNull()) builder.Add(compound, sv);
        TopoDS_Shape sh = shapesExtractor.HCompound();
        if (!sh.IsNull()) builder.Add(compound, sh);
        TopoDS_Shape sov = shapesExtractor.OutLineVCompound();
        if (!sov.IsNull()) builder.Add(compound, sov);
        TopoDS_Shape soh = shapesExtractor.OutLineHCompound();
        if (!soh.IsNull()) builder.Add(compound, soh);
        TopoDS_Shape siv = shapesExtractor.Rg1LineVCompound();
        if (!siv.IsNull()) builder.Add(compound, siv);
        TopoDS_Shape sih = shapesExtractor.Rg1LineHCompound();
        if (!sih.IsNull()) builder.Add(compound, sih);

        return from_shape(compound);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape convert_to_revolution(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        occ::handle<ShapeCustom_ConvertToRevolution> converter =
            new ShapeCustom_ConvertToRevolution();
        BRepTools_Modifier modifier(*to_shape(shape));
        modifier.Perform(converter);
        if (!modifier.IsDone()) { set_error("conversion to revolution failed"); return nullptr; }
        return from_shape(modifier.ModifiedShape(*to_shape(shape)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape convert_swept_to_elementary(occt_shape shape) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    try {
        occ::handle<ShapeCustom_SweptToElementary> converter =
            new ShapeCustom_SweptToElementary();
        BRepTools_Modifier modifier(*to_shape(shape));
        modifier.Perform(converter);
        if (!modifier.IsDone()) { set_error("conversion to elementary failed"); return nullptr; }
        return from_shape(modifier.ModifiedShape(*to_shape(shape)));
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

