import SwiftUI

struct DangerOverlay: View {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var body: some View {
        Group {
            if !message.isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "exclamationmark.octagon.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 320)
                            .foregroundStyle(Color.red.opacity(0.5))
                        Spacer()
                    }
                    Text("Armed")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.secondary)
                    Text(message)
                        .font(.title.bold())
                }
            }
        }
        .padding()
    }
}
