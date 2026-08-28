// URL is part of this file's public API, so the import has to be public too.
// InternalImportsByDefault is on in Package.swift and this is the whole reason
// to turn it on: it makes a leaked internal type a compile error rather than a
// resilience problem someone finds later.
public import Foundation

/// Everything that can go wrong, with all five fields that cross the C ABI.
///
/// A binding that flattens this to a message string fails the binding checklist,
/// and it fails the users too. The multi-line `detail` is where the shape diff
/// lives, and a shape diff is the single most useful thing this database can
/// hand back when a call fails.
public struct YoError: Error, Sendable, Hashable {
    /// What went wrong, as a code that is stable across releases.
    public let code: YoCode

    /// One line, in English, saying what happened. Never empty.
    public let message: String

    /// Where it happened: a key, a field name, a path, or a byte offset.
    ///
    /// `nil` when the failure is not attached to a position, which is the case
    /// for things like `closed` and `outOfMemory`.
    public let position: String?

    /// The documentation page for this code. Always present.
    ///
    /// Every URL that can appear here is checked by CI against the live docs
    /// site, so an error message never sends a user to a 404.
    public let url: URL

    /// Whether retrying unchanged could plausibly succeed.
    public let retryable: Bool

    /// The long form, when there is one. Multi-line, and for a shape mismatch
    /// this is the field-by-field diff between what was stored and what was
    /// asked for.
    public let detail: String?

    public init(
        code: YoCode,
        message: String,
        position: String? = nil,
        url: URL? = nil,
        retryable: Bool? = nil,
        detail: String? = nil
    ) {
        self.code = code
        self.message = message
        self.position = position
        self.url = url ?? Yodb.documentationURL(for: code)
        self.retryable = retryable ?? code.isRetryable
        self.detail = detail
    }
}

extension YoError: CustomStringConvertible {
    /// Renders every field, and truncates none of them.
    ///
    /// `LocalizedError` habitually flattens an error to a single line, which is
    /// exactly the failure this type exists to avoid. Swift programs print their
    /// errors, so the printed form has to be the useful one.
    public var description: String {
        var out = "\(code.wireName): \(message)"
        if let position {
            out += "\n  at: \(position)"
        }
        if let detail {
            out += "\n\n\(detail)"
        }
        out += "\n\nsee: \(url.absoluteString)"
        return out
    }
}

extension YoError: CustomDebugStringConvertible {
    public var debugDescription: String { description }
}
