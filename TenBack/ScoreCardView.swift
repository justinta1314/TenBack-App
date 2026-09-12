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
    let activeRollIndex: Int         // 0-based, which roll slot within the active frame is next
    let onEditFrame: (Int) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(0..<10, id: \.self) { index in
                        let totalSlots = index == 9 ? 3 : 2
                        let frame = index < frames.count ? frames[index] : nil
                        let hasStarted = (frame?.rollPins.isEmpty == false)
                        let isActiveFrame = index == activeFrameIndex

                        FrameBoxView(
                            frameNumber: index + 1,
                            totalSlots: totalSlots,
                            slotSymbols: frame?.slotSymbols(totalSlots: totalSlots) ?? Array(repeating: nil, count: totalSlots),
                            score: (hasStarted && index < cumulativeScores.count) ? "\(cumulativeScores[index])" : "",
                            activeSlotIndex: isActiveFrame ? activeRollIndex : nil
                        )
                        .id(index)
                        .onTapGesture {
                            onEditFrame(index)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .onAppear {
                proxy.scrollTo(activeFrameIndex, anchor: .center)
            }
            .onChange(of: activeFrameIndex) { _, newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

struct FrameBoxView: View {
    let frameNumber: Int
    let totalSlots: Int
    let slotSymbols: [String?]
    let score: String
    let activeSlotIndex: Int?        // nil if this frame isn't the active one

    var body: some View {
        VStack(spacing: 2) {
            Text("\(frameNumber)")
                .font(.caption2)
                .foregroundStyle(.secondary)

            HStack(spacing: 2) {
                ForEach(0..<totalSlots, id: \.self) { slot in
                    RollSlotView(
                        symbol: slot < slotSymbols.count ? slotSymbols[slot] : nil,
                        isActive: slot == activeSlotIndex
                    )
                }
            }

            Text(score)
                .font(.subheadline.bold())
                .frame(height: 18)
        }
        .padding(6)
        .frame(minWidth: 52)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

struct RollSlotView: View {
    let symbol: String?
    let isActive: Bool

    var body: some View {
        Text(symbol ?? "")
            .font(.caption.bold())
            .frame(width: 18, height: 18)
            .background(isActive ? Color.blue.opacity(0.25) : Color.gray.opacity(0.12))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isActive ? Color.blue : Color.clear, lineWidth: 2)
            )
            .cornerRadius(4)
    }
}

#Preview {
    ScoreCardView(
        frames: [Frame(rollPins: [Set(1...10)]), Frame(rollPins: [[2, 4, 5, 6, 8], [1, 3, 7, 9, 10]])],
        cumulativeScores: [20, 29],
        activeFrameIndex: 2,
        activeRollIndex: 0,
        onEditFrame: { _ in }
    )
}
