import SwiftUI

public struct DangerOverlay: View {
    let message: String
    
    public init(_ message: String) {
        self.message = message
    }
    
    public var body: some View {
        if !message.isEmpty {
            VStack {
                warningIcon
                statusText
                messageText
            }
            .padding()
        }
    }
    
    private var warningIcon: some View {
        Image(systemName: "exclamationmark.octagon.fill")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 320)
            .foregroundStyle(Color.red.opacity(0.5))
            .frame(maxWidth: .infinity)
    }
    
    private var statusText: some View {
        Text("Armed")
            .font(.largeTitle.bold())
            .foregroundStyle(.secondary)
    }
    
    private var messageText: some View {
        Text(message)
            .font(.title.bold())
    }
}

#Preview {
    DangerOverlay("BE READY TO GO BOOM BOOM")
}
