# Changelog

Every tier 1 and tier 2 SDK shares one version number with the engine, so a version that appears here appears in every other binding on the same day.

Pre 1.0 a minor release may break the API. When it does, the entry says so on its first line rather than in a note further down.

## [0.0.0]

The name reservation release. It holds `yo-swift` as a resolvable SwiftPM package and nothing more.

- `YoCode`, the error code table from `dx/02` §2. Not `@frozen`, so a new code is a runtime case rather than a source break.
- `YoError` with all five fields that cross the C ABI: code, message, position, url and the multi-line detail that carries the shape diff.
- `Yodb.version`, `Yodb.abiVersion` and `Yodb.formatVersion`, which pin this package to an engine build.
- CI on Linux and macOS, the four Apple platform slices, and a clean-clone resolve.

There is no database. `swift test` passes without opening a file, which is the point of a reservation release.
