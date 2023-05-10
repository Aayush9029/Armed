//
//  FluidView.swift
//  NativeTwitch
//
//  Created by Aayush Pokharel on 2023-03-09.
//

import FluidGradient
import SwiftUI

struct FluidView: View {
    @State var colors: [Color] = []
    @State var highlights: [Color] = []

    @State var speed = 0.75

    let colorPool: [Color] = [.green, .teal, .orange, .yellow, .red]

    var body: some View {
        VStack {
            gradient
                .onAppear(perform: setColors)
        }
    }

    func setColors() {
        colors = []
        highlights = []
        for _ in 0...Int.random(in: 5...5) {
            colors.append(colorPool.randomElement()!)
        }
        for _ in 0...Int.random(in: 5...5) {
            highlights.append(colorPool.randomElement()!)
        }
    }

    var gradient: some View {
        FluidGradient(blobs: colors,
                      highlights: highlights,
                      speed: speed)
    }
}

struct FluidView_Previews: PreviewProvider {
    static var previews: some View {
        FluidView()
    }
}
