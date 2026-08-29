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
    public static let version = "0.0.2"

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

    /// Opens a database, once there is one to open.
    ///
    /// Every yo placeholder in every ecosystem carries one symbol that fails
    /// with the same sentence, so a user who hits it in two languages does not
    /// have to work out whether they are looking at two different problems.
    /// This is Swift's, and until 2026-08-29 it was the only binding that did
    /// not have one: the package resolved, imported, and had nothing in it a
    /// caller could reach. That was invisible for as long as SwiftPM was the
    /// only way in, and it stopped being invisible when the same sources went
    /// to CocoaPods as a published pod.
    ///
    /// It returns `Never` because it never returns. The signature changes when
    /// M1 lands a record plane and there is a handle to hand back. The version
    /// is `0.0.x` and a minor may break the API before 1.0, which is what that
    /// allowance is for.
    public static func open(_ path: String) throws -> Never {
        throw YoError(
            code: .unsupported,
            // Built from `version` rather than written out, because the one
            // useful thing in this sentence is the number and a literal copy of
            // it goes stale the first time the placeholder is republished. Six
            // ecosystems shipped a sentence naming 0.0.0 from a 0.0.1 artifact
            // before this was true of them either.
            message: "yo is not usable yet. This is a reserved placeholder at "
                + "\(version); see https://github.com/tamnd/yo",
            position: path
        )
    }
}
