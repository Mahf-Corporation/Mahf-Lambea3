# Development Notes & CI 🔧

This repo now contains a minimal CI and test setup to make iterative improvements safer.

What was added:

- CMake-based **portable core** (`include/` + `src/`) so some core logic can be tested in user-mode.
- Unit tests in `tests/` using Catch2 (fetched via CMake's FetchContent).
- GitHub Actions workflow `.github/workflows/ci.yml` that builds the portable core on Windows, runs `cppcheck`, runs unit tests, and uploads artifacts.

How to build locally:

```powershell
mkdir build
cd build
cmake -G "Visual Studio 17 2022" -A x64 ..
cmake --build . --config Release
ctest -C Release
```

Suggested next steps (I can implement):
- Integrate clang-tidy and clang-format into CI (clang-tidy added; currently reports issues and uploads a report, will add baseline and stricter failure policy next).
- Expand portable core to extract more testable logic from kernel sources
- Add a driver-build job (WDK) in a separate workflow (may require self-hosted runner or secrets for signing)
- Add static analysis enforcement in PRs and fail the pipeline on regressions

Tell me which item you'd like me to pick next and I'll proceed.