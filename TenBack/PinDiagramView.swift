//
//  PinDiagramView.swift
//  TenBack
//
//  Created by Justin Ta on 8/22/26.
//

import SwiftUI

struct PinDiagramView: View {
    @Binding var knockedDownPins: Set<Int>   // pins tapped THIS roll
    let standingPins: Set<Int>               // pins still available to knock down this roll

    private let rows: [[Int]] = [
        [7, 8, 9, 10],
        [4, 5, 6],
        [2, 3],
        [1]
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { pin in
                        if standingPins.contains(pin) {
                            PinButton(
                                number: pin,
                                isDown: knockedDownPins.contains(pin)
                            ) {
                                togglePin(pin)
                            }
                        } else {
                            // Already knocked down in a prior roll this frame — not tappable
                            PinButton(number: pin, isDown: true) { }
                                .disabled(true)
                        }
                    }
                }
            }
        }
    }

    private func togglePin(_ pin: Int) {
        if knockedDownPins.contains(pin) {
            knockedDownPins.remove(pin)
        } else {
            knockedDownPins.insert(pin)
        }
    }
}

struct PinButton: View {
    let number: Int
    let isDown: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.headline)
                .frame(width: 36, height: 36)
                .background(isDown ? Color.gray.opacity(0.3) : Color.brown)
                .foregroundColor(isDown ? .gray : .white)
                .clipShape(Circle())
        }
    }
}

#Preview {
    PinDiagramView(knockedDownPins: .constant([1, 3]), standingPins: [1, 2, 3, 4, 5])
}
