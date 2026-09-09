//
//  AddGameView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct AddGameView: View {
    @Environment(GameStore.self) private var store

    @State private var frames: [Frame] = []
    @State private var currentRollPins: [Set<Int>] = []
    @State private var knockedDownPins: Set<Int> = []
    @State private var editingFrameIndex: Int? = nil

    private var currentFrame: Frame {
        Frame(rollPins: currentRollPins)
    }

    private var activeFrameIndex: Int {
        editingFrameIndex ?? frames.count
    }
    private var activeFrameNumber: Int { activeFrameIndex + 1 }
    private var isTenthFrame: Bool { activeFrameNumber == 10 }
    private var gameIsComplete: Bool { frames.count == 10 }

    var body: some View {
        VStack(spacing: 20) {
            ScoreCardView(
                frames: frames,
                cumulativeScores: Game(frames: frames).cumulativeScores,
                activeFrameIndex: activeFrameIndex,
                activeRollIndex: currentRollPins.count,
                onEditFrame: startEditingFrame
            )

            if let editIndex = editingFrameIndex {
                Text("Editing Frame \(editIndex + 1)")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

            if !gameIsComplete || editingFrameIndex != nil {
                PinDiagramView(
                    knockedDownPins: $knockedDownPins,
                    standingPins: currentFrame.pinsStandingForNextRoll
                )

                Text("Pins this roll: \(knockedDownPins.count)")
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    Button("-") { recordRoll(pinsDown: []) }
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Gutter")

                    Button("X") { recordRoll(pinsDown: currentFrame.pinsStandingForNextRoll) }
                        .buttonStyle(.borderedProminent)
                        .disabled(!canStrike)
                        .accessibilityLabel("Strike")

                    Button("/") { recordRoll(pinsDown: currentFrame.pinsStandingForNextRoll) }
                        .buttonStyle(.bordered)
                        .disabled(!canSpare)
                        .accessibilityLabel("Spare")

                    Button {
                        undoLastRoll()
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                    .buttonStyle(.bordered)
                    .disabled(!canUndo)
                    .accessibilityLabel("Undo last roll")
                }

                Button("Confirm Roll") {
                    recordRoll(pinsDown: knockedDownPins)
                }
                .buttonStyle(.borderedProminent)
                .disabled(knockedDownPins.isEmpty)
            } else {
                Text("Game complete!")
                    .font(.title2.bold())
                    .foregroundStyle(.green)

                Button("Submit Game") {
                    saveGame()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Add Game")
    }

    // MARK: - Editing

    private func startEditingFrame(_ index: Int) {
        guard index < frames.count else { return }
        editingFrameIndex = index
        currentRollPins = []
        knockedDownPins = []
    }

    // MARK: - Undo

    private func undoLastRoll() {
        if !currentRollPins.isEmpty {
            currentRollPins.removeLast()
            knockedDownPins.removeAll()
        } else if editingFrameIndex == nil && !frames.isEmpty {
            let lastFrame = frames.removeLast()
            currentRollPins = lastFrame.rollPins
            currentRollPins.removeLast()
            knockedDownPins.removeAll()
        }
    }

    private var canUndo: Bool {
        !currentRollPins.isEmpty || (editingFrameIndex == nil && !frames.isEmpty)
    }

    // MARK: - Button enable logic

    private var canStrike: Bool {
        if isTenthFrame {
            return currentFrame.pinsStandingForNextRoll.count == 10
        } else {
            return currentRollPins.isEmpty
        }
    }

    private var canSpare: Bool {
        guard let last = currentRollPins.last else { return false }
        if isTenthFrame {
            return last.count != 10 && !currentFrame.pinsStandingForNextRoll.isEmpty
        } else {
            return currentRollPins.count == 1 && last.count != 10
        }
    }

    // MARK: - Roll recording

    private func recordRoll(pinsDown: Set<Int>) {
        currentRollPins.append(pinsDown)
        knockedDownPins.removeAll()

        if isTenthFrame {
            if isTenthFrameComplete() {
                finishFrame()
            }
        } else {
            if pinsDown.count == 10 || currentRollPins.count == 2 {
                finishFrame()
            }
        }
    }

    private func isTenthFrameComplete() -> Bool {
        let rolls = currentRollPins.map { $0.count }
        if rolls.count == 2 && rolls[0] + rolls[1] < 10 { return true }
        if rolls.count == 3 { return true }
        return false
    }

    private func finishFrame() {
        let newFrame = Frame(rollPins: currentRollPins)
        currentRollPins = []

        if let editIndex = editingFrameIndex {
            frames[editIndex] = newFrame
            editingFrameIndex = nil
        } else {
            frames.append(newFrame)
            // No auto-save — waits for the user to tap "Submit Game"
        }
    }

    private func saveGame() {
        let game = Game(date: Date(), frames: frames)
        store.addGame(game)
        resetForm()
    }

    private func resetForm() {
        frames = []
        currentRollPins = []
        knockedDownPins = []
        editingFrameIndex = nil
    }
}

#Preview {
    NavigationStack {
        AddGameView()
    }
    .environment(GameStore())
}
