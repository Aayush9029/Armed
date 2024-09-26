//
//  FlashLights.swift
//  Armed
//
//  Created by yush on 9/26/24.
//


//
//  FlashLights.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import SwiftUI

struct FlashLights: View {
    let colors: [Color] = [.red, .green]
    @State private var currentColorIndex = 0
    @State private var colorTask: Task<Void, Never>?

    var body: some View {
        Rectangle()
            .fill(colors[currentColorIndex])
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                startColorTask()
            }
            .onDisappear {
                colorTask?.cancel()
            }
    }

    func startColorTask() {
        colorTask = Task {
            while true {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                withAnimation(.easeInOut(duration: 0.01)) {
                    currentColorIndex = (currentColorIndex + 1) % colors.count
                }
            }
        }
    }
}
