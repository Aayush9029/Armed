//
//  SirenSlider.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-21.
//

import MacControlCenterUI
import SwiftUI

struct SirenSlider: View {
    @EnvironmentObject var armedVM: ArmedVM
    @State private var hovering: Bool = false
    private let sliderWidth: CGFloat = 270
    var body: some View {
        NavigationLink {
            SirenSettingsView()
                .environmentObject(armedVM)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Siren Countdown")
                    Text("\(Int(armedVM.soundTimer * 30))s")
                        .foregroundStyle(.secondary)
                    Spacer()

                    Image(systemName: "chevron.forward")
                        .foregroundStyle(.tertiary)
                        .opacity(hovering ? 1 : 0)
                }
                .font(.callout)
                .bold()
                MenuSlider(value: $armedVM.soundTimer,
                           image: Image(systemName: "timer")
                               .symbolRenderingMode(.hierarchical))
                    .frame(minWidth: sliderWidth)
            }
            .ccGlassButton(padding: 10)
            .onHover(perform: { value in
                hovering = value
            })
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Frequency Silder

struct FrequencySlider: View {
    let frequencyType: String
    @Binding var binded: CGFloat

    @EnvironmentObject var armedVM: ArmedVM
    var showWarning: Bool = true

    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("\(frequencyType) Frequency")
                    Text(FrequencyFormatter.format(frequency: Double(HighPitchedAudioPlayer.valueToFrequency(binded))))
                        .foregroundStyle(.secondary)
                    Spacer()
                    if showWarning {
                        FrequencyTooCloseWarning()
                            .environmentObject(armedVM)
                    }
                }
                .font(.callout)
                .bold()
                MenuSlider(value: $binded,
                           image: Image(systemName: "waveform.path")
                               .symbolRenderingMode(.hierarchical))
            }
            .ccGlassButton(padding: 10)
        }
    }
}

struct SirenSlider_Previews: PreviewProvider {
    static var previews: some View {
        SirenSlider()
            .environmentObject(ArmedVM())
    }
}
