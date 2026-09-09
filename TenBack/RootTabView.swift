//
//  RootTabView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                AddGameView()
            }
            .tabItem {
                Label("Add Game", systemImage: "plus.circle.fill")
            }

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

#Preview {
    RootTabView()
        .environment(GameStore())
        .environment(ArsenalStore())
}
