#include "occt_wrap_internal.h"
#include "occt_wrap_bopalgo_utils.h"
#include <cstdlib>
#include <cstring>
#include <sstream>
#include <BOPAlgo_ArgumentAnalyzer.hxx>
#include <BOPAlgo_MakeConnected.hxx>
#include <BOPAlgo_MakePeriodic.hxx>
#include <Bnd_Box.hxx>
#include <BRepBndLib.hxx>

char* argument_analyzer(occt_shape* shapes, int num_shapes) {
    clear_error();
    if (!shapes || num_shapes < 1) { set_error("no shapes provided", 2); return nullptr; }
    try {
        std::ostringstream oss;
        bool hasIssues = false;

        BOPAlgo_ArgumentAnalyzer analyzer;
        for (int i = 0; i < num_shapes; i++) {
            if (!shapes[i]) { set_error("null shape in array", 2); return nullptr; }

            analyzer.SetShape1(*to_shape(shapes[i]));
            analyzer.SetShape2(*to_shape(shapes[i]));
            analyzer.SelfInterMode() = true;
            analyzer.SmallEdgeMode() = true;
            analyzer.TangentMode() = true;
            analyzer.RebuildFaceMode() = true;
            analyzer.MergeVertexMode() = true;
            analyzer.MergeEdgeMode() = true;
            analyzer.ContinuityMode() = true;
            analyzer.CurveOnSurfaceMode() = true;
            analyzer.Perform();

            if (analyzer.HasFaulty()) {
                const NCollection_List<BOPAlgo_CheckResult>& results = analyzer.GetCheckResult();
                for (NCollection_List<BOPAlgo_CheckResult>::Iterator it(results); it.More(); it.Next()) {
                    const BOPAlgo_CheckResult& cr = it.Value();
                    BOPAlgo_CheckStatus st = cr.GetCheckStatus();
                    const char* desc = "Unknown";
                    switch (st) {
                        case BOPAlgo_BadType:               desc = "Bad shape type"; break;
                        case BOPAlgo_SelfIntersect:         desc = "Self-intersection"; break;
                        case BOPAlgo_TooSmallEdge:          desc = "Too small edge"; break;
                        case BOPAlgo_NonRecoverableFace:    desc = "Non-recoverable face"; break;
                        case BOPAlgo_IncompatibilityOfVertex: desc = "Incompatibility of vertex"; break;
                        case BOPAlgo_IncompatibilityOfEdge:   desc = "Incompatibility of edge"; break;
                        case BOPAlgo_IncompatibilityOfFace:   desc = "Incompatibility of face"; break;
                        case BOPAlgo_OperationAborted:      desc = "Operation aborted"; break;
                        case BOPAlgo_GeomAbs_C0:            desc = "C0 continuity"; break;
                        case BOPAlgo_InvalidCurveOnSurface: desc = "Invalid curve on surface"; break;
                        default: break;
                    }
                    oss << "Shape " << i << ": " << desc << "\n";
                }
                hasIssues = true;
            }
        }

        if (!hasIssues) return nullptr;
        return strdup(oss.str().c_str());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_connected_shapes(occt_shape* shapes, int num_shapes) {
    clear_error();
    if (!shapes || num_shapes < 1) { set_error("no shapes provided", 2); return nullptr; }
    try {
        BOPAlgo_MakeConnected maker;
        NCollection_List<TopoDS_Shape> list;
        for (int i = 0; i < num_shapes; i++) {
            if (!shapes[i]) { set_error("null shape in array", 2); return nullptr; }
            list.Append(*to_shape(shapes[i]));
        }
        maker.SetArguments(list);
        maker.Perform();
        if (maker.HasErrors()) { set_error("BOPAlgo_MakeConnected failed"); return nullptr; }
        return from_shape(maker.Shape());
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}

occt_shape make_shape_periodic(occt_shape shape, double dx, double dy, double dz) {
    clear_error();
    if (!shape) { set_error("null shape argument", 2); return nullptr; }
    double dir_mag = sqrt(dx*dx + dy*dy + dz*dz);
    if (dir_mag < Precision::Confusion()) { set_error("zero direction vector", 2); return nullptr; }
    try {
        int dirId = 0;
        double period = 0.0;
        if (fabs(dx) >= fabs(dy) && fabs(dx) >= fabs(dz)) {
            dirId = 0;
            period = fabs(dx);
        } else if (fabs(dy) >= fabs(dx) && fabs(dy) >= fabs(dz)) {
            dirId = 1;
            period = fabs(dy);
        } else {
            dirId = 2;
            period = fabs(dz);
        }

        Bnd_Box bbox;
        BRepBndLib::Add(*to_shape(shape), bbox);
        double x1, y1, z1, x2, y2, z2;
        bbox.Get(x1, y1, z1, x2, y2, z2);
        double periodVal = 0.0;
        switch (dirId) {
            case 0: periodVal = x2 - x1; break;
            case 1: periodVal = y2 - y1; break;
            case 2: periodVal = z2 - z1; break;
        }
        if (periodVal < Precision::Confusion()) {
            set_error("shape has zero extent in requested direction", 2);
            return nullptr;
        }

        BOPAlgo_MakePeriodic maker;
        maker.SetShape(*to_shape(shape));
        maker.MakePeriodic(dirId, true, periodVal);
        maker.SetTrimmed(dirId, false, 0.0);
        maker.Perform();
        if (maker.HasErrors()) { set_error("BOPAlgo_MakePeriodic failed"); return nullptr; }
        TopoDS_Shape result = maker.Shape();
        if (result.IsNull()) { return nullptr; }
        return from_shape(result);
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return nullptr;
    }
}
