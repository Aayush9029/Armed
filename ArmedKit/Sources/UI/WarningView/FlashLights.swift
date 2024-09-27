import SwiftUI

public struct FlashLights: View {
    private let colors: [Color] = [.red, .green]
    private let flashDuration: TimeInterval = 1.0
    private let transitionDuration: TimeInterval = 0.01
    
    @State private var currentColorIndex = 0
    @State private var colorTask: Task<Void, Never>?

    public init() {}
    
    public var body: some View {
        Rectangle()
            .fill(currentColor)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: startColorTask)
            .onDisappear(perform: cancelColorTask)
    }
    
    private var currentColor: Color {
        colors[currentColorIndex]
    }
    
    private func startColorTask() {
        colorTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(flashDuration))
                await MainActor.run {
                    withAnimation(.easeInOut(duration: transitionDuration)) {
                        currentColorIndex = (currentColorIndex + 1) % colors.count
                    }
                }
            }
        }
    }
    
    private func cancelColorTask() {
        colorTask?.cancel()
        colorTask = nil
    }
}

#Preview {
    FlashLights()
}
