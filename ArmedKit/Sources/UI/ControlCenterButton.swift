import SwiftUI

public struct ControlCenterButton: View {
    private let value: Bool
    private let title: String
    private let icon: String
    private let tint: Color
    private let size: Font
    private let action: () -> Void

    public init(
        _ value: Bool,
        title: String,
        icon: String,
        tint: Color = .blue,
        size: Font = .caption,
        action: @escaping () -> Void
    ) {
        self.value = value
        self.title = title
        self.icon = icon
        self.tint = tint
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            buttonContent
        }
        .buttonStyle(.plain)
        .buttonBorderShape(.roundedRectangle)
    }

    private var buttonContent: some View {
        VStack {
            iconView
            titleView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(value ? tint : .primary)
        .ccGlassButton(filled: value, hoverable: true)
    }

    private var iconView: some View {
        Image(systemName: icon)
            .imageScale(.large)
            .shadow(color: tint.opacity(0.25), radius: value ? 2 : 0)
            .symbolRenderingMode(.hierarchical)
    }

    private var titleView: some View {
        Text(title)
            .multilineTextAlignment(.center)
            .font(size)
            .frame(minHeight: 28)
    }
}

#Preview {
    HStack {
        ControlCenterButton(
            true,
            title: "Capture\nImages",
            icon: "camera"
        ) {}
        ControlCenterButton(
            false,
            title: "Capture\nImage",
            icon: "camera",
            size: .caption2
        ) {}
    }
    .frame(width: 144, height: 84)
    .padding()
}
