import SwiftUI

public struct CustomCleanButton: View {
    private let config: ButtonConfig
    private let action: () -> Void

    public init(
        _ title: String,
        symbol: String,
        tint: Color = .orange,
        action: @escaping () -> Void
    ) {
        self.config = ButtonConfig(
            title: title,
            symbol: symbol,
            tint: tint
        )
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            CustomCleanButtonLabel(config: config)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Reusable Clean Button Label

public struct CustomCleanButtonLabel: View {
    @State private var hovered: Bool = false
    private let config: ButtonConfig

    public init(config: ButtonConfig) {
        self.config = config
    }

    public var body: some View {
        HStack {
            symbolView
            Spacer()
            titleView
            Spacer()
        }
        .padding(4)
        
        .background(config.tint.opacity(hovered ? 0.75 : 0.125 ))
        .clipShape(.capsule)
        .overlay(content: {
            Capsule()
                .stroke(config.tint.opacity(0.25), lineWidth: 2)
        })
        .onHover { self.hovered = $0 }
    }

    private var symbolView: some View {
        Image(systemName: config.symbol)
            .foregroundColor(.white)
            .scaledToFit()
            .frame(width: 16, height: 16)
            .padding(4)
            .background(config.tint)
            .clipShape(Circle())
            .symbolVariant(.fill)
    }

    private var titleView: some View {
        Text(config.title)
            .foregroundStyle(hovered ? .white : config.tint)
    }
}

// MARK: - Button Configuration

public struct ButtonConfig {
    let title: String
    let symbol: String
    let tint: Color
}

#Preview {
    CustomCleanButton(
        "Website",
        symbol: "safari"
    ) {
        print("Hi")
    }
    .frame(width: 128)
    .padding()
}
