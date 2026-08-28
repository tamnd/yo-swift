// URL is part of this file's public API, so the import has to be public too.
// InternalImportsByDefault is on in Package.swift and this is the whole reason
// to turn it on: it makes a leaked internal type a compile error rather than a
// resilience problem someone finds later.
public import Foundation

/// The package's own constants, and the things that are true before an engine
/// is linked in.
///
/// There is no database here yet. `libyo.xcframework` is built by the release
/// train in `tamnd/yo` and pinned into `Package.swift` as a binary target once
/// M1 lands a record plane, and the typed collection API arrives with it. What
/// is in this package today is the error surface and the version contract,
/// which are the parts that do not need the engine to exist and which every
/// other part will be built on top of.
public enum Yodb {
    /// The version of this package.
    ///
    /// Every tier 1 and tier 2 SDK shares one version number with the engine.
    /// A binding does not get its own version line, because a user asking
    /// "which Yodb do I need for yo 1.4" is a question the project inflicted on
    /// itself.
    public static let version = "0.0.1"

    /// The C ABI version this package is built against.
    ///
    /// Separate from `version` and much slower moving. It is frozen at M6 and a
    /// minor release never bumps it.
    public static let abiVersion = 0

    /// The on-disk format version this package can open.
    ///
    /// Also separate, also frozen at M6. A file written by a newer format
    /// version fails to open with `YoCode.versionTooNew` rather than being
    /// read incorrectly.
    public static let formatVersion = 0

    /// Where the documentation lives.
    public static let documentationHost = URL(string: "https://yo.tamnd.dev")!

    /// The documentation page for an error code.
    public static func documentationURL(for code: YoCode) -> URL {
        documentationHost
            .appending(path: "errors")
            .appending(path: code.slug)
    }
}
