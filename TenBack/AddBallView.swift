//
//  AddBallView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

/// Used for both adding a new ball and editing an existing one.
/// Pass `existingBall` when editing; leave it nil when adding.
struct AddBallView: View {
    @Environment(ArsenalStore.self) private var arsenalStore
    @Environment(\.dismiss) private var dismiss

    var existingBall: BowlingBall? = nil

    @State private var name: String = ""
    @State private var brand: String = ""
    @State private var weight: Int = 15
    @State private var coverstock: String = ""
    @State private var notes: String = ""

    private var isEditing: Bool { existingBall != nil }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !brand.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Ball Info") {
                    TextField("Name (e.g. My Phaze II)", text: $name)
                    TextField("Brand (e.g. Storm)", text: $brand)
                    Stepper("Weight: \(weight) lbs", value: $weight, in: 6...16)
                }

                Section("Optional") {
                    TextField("Coverstock", text: $coverstock)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }

                if isEditing {
                    Section {
                        Button("Delete Ball", role: .destructive) {
                            deleteBall()
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Ball" : "Add a Ball")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave)
                }
            }
            .onAppear {
                loadExistingBallIfNeeded()
            }
        }
    }

    private func loadExistingBallIfNeeded() {
        guard let ball = existingBall else { return }
        name = ball.name
        brand = ball.brand
        weight = ball.weight
        coverstock = ball.coverstock ?? ""
        notes = ball.notes ?? ""
    }

    private func save() {
        let updatedBall = BowlingBall(
            id: existingBall?.id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            brand: brand.trimmingCharacters(in: .whitespaces),
            weight: weight,
            coverstock: coverstock.trimmingCharacters(in: .whitespaces).isEmpty ? nil : coverstock,
            notes: notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes
        )

        if isEditing {
            arsenalStore.updateBall(updatedBall)
        } else {
            arsenalStore.addBall(updatedBall)
        }
        dismiss()
    }

    private func deleteBall() {
        guard let ball = existingBall else { return }
        arsenalStore.deleteBall(ball)
        dismiss()
    }
}

#Preview("Add") {
    AddBallView()
        .environment(ArsenalStore())
}

#Preview("Edit") {
    AddBallView(existingBall: BowlingBall(name: "My Phaze II", brand: "Storm", weight: 15, coverstock: "Reactive", notes: nil))
        .environment(ArsenalStore())
}
