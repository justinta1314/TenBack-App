//
//  DashboardView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct DashboardView: View {
    @Environment(GameStore.self) private var store

    var body: some View {
        VStack {
            Text("Dashboard").font(.largeTitle)

            if store.games.isEmpty {
                Text("No games yet — tap the Add Game tab to get started!")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                List(store.games) { game in
                    HStack {
                        Text(game.date.formatted(date: .abbreviated, time: .shortened))
                        Spacer()
                        Text("Score: \(game.totalScore)")
                            .font(.headline)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
    .environment(GameStore())
}
