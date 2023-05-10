//
//  SirenSlider.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-21.
//

import MacControlCenterUI
import SwiftUI

struct SirenSlider: View {
    @EnvironmentObject var armedVM: ArmedVM
    @State private var hovering: Bool = false
    private let sliderWidth: CGFloat = 270
    var body: some View {
        NavigationLink {
            SirenSettingsView()
                .environmentObject(armedVM)
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text("Siren Countdown")
                    Text("\(Int(armedVM.soundTimer * 30))s")
                        .foregroundStyle(.secondary)
                    Spacer()

                    Image(systemName: "chevron.forward")
                        .foregroundStyle(.tertiary)
                        .opacity(hovering ? 1 : 0)
                }
                .font(.callout)
                .bold()
                MenuSlider(value: $armedVM.soundTimer,
                           image: Image(systemName: "timer")
                               .symbolRenderingMode(.hierarchical))
                    .frame(minWidth: sliderWidth)
            }
            .ccGlassButton(padding: 10)
            .onHover(perform: { value in
                hovering = value
            })
        }
        .buttonStyle(.plain)
    }
}

struct SirenSlider_Previews: PreviewProvider {
    static var previews: some View {
        SirenSlider()
            .environmentObject(ArmedVM())
    }
}
