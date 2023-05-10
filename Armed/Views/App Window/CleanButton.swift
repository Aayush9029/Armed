//
//  CustomCleanButton.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-17.
//

import SwiftUI

struct CustomCleanButton: View {
    let symbol: String
    let title: String
    let tint: Color
    let action: () -> Void

    init(_ title: String, symbol: String, tint: Color = .orange, action: @escaping () -> Void) {
        self.symbol = symbol
        self.title = title
        self.tint = tint
        self.action = action
    }

    var body: some View {
        CustomCleanButtonLabel(title, symbol: symbol, tint: tint)
            .onTapGesture { action() }
    }
}

// MARK: - Reusable Clean Button Label

struct CustomCleanButtonLabel: View {
    @State private var hovered: Bool = false
    let symbol: String
    let title: String
    let tint: Color

    init(_ title: String, symbol: String, tint: Color) {
        self.symbol = symbol
        self.title = title
        self.tint = tint
    }

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .foregroundColor(.white)
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(4)
                .background(tint)
                .clipShape(Circle())
                .shadow(color: tint, radius: 12)
                .symbolVariant(.fill)
            Spacer()
            Text(title)
            Spacer()
        }.padding(4)
            .background(hovered ? tint.opacity(0.5) : .gray.opacity(0.125))
            .animation(.easeIn, value: hovered)
            .cornerRadius(16)
            .onHover { val in
                withAnimation { hovered = val }
            }
    }
}

struct CustomCleanButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomCleanButton("Website", symbol: "safari") {
            print("Hi")
        }
    }
}
