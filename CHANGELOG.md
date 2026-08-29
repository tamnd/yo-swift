# Changelog

Every tier 1 and tier 2 SDK shares one version number with the engine, so a version that appears here appears in every other binding on the same day.

Pre 1.0 a minor release may break the API. When it does, the entry says so on its first line rather than in a note further down.

## [0.0.2]

Still a name reservation, and the first one this package could be said to hold honestly.

Every yo placeholder in every ecosystem carries one symbol that fails with the same sentence, so a user who hits it in two languages does not have to work out whether they are two different problems. This package had no such symbol. It resolved, it imported, and there was nothing in it a caller could reach, so the sentence existed nowhere in it. That was invisible for as long as SwiftPM was the only way in, since a git dependency is closer to a pointer than to a published artifact. It stopped being invisible when these same sources were pointed at by a CocoaPods podspec, where `pod 'Yodb'` publishes into an index and compiles for five platforms.

- `Yodb.open(_:)`, which throws `YoError(code: .unsupported)` carrying the shared sentence and the path it was given. It returns `Never` because it never returns; the signature changes when `M1` lands a record plane and there is a handle to hand back.
- `Yodb.version` is `0.0.2`.
- The sentence is built from `version` rather than written out, so republishing cannot leave it naming a version that is no longer on any registry. Six ecosystems shipped exactly that before it was true of them either.

## [0.0.1]

Still a name reservation. This release exists so that one version number means one artifact across every ecosystem on the same day, which it stopped meaning when the Node placeholder had to be republished to correct the sentence it was serving.

- `Yodb.version` is `0.0.1`.
- No API change, no behaviour change. There is still no database.

## [0.0.0]

The name reservation release. It holds `yo-swift` as a resolvable SwiftPM package and nothing more.

- `YoCode`, the error code table from `dx/02` §2. Not `@frozen`, so a new code is a runtime case rather than a source break.
- `YoError` with all five fields that cross the C ABI: code, message, position, url and the multi-line detail that carries the shape diff.
- `Yodb.version`, `Yodb.abiVersion` and `Yodb.formatVersion`, which pin this package to an engine build.
- CI on Linux and macOS, the four Apple platform slices, and a clean-clone resolve.

There is no database. `swift test` passes without opening a file, which is the point of a reservation release.
