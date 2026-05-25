## ADDED Requirements

### Requirement: api-reference.md documents animation API
The `docs/api-reference.md` SHALL contain an Animation section documenting all animation functions.

#### Scenario: All animation functions documented
- **WHEN** a developer opens `docs/api-reference.md`
- **THEN** the document SHALL contain an Animation section with `make-animation`, `ais-animation-start`, `ais-animation-stop`, `ais-animation-playing-p`, `ais-animation-duration`, `ais-animation-progress`, `ais-animation-start-pause`, `add-animation`, `remove-animation`, `ais-animation-free`, `make-animation-object`, `make-animation-camera`, and `make-animation-axis-rotation`
- **THEN** each function SHALL have a description and a code example
