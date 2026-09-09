//
//  BowlingBall.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import Foundation

struct BowlingBall: Identifiable, Codable {
    var id = UUID()
    var name: String         // user's own label, e.g. "My Storm Phaze II"
    var brand: String
    var weight: Int           // lbs
    var coverstock: String?   // optional
    var notes: String?
}
