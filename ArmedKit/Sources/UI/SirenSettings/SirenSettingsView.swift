import MacControlCenterUI
import Shared
import SwiftUI

public struct SirenSettingsView: View {
    @State private var topFrequency: CGFloat
    @State private var bottomFrequency: CGFloat
    @State private var hovering: Bool = false
    @State private var playing: Bool = false

    let playingAction: () -> Void
    let updateFrequenciesAction: (CGFloat, CGFloat) -> Void

    public init(
        initialTopFrequency: CGFloat,
        initialBottomFrequency: CGFloat,
        playingAction: @escaping () -> Void,
        updateFrequenciesAction: @escaping (CGFloat, CGFloat) -> Void
    ) {
        self._topFrequency = State(initialValue: initialTopFrequency)
        self._bottomFrequency = State(initialValue: initialBottomFrequency)
        self.playingAction = playingAction
        self.updateFrequenciesAction = updateFrequenciesAction
    }

    public var body: some View {
        VStack {
            WaveformView(
                topFrequency: topFrequency,
                bottomFrequency: bottomFrequency,
                hovering: $hovering,
                playing: $playing,
                playingAction: playingAction
            )

            FrequencyControlsView(
                topFrequency: $topFrequency,
                bottomFrequency: $bottomFrequency,
                updateFrequenciesAction: updateFrequenciesAction
            ).padding(8)
        }
    }
}

struct WaveformView: View {
    let topFrequency: CGFloat
    let bottomFrequency: CGFloat
    @Binding var hovering: Bool
    @Binding var playing: Bool
    let playingAction: () -> Void

    var body: some View {
        ZStack {
            ZStack {
                SineWave(
                    frequency: bottomFrequency,
                    amplitude: 50
                )
                .stroke(.blue, lineWidth: 2)
                .shadow(color: .blue, radius: bottomFrequency * 10)
                SineWave(
                    frequency: topFrequency,
                    amplitude: 50
                )
                .stroke(.red, lineWidth: 2)
                .shadow(color: .red, radius: topFrequency * 10)
            }
            .blur(radius: hovering || playing ? 12 : 0)

            PlayOverlayView(playing: $playing, playingAction: playingAction)
                .opacity(hovering || playing ? 1 : 0)
        }
        .onHover { state in
            withAnimation {
                hovering = state
            }
        }
    }
}

struct PlayOverlayView: View {
    @Binding var playing: Bool
    let playingAction: () -> Void

    var body: some View {
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
                Text("Please, decrease your volume!")
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(4)
                    .background(.red, in: .capsule)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .cornerRadius(12)
        .transition(.slide)
        .onTapGesture {
            if playing { return }
            playing.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                playing = false
            }
            playingAction()
        }
    }
}

struct FrequencyControlsView: View {
    @Binding var topFrequency: CGFloat
    @Binding var bottomFrequency: CGFloat
    let updateFrequenciesAction: (CGFloat, CGFloat) -> Void

    var body: some View {
        VStack {
            FrequencySlider(
                frequencyType: "Max",
                binded: $topFrequency,
                otherFrequency: bottomFrequency
            )
            FrequencySlider(
                frequencyType: "Min",
                binded: $bottomFrequency,
                otherFrequency: topFrequency
            )
        }
        .onChange(of: topFrequency) { newValue in
            updateFrequenciesAction(newValue, bottomFrequency)
        }
        .onChange(of: bottomFrequency) { newValue in
            updateFrequenciesAction(topFrequency, newValue)
        }
    }
}

#Preview {
    SirenSettingsView(
        initialTopFrequency: 0.8,
        initialBottomFrequency: 0.2,
        playingAction: {
            print("Playing")
        },
        updateFrequenciesAction: { top, bottom in
            print("Frequencies updated - Top: \(top), Bottom: \(bottom)")
        }
    )
    .frame(width: 256, height: 320)
}
