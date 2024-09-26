//
//  TouchIDButton.swift
//  Armed
//
//  Created by yush on 9/26/24.
//


//
//  TouchIDButton.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import SwiftUI

struct TouchIDButton: View {
    @EnvironmentObject var armedVM: ArmedVM

    var body: some View {
        Button {
            Task {
                _ = await armedVM.authenticate()
            }
        } label: {
            GroupBox {
                VStack {
                    Label("Un-Arm with biometrics", systemImage: "touchid")
                        .labelStyle(.iconOnly)
                        .font(.largeTitle)
                        .foregroundStyle(.tertiary)
                        .padding(6)
                    Text("Un-arm MacBook")
                }
                .padding(8)
            }
            .padding()
        }
        .buttonStyle(.plain)
    }
}
