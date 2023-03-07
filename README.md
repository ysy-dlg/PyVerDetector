# PyVerDetector

*PyVerDetector* is a Chrome extension for Stack Overflow that  detects whether a given code snippet can be interpreted with the selected Python version.

## Building

In order to build *PyVerDetector*, [flex](https://github.com/westes/flex), [bison](https://www.gnu.org/software/bison/) version 3.0 or higher and [emscripten](https://emscripten.org/) are required as dependencies.
Note that these are build-time dependencies only, and are not required for the extension to run.
In addition, to run the version checker locally, decoupled from the extension, a compiler like `gcc` or `clang` is also required.

Additionally, on macOS, the default bison version is too old and must be upgraded, and GNU sed is required instead of the BSD one. These two tools must be in PATH instead of their default counterpart.

To build the extension, run `make` from the project root. This will generate additional files in the `unpacked/` folder and finalize the extension code.
This will generate also a standalone version checked in the folder `backend/build` called `pyverdetector` that can be run as `pyverdetector <file to check>`.

## Credits
This project is inspired by the research work of Malloy and Power in [`MalloyPower/python-compliance`](https://github.com/MalloyPower/python-compliance).
