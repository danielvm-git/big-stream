import Foundation
import Observation

@Observable @MainActor final class AppState {
    private let logger: JSONLogger

    init(logger: JSONLogger = JSONLogger.shared) {
        self.logger = logger
        Task { await self.logger.log(level: "info", message: "AppState.init") }
    }
}
