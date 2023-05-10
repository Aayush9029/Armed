//
//  SirenSettingsView.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-21.
//

import Defaults
import MacControlCenterUI
import SwiftUI

struct SirenSettingsView: View {
    @EnvironmentObject var armedVM: ArmedVM
    @State private var hovering: Bool = false
    @State private var playing: Bool = false

    @Default(.topFrequency) var topFrequency
    @Default(.bottomFrequency) var bottomFrequency
    var body: some View {
        VStack {
            ZStack {
                SineWave(frequency: bottomFrequency, amplitude: 50)
                    .stroke(Color.blue, lineWidth: 2)
                    .shadow(color: .blue, radius: bottomFrequency * 10)
                SineWave(frequency: topFrequency, amplitude: 50)
                    .stroke(.red, lineWidth: 2)
                    .shadow(color: .red, radius: topFrequency * 10)

                if hovering || playing {
                    VStack {
                        Image(systemName: playing ? "waveform.path" : "bell.and.waveform.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                        Text(playing ? "Playing" : "Play Demo")
                            .font(.title3.bold())
                        Text("2 seconds")
                            .foregroundStyle(.secondary)
                        if !playing {
                            if NSSound.systemVolume > 0.15 {
                                Text("Please, decrease your volume!")
                                    .bold()
                                    .foregroundStyle(.red)
                                    .font(.title3)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background(VisualEffect.popoverWindow())
                    .cornerRadius(12)
                    .transition(.slide)
                    .onTapGesture {
                        if playing { return }
                        playing.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            playing = false
                        }
                        armedVM.highPitchedPlayer.playDemo()
                    }
                }
            }
            .onHover { state in
                withAnimation {
                    hovering = state
                }
            }
            VStack {
                FrequencySlider(frequencyType: "Max", binded: $topFrequency)
                FrequencySlider(frequencyType: "Min", binded: $bottomFrequency, showWarning: false)
            }.padding()
                .padding(.bottom)
                .onChange(of: topFrequency) { _ in
                    armedVM.highPitchedPlayer.updateFrequencies()
                }
                .onChange(of: bottomFrequency) { _ in
                    armedVM.highPitchedPlayer.updateFrequencies()
                }
        }

        .environmentObject(armedVM)
        .navigationTitle(
            Text("Frequency Selector")
        )
    }
}

struct SirenSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SirenSettingsView()
                .navigationTitle(
                    Text("Frequency Selector")
                )
                .environmentObject(ArmedVM())
                .frame(width: 320, height: 360)
        }
    }
}

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

struct FrequencyTooCloseWarning: View {
    @EnvironmentObject var armedVM: ArmedVM

    @Default(.topFrequency) var topFrequency
    @Default(.bottomFrequency) var bottomFrequency

    var body: some View {
        Group {
            if abs(topFrequency - bottomFrequency) < 0.25 {
                Label("Too Close", systemImage: "exclamationmark.triangle.fill")
                    .onHover(perform: { _ in
                        armedVM.showFrequencyPopover.toggle()
                    })
                    .labelStyle(.iconOnly)
                    .foregroundColor(.yellow)
                    .popover(isPresented: $armedVM.showFrequencyPopover) {
                        Text("+- 500Hz between MIN and MAX frequencies is recommended for better differentiation")
                            .bold()
                            .font(.callout)
                            .foregroundStyle(.primary)
                            .padding()
                    }
            }
        }
    }
}

struct SineWave: Shape {
    var frequency: Double
    var amplitude: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerY = rect.height / 2

        for x in stride(from: 0, to: rect.width, by: 1) {
            let normalizedX = Double(x) / rect.width
            let angle = 2 * .pi * ((frequency * 2) + 2) * normalizedX
            let y = centerY + amplitude * CGFloat(sin(angle))

            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

enum FrequencyFormatter {
    static func format(frequency: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2

        if frequency < 1_000 {
            return "\(numberFormatter.string(from: NSNumber(value: frequency))!) Hz"
        } else if frequency >= 1_000 && frequency < 1_000_000 {
            let kilohertzValue = frequency / 1_000
            return "\(numberFormatter.string(from: NSNumber(value: kilohertzValue))!) kHz"
        } else if frequency >= 1_000_000 && frequency < 1_000_000_000 {
            let megahertzValue = frequency / 1_000_000
            return "\(numberFormatter.string(from: NSNumber(value: megahertzValue))!) MHz"
        } else {
            let gigahertzValue = frequency / 1_000_000_000
            return "\(numberFormatter.string(from: NSNumber(value: gigahertzValue))!) GHz"
        }
    }
}
