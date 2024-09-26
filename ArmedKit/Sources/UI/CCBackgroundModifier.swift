import MacControlCenterUI
import SwiftUI

public struct CCBackgroundModifier: ViewModifier {
    @State private var hovering: Bool = false
    let filled: Bool
    let padding: CGFloat
    let hoverable: Bool

    public init(
        filled: Bool,
        padding: CGFloat,
        hoverable: Bool
    ) {
        self.filled = filled
        self.padding = padding
        self.hoverable = hoverable
    }

    public func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    if !filled {
                        ZStack {
                            VisualEffect(.hudWindow, blendingMode: .withinWindow)
                        }
                    } else {
                        Color.white
                    }
                    if hovering {
                        Group {
                            Color.white.opacity(0.025)
                        }
                    }
                }
            )
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        .primary.opacity(0.35),
                        lineWidth: 0.25
                    )
            )
            .shadow(
                color: .black.opacity(hovering ? 0.35 : 0.25),
                radius: hovering ? 12 : 6, y: 4
            )

            .contentShape(RoundedRectangle(cornerRadius: 14))
            .onHover { state in
                if !hoverable { return }
                withAnimation {
                    hovering = state
                }
            }
    }
}

public extension View {
    func ccGlassButton(
        filled: Bool = false,
        padding: CGFloat = 12,
        hoverable: Bool = false
    ) -> ModifiedContent<Self, CCBackgroundModifier> {
        return modifier(CCBackgroundModifier(filled: filled, padding: padding, hoverable: hoverable))
    }
}

#Preview {
    Text("Hello")
        .ccGlassButton()
        .padding()
}
