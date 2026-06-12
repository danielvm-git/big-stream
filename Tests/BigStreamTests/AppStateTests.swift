import Foundation
import Testing
@testable import BigStream

@Suite("AppState")
struct AppStateTests {
    @Test("AppState initializes on MainActor")
    @MainActor func appStateInitializesOnMainActor() {
        let testDir = URL.temporaryDirectory.appending(path: "bigstream-test-\(UUID().uuidString)")
        let logger = JSONLogger(logDirectory: testDir)
        let state = AppState(logger: logger)
        #expect(type(of: state) == AppState.self)
    }
}
