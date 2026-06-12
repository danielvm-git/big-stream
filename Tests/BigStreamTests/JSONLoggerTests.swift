import Testing
import Foundation
@testable import BigStream

@Suite("JSONLogger")
struct JSONLoggerTests {
    private func tempDir() -> URL {
        let dir = FileManager.default.temporaryDirectory
            .appending(path: "bigstream-logger-test-\(UUID().uuidString)")
        return dir
    }

    @Test("Creates directory and writes valid JSON lines")
    func writesValidJSONLines() async throws {
        let dir = tempDir()
        let logger = JSONLogger(logDirectory: dir)
        await logger.log(level: "info", message: "hello", context: ["key": "value"])

        let logFile = dir.appending(path: "app-state.log")
        let contents = try String(contentsOf: logFile, encoding: .utf8)
        let lines = contents.split(separator: "\n", omittingEmptySubsequences: true)
        #expect(lines.count == 1)

        let data = Data(lines[0].utf8)
        let obj = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        #expect(obj["timestamp"] != nil)
        #expect(obj["level"] as? String == "info")
        #expect(obj["message"] as? String == "hello")
        #expect(obj["pid"] != nil)
        let context = obj["context"] as? [String: String]
        #expect(context?["key"] == "value")
    }

    @Test("Creates log directory if missing")
    func createsDirectoryIfMissing() async throws {
        let dir = tempDir()
        #expect(!FileManager.default.fileExists(atPath: dir.path))
        let logger = JSONLogger(logDirectory: dir)
        await logger.log(level: "debug", message: "test")
        #expect(FileManager.default.fileExists(atPath: dir.path))
    }

    @Test("Rotates log file when size threshold exceeded")
    func rotatesLogFile() async throws {
        let dir = tempDir()
        let logger = JSONLogger(logDirectory: dir, maxFileSize: 10)
        await logger.log(level: "info", message: "first line that exceeds threshold")
        await logger.log(level: "info", message: "second line after rotation")

        let rotated = dir.appending(path: "app-state.log.1")
        let current = dir.appending(path: "app-state.log")
        #expect(FileManager.default.fileExists(atPath: rotated.path))
        #expect(FileManager.default.fileExists(atPath: current.path))
    }
}
