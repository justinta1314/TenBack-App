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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .environment(store)
        }
    }
}
