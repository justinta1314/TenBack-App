//
//  ScoreCardView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct ScoreCardView: View {
    let frames: [Frame]
    let cumulativeScores: [Int]
    let onEditFrame: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(frames.indices, id: \.self) { index in
                    FrameBoxView(
                        frameNumber: index + 1,
                        symbols: frames[index].displaySymbols,
                        score: cumulativeScores[index]
                    )
                    .onTapGesture {
                        onEditFrame(index)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct FrameBoxView: View {
    let frameNumber: Int
    let symbols: [String]
    let score: Int

    var body: some View {
        VStack(spacing: 2) {
            Text("\(frameNumber)")
                .font(.caption2)
                .foregroundStyle(.secondary)

            HStack(spacing: 2) {
                ForEach(symbols, id: \.self) { symbol in
                    Text(symbol).font(.caption.bold())
                }
            }
            .frame(height: 16)

            Text("\(score)")
                .font(.subheadline.bold())
        }
        .padding(6)
        .frame(minWidth: 44)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(6)
    }
}
