import SwiftUI


@MainActor
final class SSOKeepAliveService: ObservableObject {
    // 這只針對在主頁進行閒置時
    private var task: Task<Void, Never>?
    private let interval: UInt64 = 5 * 60 * 1_000_000_000  // 5 分鐘

    func start(with session: SessionManager) {
        // 若已在跑就不重複啟動
        guard task == nil else { return }

        task = Task { [weak session] in
            guard let session else { return }

            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: interval)
                // 刷新 SSOID
                session.refreshSSOID()
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }
}
