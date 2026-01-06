# Changelog

All notable changes to this project are documented in this file.

## [3.0.2] - 2026-01-06
### Added
- CMake-based **portable core** (`include/` + `src/`) to allow core logic to be tested in user-mode.
- Unit tests for portable core using Catch2 (`tests/`).
- GitHub Actions CI workflow for Windows: builds portable lib, runs `cppcheck`, executes unit tests, and uploads build artifacts.
- `DEVELOPMENT.md` with developer guidance and CI notes.

### Changed
- Bumped driver and package version to **3.0.2** across sources and packaging (`mahf_core.c`, `mahf_service.c`, `setup.iss`, `install.bat`, `mahf_cpu.inf`, `README.md`).
- `mahf_cpu.inf` DriverVer updated to `01/06/2026,3.0.2.1`.

### Fixed
- Minor documentation fixes and packaging filename updates for the installer.

### Notes
- This release focuses on developer productivity and safety: testability and CI. Future work planned: integrate clang-tidy, add ETW tracing, add WDK builds and signed artifacts in CI, and expand unit/integration test coverage.
