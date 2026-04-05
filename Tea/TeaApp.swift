//
//  TeaApp.swift
//  Tea
//
//  Created by syaning on 2026/4/4.
//

import SwiftUI

@main
struct TeaApp: App {
    @State private var sleepManager = SleepPreventionManager()
    @State private var launchAtLogin = LaunchAtLoginManager()
    @AppStorage(IconStyle.appStorageKey) private var iconStyleRaw = IconStyle.leaf.rawValue

    private var iconStyle: IconStyle {
        IconStyle(rawValue: iconStyleRaw) ?? .leaf
    }

    var body: some Scene {
        MenuBarExtra("Tea", systemImage: iconStyle.systemImage(isActive: sleepManager.isActive)) {
            TeaMenuView(sleepManager: sleepManager, launchAtLogin: launchAtLogin)
        }
        .menuBarExtraStyle(.menu)
    }
}
