//
//  AddGameView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct AddGameView: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var frames: [Frame] = []
    @State private var currentFrameRolls: [Int] = []
    @State private var knockedDownPins: Set<Int> = []
    @State private var editingFrameIndex: Int? = nil

    private var activeFrameNumber: Int {
        editingFrameIndex.map { $0 + 1 } ?? (frames.count + 1)
    }
    private var isTenthFrame: Bool { activeFrameNumber == 10 }

    /// Completed frames plus an in-progress preview frame, for live scorecard display
    private var displayFrames: [Frame] {
        if currentFrameRolls.isEmpty {
            return frames
        }
        return frames + [Frame(rolls: currentFrameRolls)]
    }

    var body: some View {
        VStack(spacing: 20) {
            ScoreCardView(
                frames: displayFrames,
                cumulativeScores: Game(frames: displayFrames).cumulativeScores,
                onEditFrame: startEditingFrame
            )

            if let editIndex = editingFrameIndex {
                Text("Editing Frame \(editIndex + 1)")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

            Text("Frame \(activeFrameNumber)")
                .font(.title2.bold())

            PinDiagramView(knockedDownPins: $knockedDownPins)

            Text("Pins this roll: \(knockedDownPins.count)")
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Button("-") { recordRoll(pins: 0) }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Gutter")

                Button("X") { recordRoll(pins: 10) }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canStrike)
                    .accessibilityLabel("Strike")

                Button("/") { recordSpare() }
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
                recordRoll(pins: knockedDownPins.count)
            }
            .buttonStyle(.borderedProminent)
            .disabled(knockedDownPins.isEmpty)

            Spacer()

            Text("Frames so far: \(frames.count)/10")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Add Game")
    }

    // MARK: - Editing

    private func startEditingFrame(_ index: Int) {
        guard index < frames.count else { return }
        editingFrameIndex = index
        currentFrameRolls = []
        knockedDownPins = []
    }

    // MARK: - Undo

    private func undoLastRoll() {
        if !currentFrameRolls.isEmpty {
            // Remove the most recent roll in the frame currently being entered
            currentFrameRolls.removeLast()
            knockedDownPins.removeAll()
        } else if editingFrameIndex == nil && !frames.isEmpty {
            // Nothing typed yet in the current frame — step back into the previous completed frame
            let lastFrame = frames.removeLast()
            currentFrameRolls = lastFrame.rolls
            currentFrameRolls.removeLast()
            knockedDownPins.removeAll()
        }
    }

    private var canUndo: Bool {
        !currentFrameRolls.isEmpty || (editingFrameIndex == nil && !frames.isEmpty)
    }

    // MARK: - Button enable logic

    private var canStrike: Bool {
        if isTenthFrame {
            return pinsStandingForCurrentRoll() == 10
        } else {
            return currentFrameRolls.isEmpty
        }
    }

    private var canSpare: Bool {
        guard let last = currentFrameRolls.last else { return false }
        if isTenthFrame {
            return last != 10 && pinsStandingForCurrentRoll() > 0
        } else {
            return currentFrameRolls.count == 1 && last != 10
        }
    }

    private func pinsStandingForCurrentRoll() -> Int {
        if currentFrameRolls.isEmpty { return 10 }

        if isTenthFrame {
            let last = currentFrameRolls.last ?? 0
            let secondToLast = currentFrameRolls.count >= 2 ? currentFrameRolls[currentFrameRolls.count - 2] : nil

            if last == 10 { return 10 }
            if let prev = secondToLast, prev + last == 10 { return 10 }
            return 10 - last
        } else {
            return 10 - (currentFrameRolls.first ?? 0)
        }
    }

    // MARK: - Roll recording

    private func recordRoll(pins: Int) {
        currentFrameRolls.append(pins)
        knockedDownPins.removeAll()

        if isTenthFrame {
            if isTenthFrameComplete() {
                finishFrame()
            }
        } else {
            if pins == 10 || currentFrameRolls.count == 2 {
                finishFrame()
            }
        }
    }

    private func recordSpare() {
        recordRoll(pins: pinsStandingForCurrentRoll())
    }

    private func isTenthFrameComplete() -> Bool {
        let rolls = currentFrameRolls
        if rolls.count == 2 && rolls[0] + rolls[1] < 10 { return true }
        if rolls.count == 3 { return true }
        return false
    }

    private func finishFrame() {
        let newFrame = Frame(rolls: currentFrameRolls)
        currentFrameRolls = []

        if let editIndex = editingFrameIndex {
            frames[editIndex] = newFrame
            editingFrameIndex = nil
        } else {
            frames.append(newFrame)
            if frames.count == 10 {
                saveGame()
            }
        }
    }

    private func saveGame() {
        let game = Game(date: Date(), frames: frames)
        store.addGame(game)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddGameView()
    }
    .environment(GameStore())
}
