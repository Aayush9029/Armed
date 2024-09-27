//
//  SineWave.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

import SwiftUI

struct SineWave: Shape {
    var frequency: Double
    var amplitude: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerY = rect.height / 2

        for x in stride(from: 0, to: rect.width, by: 1) {
            let normalizedX = Double(x) / rect.width
            let angle = 2 * .pi * ((frequency * 2) + 2) * normalizedX
            let y = centerY + amplitude * CGFloat(sin(angle))

            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }
}

#Preview {
    SineWave(frequency: 4, amplitude: 10)
        .stroke(.teal, lineWidth: 2)
        .shadow(color: .teal, radius: 10)
        .padding(.vertical)
        .frame(width: 256, height: 128)
}
