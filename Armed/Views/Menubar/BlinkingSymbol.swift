//
//  BlinkingSymbol.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-17.
//

import SwiftUI

struct BlinkingSymbol: View {
    @State private var blink: Bool = false

    let onSymbol: String
    let offSymbol: String

    let state: Bool

    init(onSymbol: String, offSymbol: String, state: Bool) {
        self.onSymbol = onSymbol
        self.offSymbol = offSymbol
        self.state = state
    }

    var body: some View {
        Image(systemName: state ? onSymbol : offSymbol)
            .symbolVariant(.fill)
            .foregroundColor(state ? .green : .red)
            .opacity((blink && state) ? 1 : 0.5)
            .shadow(color: state ? .green : .red, radius: blink ? 4 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    blink.toggle()
                }
            }.transaction { transaction in
                transaction.animation = nil
            }
    }
}

struct BlinkingSymbol_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BlinkingSymbol(onSymbol: "bolt", offSymbol: "bolt.slash", state: true)
                .padding()
            BlinkingSymbol(onSymbol: "bolt", offSymbol: "bolt.slash", state: false)
                .padding()
        }
    }
}
