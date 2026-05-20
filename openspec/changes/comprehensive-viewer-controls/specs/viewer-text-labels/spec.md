## ADDED Requirements

### Requirement: Set text rotation angle
The system SHALL rotate a text label around the Z axis by a given angle in degrees.

#### Scenario: Rotated label
- **WHEN** user calls `(set-text-label-angle label 45.0)`
- **THEN** the label text is rotated 45 degrees

#### Scenario: Zero rotation
- **WHEN** user calls `(set-text-label-angle label 0.0)`
- **THEN** the label renders unrotated (default)

### Requirement: Set horizontal alignment
The system SHALL align text horizontally relative to its position point.

#### Scenario: Left-aligned
- **WHEN** user calls `(set-text-label-align label :horizontal :left)`
- **THEN** the text extends rightward from the position point

#### Scenario: Center-aligned
- **WHEN** user calls `(set-text-label-align label :horizontal :center)`
- **THEN** the text is centered on the position point

#### Scenario: Right-aligned
- **WHEN** user calls `(set-text-label-align label :horizontal :right)`
- **THEN** the text extends leftward from the position point

### Requirement: Set vertical alignment
The system SHALL align text vertically relative to its position point.

#### Scenario: Top-aligned
- **WHEN** user calls `(set-text-label-align label :vertical :top)`
- **THEN** the position point is at the top of the text

#### Scenario: Center-aligned
- **WHEN** user calls `(set-text-label-align label :vertical :center)`
- **THEN** the position point is at the vertical center

#### Scenario: Bottom-aligned
- **WHEN** user calls `(set-text-label-align label :vertical :bottom)`
- **THEN** the position point is at the bottom of the text

### Requirement: Set text display type
The system SHALL set the display type of a text label (ordinary, subtitle with background box, or dekale with shadow).

#### Scenario: Subtitle (background box)
- **WHEN** user calls `(set-text-label-display label :subtitle)`
- **THEN** the label renders with a background box behind the text

#### Scenario: Dekale (shadow)
- **WHEN** user calls `(set-text-label-display label :dekale)`
- **THEN** the label renders with a drop shadow

#### Scenario: Ordinary (no background)
- **WHEN** user calls `(set-text-label-display label :ordinary)`
- **THEN** the label renders without background or shadow (default)

### Requirement: Set subtitle background color
The system SHALL set the background box color when in subtitle display mode.

#### Scenario: Dark subtitle background
- **WHEN** user calls `(set-text-label-subtitle-color label '(0.0 0.0 0.0))`
- **THEN** the subtitle background renders in black

#### Scenario: Named color subtitle
- **WHEN** user calls `(set-text-label-subtitle-color label :dark-grey)`
- **THEN** the subtitle background renders in dark grey

### Requirement: Combined text label convenience
The system SHALL provide a convenience function to create and configure a text label in one call.

#### Scenario: One-call labeled text
- **WHEN** user calls `(make-text-label ctx "Hello" '(0 0 0) :color :white :height 12.0 :font "Arial" :angle 90.0 :align :center)`
- **THEN** returns a displayed `ais-object` with the configured text label
