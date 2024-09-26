//
//  SirenSliderInternal.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

import MacControlCenterUI
import SwiftUI

public struct SirenSlider: View {
    @Binding var sirenTimer: CGFloat
    @State private var hovering: Bool = false
    private let sliderWidth: CGFloat = 270

    let action: () -> Void

    public init(
        sirenTimer: Binding<CGFloat>,
        action: @escaping () -> Void
    ) {
        self._sirenTimer = sirenTimer
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
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
        .buttonStyle(.plain)
    }
}

#Preview {
    SirenSlider(
        sirenTimer: .constant(0.4)
    ) {}
}
