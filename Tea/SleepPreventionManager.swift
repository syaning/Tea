//
//  SleepPreventionManager.swift
//  Tea
//

import Foundation
import Observation

@MainActor
@Observable
final class SleepPreventionManager {
    private var activity: NSObjectProtocol?
    private var endTask: Task<Void, Never>?

    var isActive: Bool { activity != nil }

    // When the timed session ends; `nil` for indefinite sessions.
    private(set) var sessionEndsAt: Date?

    enum Duration: CaseIterable {
        case indefinite
        case minutes15
        case minutes30
        case hour1
        case hour2
        case hour4

        var title: String {
            switch self {
            case .indefinite: return "Indefinite"
            case .minutes15: return "15 minutes"
            case .minutes30: return "30 minutes"
            case .hour1: return "1 hour"
            case .hour2: return "2 hours"
            case .hour4: return "4 hours"
            }
        }

        var timeInterval: TimeInterval? {
            switch self {
            case .indefinite: return nil
            case .minutes15: return 15 * 60
            case .minutes30: return 30 * 60
            case .hour1: return 3600
            case .hour2: return 2 * 3600
            case .hour4: return 4 * 3600
            }
        }
    }

    func start(duration: Duration) {
        cancel()
        let reason = "Tea is keeping the system and display awake"
        activity = ProcessInfo.processInfo.beginActivity(
            options: [.idleSystemSleepDisabled, .idleDisplaySleepDisabled],
            reason: reason
        )

        if let seconds = duration.timeInterval {
            sessionEndsAt = Date().addingTimeInterval(seconds)
            endTask = Task { @MainActor in
                let ns = UInt64(seconds * 1_000_000_000)
                try? await Task.sleep(nanoseconds: ns)
                guard !Task.isCancelled else { return }
                self.endActivityOnly()
            }
        } else {
            sessionEndsAt = nil
        }
    }

    func cancel() {
        endTask?.cancel()
        endActivityOnly()
    }

    private func endActivityOnly() {
        endTask = nil
        sessionEndsAt = nil
        if let activity {
            ProcessInfo.processInfo.endActivity(activity)
            self.activity = nil
        }
    }
}
