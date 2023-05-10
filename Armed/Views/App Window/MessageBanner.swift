//
//  MessageBanner.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-17.
//

import SwiftUI

struct MessageBanner: View {
    @State private var hovered: Bool = false
    let symbol: String
    let title: String
    let detail: String
    let tint: Color
    let action: () -> Void

    init(_ title: String, symbol: String = "circle", detail: String, tint: Color = .red, action: @escaping () -> Void) {
        self.title = title
        self.symbol = symbol
        self.detail = detail
        self.tint = tint
        self.action = action
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: symbol)
                    .symbolVariant(.fill)
                Text(title)
            }
            .font(.title3.bold())
            Text(detail)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(tint.opacity(hovered ? 1 : 0.75))
        .roundedCorners(radius: 16, corners: [.bottomLeft, .bottomRight])
        .onHover(perform: { state in
            withAnimation {
                hovered = state
            }
        })
        .onTapGesture {
            action()
        }
    }
}

struct MessageBanner_Previews: PreviewProvider {
    static var previews: some View {
        MessageBanner("Camera Access Required", symbol: "camera.fill.badge.ellipsis", detail: "Access to camera is required to capture live data. The data never leaves your iCloud account.", action: {})
            .padding()
    }
}
