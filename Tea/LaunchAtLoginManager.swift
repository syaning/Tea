//
//  LaunchAtLoginManager.swift
//  Tea
//

import Observation
import ServiceManagement

@MainActor
@Observable
final class LaunchAtLoginManager {
    private let service = SMAppService.mainApp

    private(set) var status: SMAppService.Status

    init() {
        status = SMAppService.mainApp.status
    }

    /// Reflects whether the app is set to open at login (including pending approval).
    var isLaunchAtLoginEnabled: Bool {
        switch status {
        case .enabled, .requiresApproval: true
        case .notRegistered: false
        case .notFound: false
        @unknown default: false
        }
    }

    func refresh() {
        status = service.status
    }

    func setLaunchAtLogin(_ enabled: Bool) throws {
        if enabled {
            try service.register()
        } else {
            try service.unregister()
        }
        status = service.status
    }
}
