//
//  TeaMenuView.swift
//  Tea
//

import AppKit
import SwiftUI

struct TeaMenuView: View {
    var sleepManager: SleepPreventionManager
    @Bindable var launchAtLogin: LaunchAtLoginManager

    @AppStorage(IconStyle.appStorageKey) private var iconStyleRaw = IconStyle.leaf.rawValue
    @AppStorage(SleepPreventionManager.autoStartEnabledKey) private var autoStartOnLaunch = false

    var body: some View {
        if sleepManager.isActive {
            VStack(alignment: .leading, spacing: 4) {
                if let end = sleepManager.sessionEndsAt {
                    Text("Ends \(end.formatted(date: .abbreviated, time: .shortened))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Indefinite")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Button("End Session") {
                    sleepManager.cancel()
                }
                .keyboardShortcut("x", modifiers: [.command])
            }
        }

        Menu("Keep Awake") {
            ForEach(SleepPreventionManager.Duration.allCases) { d in
                Button(d.title) {
                    sleepManager.start(duration: d)
                }
            }
        }

        Divider()

        Menu("Menu Bar Icon") {
            Picker("", selection: $iconStyleRaw) {
                ForEach(IconStyle.allCases) { style in
                    Label(style.menuTitle, systemImage: style.systemImage(isActive: false))
                        .tag(style.rawValue)
                }
            }
            .labelsHidden()
            .pickerStyle(.inline)
        }

        Toggle("Keep Awake on Launch", isOn: $autoStartOnLaunch)

        Toggle("Launch at Login", isOn: Binding(
            get: { launchAtLogin.isLaunchAtLoginEnabled },
            set: { newValue in
                Task { @MainActor in
                    try? launchAtLogin.setLaunchAtLogin(newValue)
                }
            }
        ))
        .onAppear { launchAtLogin.refresh() }

        Divider()

        Button("Quit Tea") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: [.command])
    }
}
