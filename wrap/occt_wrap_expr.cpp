#include "occt_wrap_internal.h"
#include "occt_wrap_expr.h"
#include <ExprIntrp_GenExp.hxx>
#include <Expr_NumericValue.hxx>

int evaluate_expression(const char* expr, double* out_value) {
    clear_error();
    if (!expr || !out_value) { set_error("null input", 2); return 0; }
    try {
        Handle(ExprIntrp_GenExp) gen = ExprIntrp_GenExp::Create();
        if (gen.IsNull()) { set_error("failed to create generator", 2); return 0; }
        gen->Process(TCollection_AsciiString(expr));
        if (!gen->IsDone()) { set_error("parse failed", 2); return 0; }
        Handle(Expr_GeneralExpression) exp = gen->Expression();
        if (exp.IsNull()) { set_error("null expression", 2); return 0; }
        Handle(Expr_GeneralExpression) simplified = exp->Simplified();
        if (simplified.IsNull()) { set_error("simplification failed", 2); return 0; }
        Handle(Expr_NumericValue) numeric = Handle(Expr_NumericValue)::DownCast(simplified);
        if (numeric.IsNull()) { set_error("expression not constant", 2); return 0; }
        *out_value = numeric->GetValue();
        return 1;
    } catch (Standard_Failure& e) { set_error(e.what()); return 0; }
}
