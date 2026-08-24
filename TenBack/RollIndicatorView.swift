//
//  RollIndicatorView.swift
//  TenBack
//
//  Created by Justin Ta on 8/24/26.
//

import SwiftUI

struct RollIndicatorView: View {
    let totalRolls: Int      // 2 for normal frames, up to 3 for the 10th frame
    let currentRollIndex: Int // 0-based index of the roll being entered

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalRolls, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(index == currentRollIndex ? Color.blue : Color.gray.opacity(0.25))
                    .frame(width: 28, height: 8)
            }
        }
    }
}

#Preview {
    RollIndicatorView(totalRolls: 3, currentRollIndex: 1)
}
