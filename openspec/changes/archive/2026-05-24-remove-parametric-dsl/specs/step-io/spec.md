## REMOVED Requirements

### Requirement: Export DAG models to STEP with metadata
**Reason**: DAG model system is being removed. Use `write-step-assembly` for colored assembly export instead.
**Migration**: Replace `write-dag-models-to-step` with `write-step-assembly` or `write-step`.

### Requirement: Import STEP assembly into DAG model registry
**Reason**: DAG model system is being removed.
**Migration**: Replace `read-step-into-dag` with `read-step-assembly` or `read-step`.
