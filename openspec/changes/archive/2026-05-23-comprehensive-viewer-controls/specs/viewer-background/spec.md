## ADDED Requirements

### Requirement: Set gradient background
The system SHALL set a two-color gradient background with selectable fill direction.

#### Scenario: Horizontal gradient top-to-bottom
- **WHEN** user calls `(set-gradient-background view :top '(0.1 0.1 0.3) :bottom '(0.8 0.8 0.9))`
- **THEN** the background renders as a gradient from dark blue-grey at top to near-white at bottom

#### Scenario: Gradient with explicit fill style
- **WHEN** user calls `(set-gradient-background view :color1 '(0.1 0.1 0.3) :color2 '(0.8 0.8 0.9) :style :x-neg)`
- **THEN** the background gradient follows the X-neg direction

#### Scenario: Supported gradient directions
- **WHEN** user calls with `:style` set to any of `:x-pos`, `:x-neg`, `:y-pos`, `:y-neg`, `:z-pos`, `:z-neg`
- **THEN** the gradient direction is respected

### Requirement: Set image background
The system SHALL load an image file and display it as the view background.

#### Scenario: Image background
- **WHEN** user calls `(set-image-background view "/path/to/background.png")`
- **THEN** the image is stretched to fill the background

#### Scenario: Image with fill method
- **WHEN** user calls `(set-image-background view "/path/to/bg.png" :fill-method :center)
- **THEN** the image is centered without stretching

#### Scenario: Supported fill methods
- **WHEN** user calls with `:fill-method` set to `:center`, `:tile`, or `:stretch`
- **THEN** the image is rendered accordingly

#### Scenario: Invalid image path
- **WHEN** user calls `(set-image-background view "/nonexistent.png")`
- **THEN** returns nil (no crash, error retrievable via `(get-error-message)`)

### Requirement: Set cube-map environment
The system SHALL set an environment cubemap from 6 image files for reflection/refraction in ray-traced mode.

#### Scenario: Cube-map from 6 faces
- **WHEN** user calls `(set-cube-map view :pos-x "px.jpg" :neg-x "nx.jpg" :pos-y "py.jpg" :neg-y "ny.jpg" :pos-z "pz.jpg" :neg-z "nz.jpg")`
- **THEN** the cubemap environment is activated for reflections

### Requirement: Unset / reset background
The system SHALL reset the background to the viewer's default background color.

#### Scenario: Reset to default
- **WHEN** user calls `(reset-background view)`
- **THEN** the background reverts to the default solid color
