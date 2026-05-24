## ADDED Requirements

### Requirement: Docstrings use Markdown formatting

All public function docstrings SHALL use Markdown formatting compatible with 3bmd (via `staple-markdown`) for documentation generation. The formatting MUST preserve readability in raw REPL display while enabling rich HTML rendering.

#### Scenario: Parameters formatted as bold lowercase in bullet list

- **WHEN** a function has parameters documented in its docstring
- **THEN** each parameter SHALL appear as `- **name** description` with the name matching the lambda-list variable in bold lowercase
- **AND** the `--` separator SHALL NOT be used

#### Scenario: Return values labeled with bold Returns section

- **WHEN** a function docstring documents return values
- **THEN** single return values SHALL use `**Returns:** description` (bold with colon, inline)
- **AND** multiple return values SHALL use `**Returns:**` followed by a bullet list

#### Scenario: nil and t returns use inline code

- **WHEN** `nil` or `t` appear as return values in Returns sections
- **THEN** they SHALL be formatted as `` `nil` `` and `` `t` `` (inline code with backticks)
- **AND** they WILL render as cross-reference links to CLHS via Staple's xref mechanism

#### Scenario: Code examples indented with blank line

- **WHEN** a docstring contains a code example
- **THEN** it SHALL be preceded by `**Example:**` followed by a blank line, then 4-space-indented code
- **AND** example output SHALL use `;; =>` inside the code block

#### Scenario: See also uses inline code references

- **WHEN** a docstring references related functions in a "See also" section
- **THEN** it SHALL be formatted as `**See also:** `func1`, `func2`` with function names in inline code

#### Scenario: Predicate functions use one-liner with Returns label

- **WHEN** a predicate function (returning `t` or `nil`) has a docstring
- **THEN** the format SHALL be: `**Returns:** `t` if `obj` is a `thing` object, `nil` otherwise.`
- **AND** no separate parameter list section is required

#### Scenario: Inline code for function and keyword references

- **WHEN** function names, keywords, types, or parameter names appear in docstring prose
- **THEN** they SHALL be formatted as inline code with backticks (e.g., `` `make-box` ``, `` `:line` ``, `` `shape` ``)

#### Scenario: Minimal transformation

- **WHEN** a docstring has no Example, See also, or explicit Returns section in its current form
- **THEN** no new section SHALL be added; only existing content SHALL be reformatted

### Requirement: Staple configuration for Markdown rendering

The project SHALL include a `staple.ext.lisp` configuration that enables Staple to render docstrings as Markdown with cross-reference linking.

#### Scenario: format-documentation compiles docstrings as Markdown

- **WHEN** Staple generates documentation pages
- **THEN** `format-documentation` SHALL bind `*package*` to the first page package
- **AND** SHALL call `(staple:compile-source docstring :markdown)` to parse Markdown
- **AND** SHALL call `(staple:markup-code-snippets-ignoring-errors)` to xref-link code references

#### Scenario: Packages include cl-occt and cl-occt.impl

- **WHEN** the page type resolves packages for documentation
- **THEN** `:cl-occt` and `:cl-occt.impl` SHALL be included
