//
//  TimerView.swift
//  Armed
//
//  Created by yush on 9/26/24.
//


//
//  TimerView.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var armedVM: ArmedVM

    @State private var timeRemaining: TimeInterval
    @State private var timerTask: Task<Void, Never>?
    @State private var hovering: Bool = false

    init(inputTime: TimeInterval) {
        _timeRemaining = State(initialValue: inputTime * 30)
    }

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text(timeString(timeRemaining))
                        .font(.system(size: 128))
                        .bold()
                    Text("Seconds Remaining")
                        .font(.title3)
                        .foregroundStyle(.tertiary)
                }
                HStack {
                    Text("Please **plug charger** back in **immediately**")
                    Image(systemName: "powerplug.fill")
                }
                .padding(8)
                .background(Color.red.opacity(0.5))
                .cornerRadius(12)
            }
            if hovering {
                VStack {
                    Spacer()
                    Image(systemName: "touchid")
                        .imageScale(.large)
                        .foregroundStyle(.red)
                    HStack { Spacer() }
                    Text("Un-arm MacBook")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .font(.largeTitle)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .onTapGesture {
                    Task {
                        _ = await armedVM.authenticate()
                    }
                }
            }
        }
        .onAppear {
            startTimer()
        }
        .onHover { state in
            withAnimation {
                hovering = state
            }
        }
        .onDisappear {
            timerTask?.cancel()
        }
    }

    func startTimer() {
        timerTask?.cancel()
        timerTask = Task {
            while timeRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                timeRemaining -= 1
            }
            // Timer finished
        }
    }

    func timeString(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        return String(format: "%02i", seconds)
    }
}
