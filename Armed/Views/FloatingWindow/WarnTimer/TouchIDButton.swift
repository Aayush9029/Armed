import SwiftUI

struct TouchIDButton: View {
    @EnvironmentObject var armedVM: ArmedVM
    @State private var isHovered = false

    var body: some View {
        Button {
            Task {
                _ = await armedVM.authenticate()
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
    TouchIDButton()
        .environmentObject(ArmedVM())
        .padding()
}
