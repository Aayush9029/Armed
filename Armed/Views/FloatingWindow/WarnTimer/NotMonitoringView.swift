import SwiftUI

struct NotMonitoringView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "lock.open.laptopcomputer")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .foregroundColor(.secondary)
            Text("Unarmed")
                .font(.largeTitle)
            Spacer()
            Button {
                NSApp.keyWindow?.close()
            } label: {
                HStack {
                    Spacer()
                    Text("Hide Window")
                    Spacer()
                }
                .padding()
                .background(.thickMaterial)
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Rectangle().fill(Color.secondary).ignoresSafeArea())
    }
}
