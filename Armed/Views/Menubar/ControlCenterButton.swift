//
//  ControlCenterButton.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-21.
//

import Defaults
import SwiftUI
struct ControlCenterButton: View {
    let value: Bool
    let title: String
    let icon: String
    let tint: Color
    let size: Font
    var action: () -> Void

    init(_ value: Bool, title: String, icon: String, tint: Color = .blue, size: Font = .caption, action: @escaping () -> Void) {
        self.value = value
        self.title = title
        self.icon = icon
        self.tint = tint
        self.size = size
        self.action = action
    }

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: size == .caption ? 18 : 24, height: 18)
                .shadow(color: tint.opacity(0.25), radius: value ? 2 : 0)
                .symbolRenderingMode(.hierarchical)
            Text(title)
                .multilineTextAlignment(.center)
                .font(size)
                .frame(minHeight: 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(value ? tint : .primary)
        .ccGlassButton(filled: value, hoverable: true)

        .onTapGesture {
            action()
        }
    }
}

struct ControlCenterButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ControlCenterButton(true, title: "Capture\nImages", icon: "camera") {}
            ControlCenterButton(false, title: "Capture\nImages", icon: "camera", size: .title2) {}
        }
        .padding()
    }
}
