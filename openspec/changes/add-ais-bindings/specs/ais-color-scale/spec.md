## ADDED Requirements

### Requirement: Create color scale
The system SHALL provide a constructor `make-color-scale` that creates an `AIS_ColorScale` — a color legend bar widget.

#### Scenario: Create a color scale
- **WHEN** the user calls `(make-color-scale)`
- **THEN** the system returns an `ais-object` instance with a non-null C handle

#### Scenario: Set color scale range
- **WHEN** the user calls `(set-color-scale-range cs min max)`
- **THEN** the color scale displays values from min to max

#### Scenario: Set color scale size
- **WHEN** the user calls `(set-color-scale-size cs width height)`
- **THEN** the color scale is drawn with given dimensions

#### Scenario: Set color scale title
- **WHEN** the user calls `(set-color-scale-title cs title)`
- **THEN** the color scale displays the given title

#### Scenario: Set color scale number of intervals
- **WHEN** the user calls `(set-color-scale-intervals cs n)`
- **THEN** the color scale displays n colored intervals

#### Scenario: Color scale requires size before display
- **WHEN** the user creates a color scale without setting size
- **THEN** it may not display correctly until `set-color-scale-size` is called
