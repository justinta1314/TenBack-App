//
//  ArsenalStore.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

@Observable
class ArsenalStore {
    var balls: [BowlingBall] = []

    func addBall(_ ball: BowlingBall) {
        balls.append(ball)
    }

    func deleteBall(_ ball: BowlingBall) {
        balls.removeAll { $0.id == ball.id }
    }

    func updateBall(_ ball: BowlingBall) {
        guard let index = balls.firstIndex(where: { $0.id == ball.id }) else { return }
        balls[index] = ball
    }
}
