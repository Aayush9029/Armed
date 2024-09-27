//
//  FrequencySlider.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

import MacControlCenterUI
import Shared
import SwiftUI

struct FrequencySlider: View {
    let frequencyType: String
    @Binding var binded: CGFloat
    let otherFrequency: CGFloat

    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("\(frequencyType) Frequency")
                    Text(
                        FrequencyFormatter.format(
                            frequency: Double(
                                FrequencyFormatter.valueToFrequency(binded)
                            )
                        )
                    )
                    .foregroundStyle(.secondary)
                    Spacer()
                    if abs(binded - otherFrequency) < 0.25 {
                        FrequencyTooCloseWarning()
                    }
                }
                .font(.callout)

                MenuSlider(
                    value: $binded,
                    image: Image(
                        systemName: "waveform.path"
                    )
                    .symbolRenderingMode(.hierarchical)
                )
            }
            .ccGlassButton(padding: 10)
        }
    }
}

#Preview {
    FrequencySlider(
        frequencyType: "Min",
        binded: .constant(0.4),
        otherFrequency: 0.4
    )
    .frame(width: 280)
    .padding()
}
