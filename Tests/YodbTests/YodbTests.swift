import Foundation
import Testing

@testable import Yodb

@Suite("error codes")
struct YoCodeTests {
    @Test("wire names are screaming snake case and non-empty")
    func wireNamesAreWellFormed() {
        for code in YoCode.allCases {
            #expect(!code.wireName.isEmpty)
            #expect(code.wireName == code.wireName.uppercased())
            #expect(!code.wireName.contains(" "))
        }
    }

    @Test("wire names are unique")
    func wireNamesAreUnique() {
        let names = Set(YoCode.allCases.map(\.wireName))
        #expect(names.count == YoCode.allCases.count)
    }

    @Test("raw values are unique and never reused")
    func rawValuesAreUnique() {
        let values = Set(YoCode.allCases.map(\.rawValue))
        #expect(values.count == YoCode.allCases.count)
    }

    @Test("slugs are url safe")
    func slugsAreURLSafe() {
        for code in YoCode.allCases {
            #expect(code.slug == code.slug.lowercased())
            #expect(!code.slug.contains("_"))
            #expect(code.slug.allSatisfy { $0.isLetter || $0.isNumber || $0 == "-" })
        }
    }

    @Test("only the codes that can clear on their own are retryable")
    func retryabilityMatchesTheTable() {
        #expect(YoCode.timeout.isRetryable)
        #expect(YoCode.locked.isRetryable)
        #expect(YoCode.epochStalled.isRetryable)
        #expect(!YoCode.shapeMismatch.isRetryable)
        #expect(!YoCode.corrupt.isRetryable)
        #expect(!YoCode.notFound.isRetryable)
    }
}

@Suite("errors")
struct YoErrorTests {
    @Test("a url is always present, even when the caller passes none")
    func urlDefaultsFromCode() {
        let error = YoError(code: .shapeMismatch, message: "types differ")
        #expect(error.url.absoluteString == "https://yo.tamnd.dev/errors/shape-mismatch")
    }

    @Test("retryable defaults from the code and can be overridden")
    func retryableDefaultsFromCode() {
        #expect(YoError(code: .timeout, message: "slow").retryable)
        #expect(!YoError(code: .corrupt, message: "bad page").retryable)
        #expect(YoError(code: .corrupt, message: "bad page", retryable: true).retryable)
    }

    @Test("description carries every field and truncates none of them")
    func descriptionIsComplete() {
        let diff = """
            - score: Float
            + score: Double
            """
        let error = YoError(
            code: .shapeMismatch,
            message: "the type passed to docs() does not match the stored collection",
            position: "users.score",
            detail: diff
        )
        let rendered = error.description

        #expect(rendered.contains("SHAPE_MISMATCH"))
        #expect(rendered.contains("users.score"))
        #expect(rendered.contains("- score: Float"))
        #expect(rendered.contains("+ score: Double"))
        #expect(rendered.contains("https://yo.tamnd.dev/errors/shape-mismatch"))
    }

    @Test("a missing position or detail leaves no empty section behind")
    func descriptionSkipsAbsentFields() {
        let rendered = YoError(code: .closed, message: "handle is closed").description
        #expect(!rendered.contains("at:"))
        #expect(rendered.contains("CLOSED: handle is closed"))
    }
}

@Suite("package constants")
struct YodbTests {
    @Test("the documentation host has no trailing slash to double up on")
    func documentationHostIsClean() {
        #expect(Yodb.documentationHost.absoluteString == "https://yo.tamnd.dev")
    }

    @Test("every code has a documentation url under the errors path")
    func everyCodeHasADocumentationURL() {
        for code in YoCode.allCases {
            let url = Yodb.documentationURL(for: code)
            #expect(url.absoluteString.hasPrefix("https://yo.tamnd.dev/errors/"))
        }
    }

    @Test("the version is a three part semantic version")
    func versionIsSemantic() {
        let parts = Yodb.version.split(separator: ".")
        #expect(parts.count == 3)
        #expect(parts.allSatisfy { UInt($0) != nil })
    }
}

@Suite("the placeholder")
struct PlaceholderTests {
    /// The sentence, spelled out here rather than built from `Yodb.version`.
    ///
    /// A test that assembles the string the same way the code does passes
    /// whatever the code assembles, which is no test at all. This is the one
    /// place the wording is written by hand, and it is the same wording
    /// `reserve.py` generates for the other seven ecosystems, so if either side
    /// is edited alone this fails.
    static let sentence =
        "yo is not usable yet. This is a reserved placeholder at 0.0.2; "
        + "see https://github.com/tamnd/yo"

    @Test("open throws, and says the same thing every other binding says")
    func openThrowsTheSharedSentence() {
        #expect(throws: YoError.self) { try Yodb.open("x.yo") }
        do {
            try Yodb.open("x.yo")
        } catch let error as YoError {
            #expect(error.code == .unsupported)
            #expect(error.message == Self.sentence)
            #expect(error.position == "x.yo")
            #expect(!error.retryable)
            // What a user actually sees when they print it. The install matrix
            // greps for the sentence in the rendered output, not in the field.
            #expect(error.description.contains(Self.sentence))
        } catch {
            Issue.record("threw \(type(of: error)) rather than YoError")
        }
    }

    @Test("the sentence names the version of the package it ships in")
    func sentenceNamesItsOwnVersion() {
        #expect(Self.sentence.contains("at \(Yodb.version);"))
    }
}
