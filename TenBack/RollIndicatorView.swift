//
//  RollIndicatorView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct RollIndicatorView: View {
    let totalRolls: Int
    let currentRollIndex: Int

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
