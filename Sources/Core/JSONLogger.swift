import Foundation

actor JSONLogger {
    static let shared = JSONLogger()

    private let logDirectory: URL
    private let maxFileSize: Int
    private var fileHandle: FileHandle?

    init(logDirectory: URL? = nil, maxFileSize: Int = 50 * 1024 * 1024) {
        if let logDirectory {
            self.logDirectory = logDirectory
        } else {
            let library = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
                ?? FileManager.default.temporaryDirectory
            self.logDirectory = library.appending(path: "Logs/BigStream")
        }
        self.maxFileSize = maxFileSize
    }

    private var logFileURL: URL {
        logDirectory.appending(path: "app-state.log")
    }

    func log(level: String, message: String, context: [String: String] = [:]) {
        do {
            try ensureDirectoryExists()
            try rotateIfNeeded()
            let entry = buildEntry(level: level, message: message, context: context)
            try append(entry)
        } catch {
            // Never throw to callers
        }
    }

    private func ensureDirectoryExists() throws {
        let manager = FileManager.default
        if !manager.fileExists(atPath: logDirectory.path) {
            try manager.createDirectory(at: logDirectory, withIntermediateDirectories: true)
        }
    }

    private func rotateIfNeeded() throws {
        let manager = FileManager.default
        let path = logFileURL.path
        guard manager.fileExists(atPath: path) else { return }
        let attrs = try manager.attributesOfItem(atPath: path)
        let size = (attrs[.size] as? Int) ?? 0
        if size >= maxFileSize {
            let rotated = logDirectory.appending(path: "app-state.log.1")
            if manager.fileExists(atPath: rotated.path) {
                try manager.removeItem(at: rotated)
            }
            try manager.moveItem(at: logFileURL, to: rotated)
            fileHandle?.closeFile()
            fileHandle = nil
        }
    }

    private func append(_ line: String) throws {
        let data = Data((line + "\n").utf8)
        if fileHandle == nil {
            let manager = FileManager.default
            if !manager.fileExists(atPath: logFileURL.path) {
                manager.createFile(atPath: logFileURL.path, contents: nil)
            }
            fileHandle = try FileHandle(forWritingTo: logFileURL)
            fileHandle?.seekToEndOfFile()
        }
        fileHandle?.write(data)
    }

    private func buildEntry(level: String, message: String, context: [String: String]) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let timestamp = formatter.string(from: Date())
        let pid = Int(ProcessInfo.processInfo.processIdentifier)

        let payload: [String: Any] = [
            "timestamp": timestamp,
            "level": level,
            "message": message,
            "context": context,
            "pid": pid
        ]

        if let data = try? JSONSerialization.data(withJSONObject: payload),
           let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "{\"level\":\"\(level)\",\"message\":\"\(message)\"}"
    }
}
