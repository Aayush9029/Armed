import MacControlCenterUI
import SwiftUI

public struct SirenSlider: View {
    @Binding var sirenTimer: CGFloat
    @State private var hovering: Bool = false
    private let sliderWidth: CGFloat = 270

    public init(
        sirenTimer: Binding<CGFloat>
    ) {
        self._sirenTimer = sirenTimer
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Siren Countdown")
                Text("\(Int(sirenTimer * 30))s")
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.tertiary)
                    .opacity(hovering ? 1 : 0)
            }
            .font(.callout)

            MenuSlider(
                value: $sirenTimer,
                image: Image(systemName: "timer").symbolRenderingMode(.hierarchical)
            )
            .frame(minWidth: sliderWidth)
        }
        .ccGlassButton(padding: 10)
        .onHover { value in
            hovering = value
        }
    }
}

#Preview {
    SirenSlider(
        sirenTimer: .constant(0.4)
    )
}
