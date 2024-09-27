import SwiftUI

public struct BlinkingSymbol: View {
    @State private var blink: Bool = false

    let onSymbol: String
    let offSymbol: String

    let state: Bool

    public init(
        onSymbol: String,
        offSymbol: String,
        state: Bool
    ) {
        self.onSymbol = onSymbol
        self.offSymbol = offSymbol
        self.state = state
    }

    public var body: some View {
        Image(systemName: state ? onSymbol : offSymbol)
            .symbolVariant(.fill)
            .foregroundColor(state ? .green : .red)
            .opacity((blink && state) ? 1 : 0.5)
            .shadow(color: state ? .green.opacity(0.5) : .red.opacity(0.5), radius: blink ? 8 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    blink.toggle()
                }
            }.transaction { transaction in
                transaction.animation = nil
            }
    }
}

#Preview {
    HStack {
        BlinkingSymbol(
            onSymbol: "bolt",
            offSymbol: "bolt.slash",
            state: true
        )
        .padding()

        BlinkingSymbol(
            onSymbol: "bolt",
            offSymbol: "bolt.slash",
            state: false
        )
        .padding()
    }
}
