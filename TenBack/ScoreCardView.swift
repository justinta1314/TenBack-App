//
//  ScoreCardView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct ScoreCardView: View {
    let frames: [Frame]              // completed frames only
    let cumulativeScores: [Int]      // matches frames.count
    let activeFrameIndex: Int        // 0-based, which frame is currently being entered
    let onEditFrame: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(0..<10, id: \.self) { index in
                    FrameBoxView(
                        frameNumber: index + 1,
                        symbols: index < frames.count ? frames[index].displaySymbols : [],
                        score: index < cumulativeScores.count ? "\(cumulativeScores[index])" : "",
                        isActive: index == activeFrameIndex
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
    let score: String
    let isActive: Bool

    var body: some View {
        VStack(spacing: 2) {
            Text("\(frameNumber)")
                .font(.caption2)
                .foregroundStyle(.secondary)

            HStack(spacing: 2) {
                ForEach(symbols, id: \.self) { symbol in
                    Text(symbol).font(.caption.bold())
                }
                if symbols.isEmpty {
                    Text(" ").font(.caption)  // keeps height consistent when empty
                }
            }
            .frame(height: 16)

            Text(score)
                .font(.subheadline.bold())
                .frame(height: 18)
        }
        .padding(6)
        .frame(minWidth: 44)
        .background(isActive ? Color.blue.opacity(0.2) : Color.gray.opacity(0.15))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isActive ? Color.blue : Color.clear, lineWidth: 2)
        )
        .cornerRadius(6)
    }
}

#Preview {
    ScoreCardView(
        frames: [Frame(rolls: [10]), Frame(rolls: [7, 2])],
        cumulativeScores: [20, 29],
        activeFrameIndex: 2,
        onEditFrame: { _ in }
    )
}
