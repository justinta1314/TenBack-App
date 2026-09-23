//
//  TenBackApp.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

@main
struct TenBackApp: App {
    @State private var store = GameStore()
    @State private var arsenalStore = ArsenalStore()
    @AppStorage("appearanceMode") private var appearanceModeRaw: String = AppearanceMode.system.rawValue

    private var appearanceMode: AppearanceMode {
        AppearanceMode(rawValue: appearanceModeRaw) ?? .system
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(store)
                .environment(arsenalStore)
                .preferredColorScheme(appearanceMode.colorScheme)
        }
    }
}
