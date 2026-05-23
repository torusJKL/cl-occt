## ADDED Requirements

### Requirement: Set viewer default background color
The system SHALL set the default background color for future views created from this viewer.

#### Scenario: Default dark background
- **WHEN** user calls `(set-default-background viewer '(0.05 0.05 0.1))`
- **THEN** new views created from this viewer default to near-black background

### Requirement: Set viewer default background gradient
The system SHALL set the default gradient background colors for future views.

#### Scenario: Default gradient
- **WHEN** user calls `(set-default-gradient viewer :top '(0.1 0.1 0.3) :bottom '(0.8 0.8 0.9))`
- **THEN** new views default to a gradient background

### Requirement: Set viewer default projection
The system SHALL set the default view orientation for future views.

#### Scenario: Default iso view
- **WHEN** user calls `(set-default-projection viewer :iso-pers)`
- **THEN** new views open in isometric perspective

### Requirement: Set viewer default view size
The system SHALL set the default camera distance (view size) for future views.

#### Scenario: Default zoom level
- **WHEN** user calls `(set-default-view-size viewer 200.0)`
- **THEN** new views have a default camera distance of 200 units

### Requirement: Set viewer default Prs3d_Drawer
The system SHALL set a custom default drawer that all new interactive objects inherit.

#### Scenario: Custom default drawer
- **WHEN** user creates a `drawer` and calls `(set-default-drawer viewer drawer)`
- **THEN** all new AIS objects created in this viewer use the given drawer as their attribute source

### Requirement: Set viewer default type of view
The system SHALL set the default projection type (perspective or orthographic) for future views.

#### Scenario: Default orthographic
- **WHEN** user calls `(set-default-view-type viewer :orthographic)`
- **THEN** new views default to orthographic projection

#### Scenario: Default perspective
- **WHEN** user calls `(set-default-view-type viewer :perspective)`
- **THEN** new views default to perspective projection

### Requirement: Manage default lights
The system SHALL configure the viewer's default lighting setup (ambient + directional headlight).

#### Scenario: Default lights on/off
- **WHEN** user calls `(set-default-lights viewer :on)` / `(set-default-lights viewer :off)`
- **THEN** the default lights are toggled

#### Scenario: Custom default lights
- **WHEN** user calls `(set-default-lights viewer :custom light-1 light-2)`
- **THEN** the default lights are replaced with the provided list of lights
