//
//  ControlCenterButton.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

//
//  ControlCenterButton.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-21.
//

import SwiftUI

public struct ControlCenterButton: View {
    let value: Bool
    let title: String
    let icon: String
    let tint: Color
    let size: Font
    var action: () -> Void

    public init(
        _ value: Bool,
        title: String,
        icon: String,
        tint: Color = .blue,
        size: Font = .caption,
        action: @escaping () -> Void
    ) {
        self.value = value
        self.title = title
        self.icon = icon
        self.tint = tint
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(systemName: icon)
                    .imageScale(.large)
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
        }
        .buttonStyle(.plain)
        .buttonBorderShape(.roundedRectangle)
    }
}

#Preview {
    HStack {
        ControlCenterButton(
            true,
            title: "Capture\nImages",
            icon: "camera"
        ) {}
        ControlCenterButton(
            false,
            title: "Capture\nImage",
            icon: "camera",
            size: .caption2
        ) {}
    }
    .frame(width: 144, height: 84)
    .padding()
}
