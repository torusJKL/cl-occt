#include "occt_wrap_internal.h"
#include "occt_wrap_units.h"
#include <UnitsAPI.hxx>

double units_convert(double value, const char* from_unit, const char* to_unit) {
    clear_error();
    if (!from_unit || !to_unit) { set_error("null unit string", 2); return 0.0; }
    try {
        return UnitsAPI::AnyToAny(value, from_unit, to_unit);
    } catch (Standard_Failure& e) { set_error(e.what()); return 0.0; }
}

double units_convert_to_si(double value, const char* unit) {
    clear_error();
    if (!unit) { set_error("null unit string", 2); return 0.0; }
    try {
        return UnitsAPI::AnyToSI(value, unit);
    } catch (Standard_Failure& e) { set_error(e.what()); return 0.0; }
}

double units_convert_from_si(double value, const char* unit) {
    clear_error();
    if (!unit) { set_error("null unit string", 2); return 0.0; }
    try {
        return UnitsAPI::AnyFromSI(value, unit);
    } catch (Standard_Failure& e) { set_error(e.what()); return 0.0; }
}
