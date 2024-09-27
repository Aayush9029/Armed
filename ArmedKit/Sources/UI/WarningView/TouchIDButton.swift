import SwiftUI

public struct TouchIDButton: View {
    let action: () async -> Void
    @State private var isHovered = false

    public init(action: @escaping () async -> Void) {
        self.action = action
    }

    public var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            VStack {
                Label("Un-Arm with biometrics", systemImage: "touchid")
                    .labelStyle(.iconOnly)
                    .font(.largeTitle)
                    .foregroundStyle(isHovered ? .red : .secondary)
                    .padding(6)
                Text("Unarm your Mac")
                    .foregroundColor(isHovered ? .black : .primary)
            }
            .padding(8)
            .background(.white.opacity(isHovered ? 1.0 : 0.10))
            .animation(.easeInOut, value: isHovered)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    TouchIDButton {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        print("Authentication completed")
    }
    .padding()
}
