#ifndef OCCT_WRAP_EXPR_H
#define OCCT_WRAP_EXPR_H

#ifdef __cplusplus
extern "C" {
#endif

int evaluate_expression(const char* expr, double* out_value);

#ifdef __cplusplus
}
#endif

#endif
