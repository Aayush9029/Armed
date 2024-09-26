import MacControlCenterUI
import Shared
import SwiftUI

public struct SirenSettingsView: View {
    @Binding var topFrequency: CGFloat
    @Binding var bottomFrequency: CGFloat
    @State private var hovering: Bool = false
    @State private var playing: Bool = false

    let playingAction: () -> Void

    public init(
        topFrequency: Binding<CGFloat>,
        bottomFrequency: Binding<CGFloat>,
        playingAction: @escaping () -> Void
    ) {
        self._topFrequency = topFrequency
        self._bottomFrequency = bottomFrequency
        self.playingAction = playingAction
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
                bottomFrequency: $bottomFrequency
            )
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

            if !playing && NSSound.systemVolume > 0.25 {
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
                otherFrequency: 999.0
            )
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var topFrequency: CGFloat = 0.8
        @State private var bottomFrequency: CGFloat = 0.2

        var body: some View {
            SirenSettingsView(
                topFrequency: $topFrequency,
                bottomFrequency: $bottomFrequency,
                playingAction: {
                    print("Playing")
                }
            )
            .frame(width: 256, height: 320)
        }
    }

    return PreviewWrapper()
}
