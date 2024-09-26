//
//  FrequencyTooCloseWarning.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

import SwiftUI

struct FrequencyTooCloseWarning: View {
    @State private var popoverIsPresented: Bool = false

    var body: some View {
        Group {
            Label("Too Close", systemImage: "exclamationmark.triangle.fill")
                .onHover(perform: { _ in
                    popoverIsPresented.toggle()
                })
                .labelStyle(.iconOnly)
                .foregroundColor(.yellow)
                .popover(isPresented: $popoverIsPresented) {
                    Text("+- 500Hz between MIN and MAX frequencies is recommended for better differentiation")
                        .bold()
                        .font(.callout)
                        .foregroundStyle(.primary)
                        .padding()
                }
        }
    }
}

#Preview {
    FrequencyTooCloseWarning()
        .padding()
}
