## ADDED Requirements

### Requirement: Create and free fill area aspect
The system SHALL create a `Graphic3d_AspectFillArea3d` with configurable interior style, color, edge color, and edge line type. This is a heap-allocated value type with `tg:finalize` GC.

#### Scenario: Create fill area aspect
- **WHEN** user calls `(make-aspect-fill-area)`
- **THEN** returns an `aspect-fill-area` instance with default values

#### Scenario: Create with interior style
- **WHEN** user calls `(make-aspect-fill-area :interior-style :solid :color '(1 0 0))`
- **THEN** returns a fill area aspect with solid red interior

#### Scenario: Free fill area aspect
- **WHEN** user calls `(free-aspect-fill-area a)`
- **THEN** the internal C pointer is freed

### Requirement: Create and free line aspect
The system SHALL create a `Graphic3d_AspectLine3d` with configurable color, line type, and width.

#### Scenario: Create line aspect
- **WHEN** user calls `(make-aspect-line)`
- **THEN** returns an `aspect-line` instance with default values

#### Scenario: Create with custom values
- **WHEN** user calls `(make-aspect-line :color '(0 1 0) :type :dash :width 2.0)`
- **THEN** returns a line aspect with green dashed 2px line

### Requirement: Create and free marker aspect
The system SHALL create a `Graphic3d_AspectMarker3d` with configurable color, marker type, and scale.

#### Scenario: Create marker aspect
- **WHEN** user calls `(make-aspect-marker)`
- **THEN** returns an `aspect-marker` instance with default values

#### Scenario: Create with custom values
- **WHEN** user calls `(make-aspect-marker :color '(0 0 1) :type :ball :scale 3.0)`
- **THEN** returns a marker aspect with blue ball markers scaled to 3x

### Requirement: Create and free text aspect
The system SHALL create a `Graphic3d_AspectText3d` with configurable color, font, and style.

#### Scenario: Create text aspect
- **WHEN** user calls `(make-aspect-text)`
- **THEN** returns an `aspect-text` instance with default values

#### Scenario: Create with custom values
- **WHEN** user calls `(make-aspect-text :color '(1 1 1) :font "Arial" :style :bold)`
- **THEN** returns a text aspect with white Arial bold

### Requirement: Aspect property accessors
The system SHALL provide accessors for aspect properties.

#### Scenario: Get fill area color
- **WHEN** user calls `(aspect-fill-area-color a)`
- **THEN** returns `(r g b)` list or nil

#### Scenario: Get line color
- **WHEN** user calls `(aspect-line-color a)`
- **THEN** returns `(r g b)` list or nil

#### Scenario: Get line width
- **WHEN** user calls `(aspect-line-width a)`
- **THEN** returns a double-float

#### Scenario: Get marker type
- **WHEN** user calls `(aspect-marker-type a)`
- **THEN** returns a keyword like `:ball`, `:point`, etc.

#### Scenario: Get text color
- **WHEN** user calls `(aspect-text-color a)`
- **THEN** returns `(r g b)` list or nil

### Requirement: Predicates
The system SHALL provide predicates for all aspect types.

#### Scenario: Type predicates
- **WHEN** user calls `(aspect-fill-area-p obj)`, `(aspect-line-p obj)`, `(aspect-marker-p obj)`, `(aspect-text-p obj)`
- **THEN** returns `t` for matching instances, `nil` otherwise
