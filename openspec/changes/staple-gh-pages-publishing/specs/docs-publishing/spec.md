## ADDED Requirements

### Requirement: CI generates Staple HTML docs
The system SHALL generate HTML documentation using Staple on every push to the `main` branch.

#### Scenario: Successful doc generation
- **WHEN** a push is made to the `main` branch
- **THEN** the CI workflow loads the `cl-occt` system and all dependencies
- **THEN** the CI workflow calls Staple to generate HTML documentation
- **THEN** the generated HTML files appear in the `docs/` output directory

#### Scenario: Doc generation with missing Quicklisp dependency
- **WHEN** Staple or its dependencies (`staple-markdown`, `3bmd`) are not available in Quicklisp
- **THEN** the workflow SHALL fail with a clear error message
- **THEN** no deployment SHALL occur

### Requirement: CI deploys docs to GitHub Pages
The system SHALL deploy the generated documentation to GitHub Pages.

#### Scenario: Successful deployment
- **WHEN** Staple has generated HTML docs into `docs/`
- **THEN** the workflow deploys the `docs/` directory to the `gh-pages` branch
- **THEN** the deployed site is accessible at the repository's GitHub Pages URL

#### Scenario: Deployment skipped on generation failure
- **WHEN** the Staple generation step fails
- **THEN** the workflow SHALL NOT run the deployment step

### Requirement: Local doc generation via justfile
The system SHALL provide a `just docs` recipe for local documentation generation.

#### Scenario: Local generation succeeds
- **WHEN** a developer runs `just docs`
- **THEN** SBCL loads the `cl-occt` system with Quicklisp
- **THEN** Staple generates HTML docs into `docs/`
- **THEN** the developer can open the generated HTML files locally

#### Scenario: Local generation without Quicklisp
- **WHEN** a developer runs `just docs` without Quicklisp installed
- **THEN** the command SHALL fail with an error indicating Quicklisp is required

### Requirement: OCCT build is cached between workflows
The doc workflow SHALL reuse the OCCT build cache created by `pr-check.yml` to avoid redundant builds.

#### Scenario: Cache hit
- **WHEN** the OCCT build is cached from a previous workflow run
- **THEN** the workflow restores `.local/` from cache
- **THEN** the workflow skips the OCCT build step and proceeds directly to compiling the C wrapper

#### Scenario: Cache miss
- **WHEN** the OCCT build is not cached
- **THEN** the workflow downloads and builds OCCT from source
- **THEN** the workflow caches `.local/` for future runs
