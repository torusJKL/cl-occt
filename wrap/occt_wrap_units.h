#ifndef OCCT_WRAP_UNITS_H
#define OCCT_WRAP_UNITS_H

#ifdef __cplusplus
extern "C" {
#endif

double units_convert(double value, const char* from_unit, const char* to_unit);
double units_convert_to_si(double value, const char* unit);
double units_convert_from_si(double value, const char* unit);

#ifdef __cplusplus
}
#endif

#endif
