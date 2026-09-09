//
//  ProfileView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(ArsenalStore.self) private var arsenalStore
    @State private var showingAddBall = false
    @State private var editingBall: BowlingBall? = nil

    var body: some View {
        List {
            Section {
                // Placeholder for future account info (name, sign-in status, etc.)
                Text("Profile")
                    .font(.title2.bold())
            }

            Section("My Arsenal") {
                if arsenalStore.balls.isEmpty {
                    Text("No balls added yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(arsenalStore.balls) { ball in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(ball.name)
                                .font(.headline)
                            Text("\(ball.brand) · \(ball.weight) lbs" + (ball.coverstock.map { " · \($0)" } ?? ""))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editingBall = ball
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            arsenalStore.deleteBall(arsenalStore.balls[index])
                        }
                    }
                }

                Button {
                    showingAddBall = true
                } label: {
                    Label("Add a ball", systemImage: "plus")
                }
            }
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $showingAddBall) {
            AddBallView()
        }
        .sheet(item: $editingBall) { ball in
            AddBallView(existingBall: ball)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(ArsenalStore())
}
