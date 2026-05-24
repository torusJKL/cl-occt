## 1. Colors (`viewer-colors.lisp`)

- [x] 1.1 Add docstring to `viewer-color-p` (docstring only)
- [x] 1.2 Add docstring + example to `make-color`
- [x] 1.3 Add docstring + example to `color-rgb`
- [x] 1.4 Add docstring + example to `normalize-color`
- [x] 1.5 Add docstring + example to `named-color`
- [x] 1.6 Add docstring + example to `list-named-colors`
- [x] 1.7 Add docstring + example to `named-color-exists-p`
- [x] 1.8 Add docstring + example to `hex-to-rgb`
- [x] 1.9 Add docstring + example to `hex-digit-char-p`
- [x] 1.10 Add docstring + example to `parse-hex-value`
- [x] 1.11 Add docstring + example to `parse-hex-6`
- [x] 1.12 Add docstring + example to `parse-hex-3`
- [x] 1.13 Add docstring + example to `hls-to-rgb`
- [x] 1.14 Add docstring + example to `color-delta`

## 2. Viewer defaults (`viewer-defaults.lisp`)

- [x] 2.1 Add docstring + example to `set-default-bg-gradient`
- [x] 2.2 Add docstring + example to `set-default-background`
- [x] 2.3 Add docstring + example to `set-default-projection`
- [x] 2.4 Add docstring + example to `set-default-view-size`
- [x] 2.5 Add docstring + example to `default-lights`
- [x] 2.6 Add docstring + example to `set-default-view-type`
- [x] 2.7 Add docstring + example to `set-default-gradient`
- [x] 2.8 Add docstring + example to `set-default-lights`

## 3. Lighting (`viewer-lighting.lisp`)

- [x] 3.1 Add docstring to `viewer-light-p` (docstring only)
- [x] 3.2 Add docstring + example to `make-light`
- [x] 3.3 Add docstring + example to `free-light`
- [x] 3.4 Add docstring + example to `viewer-add-light`
- [x] 3.5 Add docstring + example to `viewer-remove-light`
- [x] 3.6 Add docstring + example to `viewer-light-on`
- [x] 3.7 Add docstring + example to `viewer-light-off`
- [x] 3.8 Add docstring + example to `viewer-light-active-p`
- [x] 3.9 Add docstring + example to `set-light-color`
- [x] 3.10 Add docstring + example to `set-light-intensity`
- [x] 3.11 Add docstring + example to `set-light-direction`
- [x] 3.12 Add docstring + example to `set-light-position`
- [x] 3.13 Add docstring + example to `set-light-angle`
- [x] 3.14 Add docstring + example to `set-light-concentration`
- [x] 3.15 Add docstring + example to `set-headlight`
- [x] 3.16 Add docstring + example to `set-light-shadows`
- [x] 3.17 Add docstring + example to `viewer-default-lights`
- [x] 3.18 Add docstring + example to `viewer-lights`
- [x] 3.19 Add docstring + example to `viewer-active-lights`

## 4. Object properties (`viewer-object-props.lisp`)

