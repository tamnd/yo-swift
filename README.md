# yo-swift

Swift client for [yo](https://github.com/tamnd/yo), an embedded multi-model database that lives in one `.yo` file. Swift types are the schema and there is no query language to learn.

## Status

Early, and honest about it. There is no database in this package yet.

What is here is the error surface from `dx/14` §7 and the version contract: `YoError` with all five fields that cross the C ABI, `YoCode` with the code table, and the constants that pin this package to an engine version. Those are the parts that do not need an engine to exist, and everything else is built on top of them.

The typed collection API arrives with `libyo.xcframework`, which the release train in `tamnd/yo` builds and which gets pinned here as a binary target once `M1` lands a record plane. Until then `swift build` works, `swift test` passes, and neither one opens a file.

The version is `0.0.1` and it means what it says. This package is published so the name is held and the CI is real before either matters.

## Requirements

| | |
|---|---|
| Swift | 6.2 or newer, language mode 6 only |
| macOS | 14 |
| iOS, tvOS | 17 |
| watchOS | 10 |
| visionOS | 1 |
| Linux | any distribution the Swift toolchain supports |

The floor is current minus one. Apple ships the toolchain inside Xcode so adoption is fast, and `Span` and `RawSpan` are load-bearing for the zero-copy row surface that arrives with the engine. Neither exists before 6.2.

There is no Swift 5 language mode and there will not be one. The `Sendable` annotations on the handle types are the whole point of them, and mode 5 downgrades those checks to warnings.

## Install

```swift
.package(url: "https://github.com/tamnd/yo-swift", from: "0.0.1")
```

Then add `Yodb` to your target's dependencies.

## Errors

Every failure is a `YoError`, and it carries five fields rather than a flattened string.

```swift
do {
    let user = try db.users.get(1)
} catch let error as YoError {
    print(error.code)      // .shapeMismatch
    print(error.position)  // "users.score"
    print(error.url)       // https://yo.tamnd.dev/errors/shape-mismatch
    print(error.detail)    // the field by field diff, multi-line
    print(error)           // all of it, nothing truncated
}
```

`YoCode` is deliberately not `@frozen`. Adding an error code should not be a source break in every exhaustive switch a caller has written, and `errors.toml` grows every milestone, so write `@unknown default` and a new code arrives as a runtime case instead of someone else's failed build.

Printing a `YoError` prints all of it. `LocalizedError` flattens an error to one line, which is exactly the failure this type exists to avoid: a shape mismatch whose diff got cut off is worse than no diff at all, because it looks like the whole answer.

## Building on this repository

```
swift build
swift test
swift format lint --strict --recursive Sources Tests Package.swift
```

CI runs the tests on Linux against both 6.2 and 6.3 and on macOS against 6.3, builds the iOS, tvOS, watchOS and visionOS slices, and resolves the package from a clean clone with no `Package.resolved` because that is what a user actually gets.

`Package.resolved` is not committed. A library that pins its dependency graph forces that graph onto every app depending on it, and the app is the one that should be resolving.

## Licence

Apache 2.0 or MIT, at your option. See [LICENSE-APACHE](LICENSE-APACHE) and [LICENSE-MIT](LICENSE-MIT).
