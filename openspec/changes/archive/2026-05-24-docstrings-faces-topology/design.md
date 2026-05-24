## Context

Face construction (`faces.lisp`) and topology navigation (`topology.lisp`) are distinct domains that share the same documentation gap. Face functions create edges, wires, and faces from coordinate parameters. Topology functions traverse and query the shape hierarchy and convert between topological and geometric representations.

## Goals / Non-Goals

**Goals:**
- Every public function in both files gets a docstring with example
- `See also:` cross-references between `edge->curve` ↔ `curve-type`, `face->surface` ↔ `surface-type`
- Examples show REPL usage with inline results

**Non-Goals:**
- No functional or API changes

## Decisions

- **Topology navigation examples** (`map-shape-subshapes`, `count-shape-subshapes`, `dump-shape`) should use `make-box` as the test shape since it's well-known
- **Shape conversion examples** (`edge->curve`, `face->surface`) should show the round-trip: create edge → get curve → check type
- **`make-polygon`** example should show both closed and open polygon cases using its `:closed` key
- **`make-vertex`** is simple enough for a brief example

## Risks / Trade-offs

- None significant
