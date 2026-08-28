/// The error codes the engine can return.
///
/// Generated from `errors.toml` in `tamnd/yo` once the release train wires the
/// generator up. The values here are hand-written against `dx/02` §2's table and
/// are checked against the published `errors.toml` by CI, so the two cannot
/// drift without a red build.
///
/// This enum is deliberately **not** `@frozen`. Freezing it would turn every
/// added error code into a source break in every exhaustive switch a caller has
/// written, and `errors.toml` grows every milestone. Write `@unknown default`
/// and a new code arrives as a runtime case rather than a compile failure in
/// someone else's release.
///
/// Numbers are allocated once and never reused, so an integer read from an old
/// file or an old peer still means what it meant.
public enum YoCode: UInt32, Sendable, Hashable, CaseIterable {
    case ok = 0
    case notFound = 1
    case wrongType = 2
    case shapeMismatch = 3
    case locked = 4
    case corrupt = 5
    case io = 6
    case invalidArgument = 7
    case outOfMemory = 8
    case unsupported = 9
    case closed = 10
    case timeout = 11
    case epochStalled = 12
    case versionTooNew = 13
}

extension YoCode {
    /// The stable screaming-snake spelling, which is what the wire, the CLI's
    /// `--json` output and the docs URLs all use.
    ///
    /// Swift's own camel case is for Swift callers. Everything that crosses a
    /// boundary uses this spelling, so a Swift user grepping a server log for a
    /// code they caught finds it.
    public var wireName: String {
        switch self {
        case .ok: "OK"
        case .notFound: "NOT_FOUND"
        case .wrongType: "WRONG_TYPE"
        case .shapeMismatch: "SHAPE_MISMATCH"
        case .locked: "LOCKED"
        case .corrupt: "CORRUPT"
        case .io: "IO"
        case .invalidArgument: "INVALID_ARGUMENT"
        case .outOfMemory: "OUT_OF_MEMORY"
        case .unsupported: "UNSUPPORTED"
        case .closed: "CLOSED"
        case .timeout: "TIMEOUT"
        case .epochStalled: "EPOCH_STALLED"
        case .versionTooNew: "VERSION_TOO_NEW"
        }
    }

    /// The slug used in the documentation URL for this code.
    public var slug: String {
        wireName.lowercased().replacingOccurrences(of: "_", with: "-")
    }

    /// Whether retrying the same call unchanged could plausibly succeed.
    ///
    /// This is advice for a retry loop, not a promise. A `timeout` may succeed
    /// on a second attempt; a `shapeMismatch` never will, because nothing about
    /// waiting changes the type the caller passed.
    public var isRetryable: Bool {
        switch self {
        case .locked, .timeout, .epochStalled: true
        default: false
        }
    }
}