- [x] 4.1 Add docstring to `material-p` (docstring only)
- [x] 4.2 Add docstring + example to `make-material`
- [x] 4.3 Add docstring + example to `material-preset-list`
- [x] 4.4 Add docstring + example to `ais-set-transparency`
- [x] 4.5 Add docstring + example to `ais-set-custom-material`
- [x] 4.6 Add docstring + example to `ais-set-material`
- [x] 4.7 Add docstring + example to `ais-set-line-width`
- [x] 4.8 Add docstring + example to `ais-show-edges`
- [x] 4.9 Add docstring + example to `ais-set-edge-styling`
- [x] 4.10 Add docstring + example to `ais-set-selection-mode`
- [x] 4.11 Add docstring + example to `ais-set-tessellation`
- [x] 4.12 Add docstring + example to `ais-set-selected`
- [x] 4.13 Add docstring + example to `ais-add-or-remove-selected`
- [x] 4.14 Add docstring + example to `ais-clear-selected`
- [x] 4.15 Add docstring + example to `ais-is-selected`
- [x] 4.16 Add docstring + example to `ais-nb-selected`
- [x] 4.17 Add docstring + example to `ais-init-selected`
- [x] 4.18 Add docstring + example to `ais-more-selected`
- [x] 4.19 Add docstring + example to `ais-next-selected`
- [x] 4.20 Add docstring + example to `ais-selected-interactive`
- [x] 4.21 Add docstring + example to `ais-selected-shape`
- [x] 4.22 Add docstring + example to `ais-has-selected-shape`
- [x] 4.23 Add `Example:` block to `ais-selected-objects` (has docstring, needs example)
- [x] 4.24 Add `Example:` block to `ais-selected-shapes` (has docstring, needs example)
- [x] 4.25 Add docstring + example to `ais-move-to`
- [x] 4.26 Add docstring + example to `ais-select-detected`
- [x] 4.27 Add docstring + example to `ais-select-point`
- [x] 4.28 Add docstring + example to `ais-hilight-selected`
- [x] 4.29 Add docstring + example to `ais-unhilight-selected`
- [x] 4.30 Add docstring + example to `ais-fit-selected`
- [x] 4.31 Add docstring + example to `ais-detected-interactive`
- [x] 4.32 Add docstring + example to `ais-has-detected`
- [x] 4.33 Add docstring + example to `ais-clear-detected`
- [x] 4.34 Add docstring + example to `ais-set-selection-sensitivity`
- [x] 4.35 Add docstring + example to `ais-set-pixel-tolerance`
- [x] 4.36 Add docstring + example to `ais-set-automatic-hilight`
- [x] 4.37 Add docstring + example to `ais-set-to-hilight-selected`

## 5. Drawer (`viewer-drawer.lisp`)

- [x] 5.1 Add docstring + example to `ais-set-drawer-line-color`
- [x] 5.2 Add docstring + example to `ais-set-drawer-line-width`
- [x] 5.3 Add docstring + example to `ais-set-drawer-line-type`
- [x] 5.4 Add docstring + example to `ais-set-drawer-shading-color`
- [x] 5.5 Add docstring + example to `ais-set-drawer-point-color`
- [x] 5.6 Add docstring + example to `ais-set-drawer-point-type`
- [x] 5.7 Add docstring + example to `ais-set-drawer-point-scale`
- [x] 5.8 Add docstring + example to `ais-set-drawer-text-color`
- [x] 5.9 Add docstring + example to `ais-set-drawer-text-font`
- [x] 5.10 Add docstring + example to `ais-set-drawer-text-height`
- [x] 5.11 Add docstring + example to `ais-set-drawer-iso-display`
- [x] 5.12 Add docstring + example to `ais-set-drawer-wire-color`
- [x] 5.13 Add docstring + example to `ais-set-drawer-face-boundaries`
- [x] 5.14 Add docstring + example to `ais-set-drawer-free-boundaries`

## 6. Dimensions (`viewer-dimensions.lisp`)

- [x] 6.1 Add docstring + example to `make-dimension`
- [x] 6.2 Add docstring + example to `set-dimension-text-position`
- [x] 6.3 Add docstring + example to `set-dimension-units`
- [x] 6.4 Add docstring + example to `set-dimension-flyout`
- [x] 6.5 Add docstring + example to `set-dimension-arrow-length`
- [x] 6.6 Add docstring + example to `set-dimension-custom-value`
- [x] 6.7 Add docstring + example to `set-dimension-angle-edges`
- [x] 6.8 Add docstring + example to `set-dimension-extension-size`
- [x] 6.9 Add docstring + example to `set-dimension-measured-edge`
- [x] 6.10 Add docstring + example to `set-dimension-text`
- [x] 6.11 Add docstring + example to `set-dimension-arrows`
- [x] 6.12 Add docstring + example to `set-dimension-extension`

## 7. Text labels (`viewer-text-labels.lisp`)

- [x] 7.1 Add docstring + example to `set-text-label-angle`
- [x] 7.2 Add docstring + example to `set-text-label-hjustification`
- [x] 7.3 Add docstring + example to `set-text-label-vjustification`
- [x] 7.4 Add docstring + example to `set-text-label-display-type`
- [x] 7.5 Add docstring + example to `set-text-label-subtitle-color`
- [x] 7.6 Add docstring + example to `set-text-label-align`
- [x] 7.7 Add docstring + example to `make-text-label`

## 8. Verification

- [x] 8.1 Run `just test-all` to verify no breakage
