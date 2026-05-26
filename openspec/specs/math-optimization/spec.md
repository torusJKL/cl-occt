## ADDED Requirements

### Requirement: BFGS multi-variate minimization
The system SHALL provide a function for BFGS quasi-Newton minimization via math_BFGS.

**Parameters**: objective function (accepts a vector of doubles, returns a double), initial guess vector, optional tolerance, optional max iterations.

**Returns**: A plist `(:converged bool :iterations int :minimum-value double :minimizer (list of doubles))` or nil on failure.

#### Scenario: Minimize a simple quadratic function
- **WHEN** calling `(bfgs-minimize (lambda (v) (* (first v) (first v))) '(3.0) :tolerance 1e-6)`
- **THEN** the minimizer is approximately 0.0 and `:converged` is t

#### Scenario: BFGS with nil initial guess returns nil
- **WHEN** calling `(bfgs-minimize #'my-fn nil)`
- **THEN** the result is nil

### Requirement: FRPR (Fletcher-Reeves Polak-Ribiere) minimization
The system SHALL provide a function for conjugate gradient minimization via math_FRPR.

**Parameters** and **Returns**: Same as BFGS.

#### Scenario: FRPR minimizes a quadratic
- **WHEN** calling `(frpr-minimize (lambda (v) (+ (* (first v) (first v)) (* (second v) (second v)))) '(3.0 4.0))`
- **THEN** both minimizer components are approximately 0.0

### Requirement: PSO (Particle Swarm Optimization)
The system SHALL provide a function for particle swarm optimization via math_PSO.

**Parameters**: objective function, lower bounds vector, upper bounds vector, initial guess, optional number of particles, optional max iterations, optional tolerance.

**Returns**: Same plist format as BFGS.

#### Scenario: PSO finds global minimum
- **WHEN** calling `(pso-minimize fn '(0 0) '(10 10) '(5 5) :n-particles 50 :max-iterations 200)`
- **THEN** `:converged` is t and the minimizer is near the known minimum

### Requirement: GlobOptMin global optimization
The system SHALL provide a function for global optimization via math_GlobOptMin.

**Parameters**: objective function, lower bounds, upper bounds, optional number of steps.

**Returns**: Same plist format.

#### Scenario: GlobOptMin finds minimum
- **WHEN** calling `(globoptmin-minimize fn '(0 0) '(10 10))`
- **THEN** `:converged` is t with a valid minimizer

### Requirement: Solver state management
The system SHALL provide explicit `free` functions for each solver type.

#### Scenario: Free BFGS solver
- **WHEN** calling `(bfgs-free solver)` on a valid BFGS solver handle
- **THEN** the handle is freed without error
