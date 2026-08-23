//
//  GameStore.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

@Observable
class GameStore {
    var games: [Game] = []
    
    func addGame(_ game: Game) {
        games.append(game)
    }
}
