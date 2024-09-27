import MacControlCenterUI
import SwiftUI

public struct CCBackgroundModifier: ViewModifier {
    @State private var isHovering = false
    
    private let filled: Bool
    private let padding: CGFloat
    private let hoverable: Bool

    public init(filled: Bool, padding: CGFloat, hoverable: Bool) {
        self.filled = filled
        self.padding = padding
        self.hoverable = hoverable
    }

    public func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundLayer)
            .cornerRadius(14)
            .overlay(borderLayer)
            .shadow(color: shadowColor, radius: shadowRadius, y: 4)
            .contentShape(RoundedRectangle(cornerRadius: 14))
            .onHover(perform: updateHoverState)
    }
    
    private var backgroundLayer: some View {
        ZStack {
            if filled {
                Color.white
            } else {
                VisualEffect(.hudWindow, blendingMode: .withinWindow)
            }
            
            if isHovering {
                Color.white.opacity(0.025)
            }
        }
    }
    
    private var borderLayer: some View {
        RoundedRectangle(cornerRadius: 14)
            .stroke(.primary.opacity(0.35), lineWidth: 0.25)
    }
    
    private var shadowColor: Color {
        .black.opacity(isHovering ? 0.35 : 0.25)
    }
    
    private var shadowRadius: CGFloat {
        isHovering ? 12 : 6
    }
    
    private func updateHoverState(_ isHovering: Bool) {
        guard hoverable else { return }
        withAnimation {
            self.isHovering = isHovering
        }
    }
}

public extension View {
    func ccGlassButton(
        filled: Bool = false,
        padding: CGFloat = 12,
        hoverable: Bool = false
    ) -> some View {
        modifier(CCBackgroundModifier(filled: filled, padding: padding, hoverable: hoverable))
    }
}

#Preview {
    Text("Hello")
        .ccGlassButton()
        .padding()
}
