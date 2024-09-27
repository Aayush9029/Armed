import SwiftUI

public struct TimerView: View {
    @StateObject private var viewModel: TimerViewModel
    @State private var hovering: Bool = false

    public init(inputTime: TimeInterval, authenticationAction: @escaping () async -> Void) {
        _viewModel = StateObject(wrappedValue: TimerViewModel(inputTime: inputTime, authenticationAction: authenticationAction))
    }

    public var body: some View {
        ZStack {
            timerContent
            if hovering {
                authenticationOverlay
            }
        }
        .onAppear(perform: viewModel.startTimer)
        .onHover { state in
            withAnimation {
                hovering = state
            }
        }
        .onDisappear(perform: viewModel.stopTimer)
    }

    private var timerContent: some View {
        VStack {
            timerDisplay
            warningMessage
        }
    }

    private var timerDisplay: some View {
        VStack {
            Text(viewModel.timeString)
                .font(.system(size: 128))
                .bold()
            Text("Seconds Remaining")
                .font(.title3)
                .foregroundStyle(.tertiary)
        }
    }

    private var warningMessage: some View {
        HStack {
            Text("Please **plug charger** back in **immediately**")
            Image(systemName: "powerplug.fill")
        }
        .padding(8)
        .background(Color.red.opacity(0.5))
        .cornerRadius(12)
    }

    private var authenticationOverlay: some View {
        VStack {
            Spacer()
            Image(systemName: "touchid")
                .imageScale(.large)
                .foregroundStyle(.red)
            HStack { Spacer() }
            Text("Disarm mac")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .font(.largeTitle)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .onTapGesture(perform: viewModel.authenticate)
    }
}

class TimerViewModel: ObservableObject {
    @Published private(set) var timeRemaining: TimeInterval
    private let authenticationAction: () async -> Void
    private var timerTask: Task<Void, Never>?

    init(inputTime: TimeInterval, authenticationAction: @escaping () async -> Void) {
        self.timeRemaining = inputTime * 30
        self.authenticationAction = authenticationAction
    }

    var timeString: String {
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02i", seconds)
    }

    func startTimer() {
        stopTimer()
        timerTask = Task {
            while timeRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run {
                    timeRemaining -= 1
                }
            }
        }
    }

    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    func authenticate() {
        Task {
            await authenticationAction()
        }
    }
}

#Preview {
    TimerView(inputTime: 2) {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        print("Authentication completed")
    }
}
