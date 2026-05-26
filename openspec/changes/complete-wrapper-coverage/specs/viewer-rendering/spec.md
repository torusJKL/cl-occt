## REMOVED Requirements

### Requirement: Enable/disable transparent shading sorting

**Reason**: `v3d_view_set_transparent_shading` was never implemented in the C wrapper (declared twice but no `.cpp` definition). The equivalent functionality is provided by `SetTransparencyMethod` / `set-transparency-method`.

**Migration**: Use `(set-transparency-method view :oit)` or the alias `(set-transparent-shading view :oit)` instead. Both are already implemented and documented.
