## ADDED Requirements

### Requirement: Load image from file

The system SHALL load an image file from disk into a pixel map using `Image_AlienPixMap`. The function `image-from-file` SHALL accept a path string and return an `image` instance, or nil on failure. Supported formats SHALL include PNG, JPEG, BMP, TGA, and any format supported by OCCT's `Image_AlienPixMap`.

#### Scenario: Load valid PNG file
- **WHEN** `image-from-file` is called with a path to a valid PNG file
- **THEN** an `image` instance SHALL be returned with non-nil handle

#### Scenario: Load non-existent file
- **WHEN** `image-from-file` is called with a path to a non-existent file
- **THEN** nil SHALL be returned and error message SHALL be accessible via `get-error-message`

#### Scenario: Load unsupported format
- **WHEN** `image-from-file` is called with a path to an unsupported or corrupted file
- **THEN** nil SHALL be returned

### Requirement: Save image to file

The system SHALL save an `image` pixel map to a file on disk using `Image_AlienPixMap::Save`. The function `image-save` SHALL accept an `image` and a path string, and return t on success or nil on failure. The output format SHALL be inferred from the file extension.

#### Scenario: Save PNG
- **WHEN** `image-save` is called on a loaded image with a `*.png` path
- **THEN** t SHALL be returned and the file SHALL exist at the given path

#### Scenario: Save with nil image
- **WHEN** `image-save` is called with nil
- **THEN** nil SHALL be returned

### Requirement: Query image dimensions

The system SHALL provide functions to query image pixel dimensions. `image-width` and `image-height` SHALL accept an `image` instance and return the pixel count or nil on invalid input.

#### Scenario: Query valid image
- **WHEN** `image-width` and `image-height` are called on a loaded image
- **THEN** positive integers SHALL be returned matching the image file's pixel dimensions

#### Scenario: Query nil image
- **WHEN** `image-width` or `image-height` is called with nil
- **THEN** nil SHALL be returned

### Requirement: GC finalization

The system SHALL register an `image` instance with `tg:finalize` to automatically free the C handle when the instance is garbage collected.

#### Scenario: GC collects image
- **WHEN** an `image` instance goes out of scope and is garbage collected
- **THEN** `free_image` SHALL be called on the underlying C handle, preventing memory leaks
