#include "occt_wrap_internal.h"
#include "occt_wrap_ocaf_function.h"

#include <TFunction_Function.hxx>
#include <TFunction_Driver.hxx>
#include <TFunction_IFunction.hxx>
#include <TFunction_Iterator.hxx>
#include <TFunction_GraphNode.hxx>
#include <TFunction_Logbook.hxx>
#include <TFunction_ExecutionStatus.hxx>

// --- Parametric Functions ---

int ocaf_add_function(ocaf_label label, const char* driver_guid) {
    clear_error();
    if (!label) { set_error("null label", 2); return 0; }
    if (!driver_guid) { set_error("null driver GUID", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(label);
        Standard_GUID guid(driver_guid);
        Handle(TFunction_Function) func = TFunction_Function::Set(*l, guid);
        if (func.IsNull()) {
            set_error("failed to create function attribute");
            return 0;
        }
        TFunction_GraphNode::Set(*l);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ocaf_set_function_input(ocaf_label func_label, ocaf_label input_label) {
    clear_error();
    if (!func_label || !input_label) { set_error("null argument", 2); return 0; }
    try {
        TDF_Label* fl = static_cast<TDF_Label*>(func_label);
        TDF_Label* il = static_cast<TDF_Label*>(input_label);
        Handle(TFunction_GraphNode) gn;
        if (il->FindAttribute(TFunction_GraphNode::GetID(), gn)) {
            gn->AddNext(*fl);
        } else {
            gn = TFunction_GraphNode::Set(*il);
            gn->AddNext(*fl);
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ocaf_set_function_output(ocaf_label func_label, ocaf_label output_label) {
    clear_error();
    if (!func_label || !output_label) { set_error("null argument", 2); return 0; }
    try {
        TDF_Label* fl = static_cast<TDF_Label*>(func_label);
        TDF_Label* ol = static_cast<TDF_Label*>(output_label);
        Handle(TFunction_GraphNode) gn;
        if (fl->FindAttribute(TFunction_GraphNode::GetID(), gn)) {
            gn->AddNext(*ol);
        } else {
            gn = TFunction_GraphNode::Set(*fl);
            gn->AddNext(*ol);
        }
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ocaf_recompute_doc(xde_doc doc) {
    clear_error();
    if (!doc) { set_error("null doc", 2); return 0; }
    try {
        Handle(TDocStd_Document)& hDoc = *static_cast<Handle(TDocStd_Document)*>(doc);
        TFunction_Iterator it(hDoc->GetData()->Root());
        it.SetUsageOfExecutionStatus(true);
        int count = 0;
        it.Init(hDoc->GetData()->Root());
        while (it.More()) {
            const NCollection_List<TDF_Label>& current = it.Current();
            for (NCollection_List<TDF_Label>::Iterator cit(current); cit.More(); cit.Next()) {
                TDF_Label funcLabel = cit.Value();
                TFunction_IFunction func(funcLabel);
                occ::handle<TFunction_Driver> driver = func.GetDriver();
                if (!driver.IsNull()) {
                    occ::handle<TFunction_Logbook> log = func.GetLogbook();
                    int status = driver->Execute(log);
                    func.SetStatus(status == 0 ? TFunction_ES_Succeeded : TFunction_ES_Failed);
                } else {
                    func.SetStatus(TFunction_ES_Succeeded);
                }
                count++;
            }
            it.Next();
        }
        return count;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}

int ocaf_recompute_function(ocaf_label func_label) {
    clear_error();
    if (!func_label) { set_error("null label", 2); return 0; }
    try {
        TDF_Label* l = static_cast<TDF_Label*>(func_label);
        TFunction_IFunction func(*l);
        occ::handle<TFunction_Driver> driver = func.GetDriver();
        if (!driver.IsNull()) {
            occ::handle<TFunction_Logbook> log = func.GetLogbook();
            int status = driver->Execute(log);
            func.SetStatus(status == 0 ? TFunction_ES_Succeeded : TFunction_ES_Failed);
            return status == 0 ? 1 : 0;
        }
        func.SetStatus(TFunction_ES_Succeeded);
        return 1;
    } catch (Standard_Failure& e) {
        set_error(e.what());
        return 0;
    }
}
