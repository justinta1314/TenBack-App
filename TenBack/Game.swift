//
//  Game.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import Foundation

struct Frame: Identifiable, Codable {
    var id = UUID()
    var rollPins: [Set<Int>] = []   // e.g. [[1,2,3,4,5,6,7,8,9,10]] for a strike, [[2,3,4,5,6,7,8,9,10],[1]] for a spare

    /// Pin counts per roll, derived from rollPins (used by scoring)
    var rolls: [Int] {
        rollPins.map { $0.count }
    }

    var isStrike: Bool {
        rolls.first == 10
    }

    var isSpare: Bool {
        rolls.count >= 2 && rolls[0] + rolls[1] == 10 && !isStrike
    }

    var displaySymbols: [String] {
        guard !rolls.isEmpty else { return [] }

        if isStrike {
            return ["X"]
        }

        var symbols: [String] = []
        for (index, roll) in rolls.enumerated() {
            if isSpare && index == 1 {
                symbols.append("/")
            } else if roll == 0 {
                symbols.append("-")
            } else {
                symbols.append(String(roll))
            }
        }
        return symbols
    }
}

extension Frame {
    /// Which pins are still standing and available to knock down on the next roll in this frame.
    /// Handles strike/spare resets for 10th-frame bonus rolls.
    var pinsStandingForNextRoll: Set<Int> {
        guard let lastRoll = rollPins.last else {
            return Set(1...10) // fresh frame, nothing thrown yet
        }

        if lastRoll.count == 10 {
            return Set(1...10) // just struck — rack resets (only matters in 10th frame)
        }

        if rollPins.count >= 2 {
            let priorCount = rollPins[rollPins.count - 2].count
            if priorCount + lastRoll.count == 10 {
                return Set(1...10) // just completed a spare — rack resets (10th frame bonus roll)
            }
        }

        return Set(1...10).subtracting(rollPins.flatMap { $0 })
    }
}

struct Game: Identifiable, Codable {
    var id = UUID()
    var date: Date = Date()
    var frames: [Frame] = []
}

// MARK: - Scoring

extension Game {
    var totalScore: Int {
        cumulativeScores.last ?? 0
    }

    /// Running score after each frame, e.g. [10, 19, 29, ...]
    var cumulativeScores: [Int] {
        var scores: [Int] = []
        var score = 0
        var rollIndex = 0
        let allRolls = frames.flatMap(\.rolls)

        for _ in 0..<frames.count {
            if isStrikeAt(rollIndex, in: allRolls) {
                score += 10 + rollAt(rollIndex + 1, allRolls) + rollAt(rollIndex + 2, allRolls)
                rollIndex += 1
            } else if isSpareAt(rollIndex, in: allRolls) {
                score += 10 + rollAt(rollIndex + 2, allRolls)
                rollIndex += 2
            } else {
                score += rollAt(rollIndex, allRolls) + rollAt(rollIndex + 1, allRolls)
                rollIndex += 2
            }
            scores.append(score)
        }
        return scores
    }

    private func rollAt(_ index: Int, _ rolls: [Int]) -> Int {
        index < rolls.count ? rolls[index] : 0
    }

    private func isStrikeAt(_ index: Int, in rolls: [Int]) -> Bool {
        rollAt(index, rolls) == 10
    }

    private func isSpareAt(_ index: Int, in rolls: [Int]) -> Bool {
        rollAt(index, rolls) + rollAt(index + 1, rolls) == 10 && !isStrikeAt(index, in: rolls)
    }
}
