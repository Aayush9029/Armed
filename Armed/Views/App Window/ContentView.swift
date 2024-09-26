//
//  ContentView.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import AppKit
import Defaults
import InformationKit
import MacControlCenterUI
import MenuBarExtraAccess
import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var armedVM: ArmedVM
    @Binding var isMenuPresented: Bool
    @Default(.showInDock) var showInDock
    @State private var confirmHide: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if !armedVM.hasCameraAccess {
                    MessageBanner(
                        "Camera Access Required",
                        symbol: "camera.fill.badge.ellipsis",
                        detail: "Access to camera is required to capture images and sync with iOS app. Information will never leave your iCloud account."
                    ) {}
                }
                VStack(spacing: 12) {
                    HStack {
                        Text("Armed")
                            .font(.largeTitle)
                            .fontDesign(.serif)
                        Spacer()
                    }
                    InformationBanner(style: .init(showBorder: true))
                    Group {
                        VStack {
                            VStack {
                                Image(systemName: !armedVM.armed ? "lock.shield" : "lock.shield.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                                    .foregroundColor(.secondary)
                                Text("Explore this menu bar button\non your system status bar up top.")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                            }

                            HStack { Spacer() }
                            Text("Show menu bar app")

                            Toggle("", isOn: $isMenuPresented)
                                .toggleStyle(.switch)
                                .labelsHidden()
                        }
                        .padding()
                        .background(
                            Group {
                                if isMenuPresented { Color.blue } else { Color.gray.opacity(0.125) }
                            }
                        )
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.tertiary, lineWidth: 2)
                        )
                    }

                    SingleVideo(VideoModel.video)

                    Spacer()

                    CustomCleanButton("Hide Window\(showInDock ? " + Dock Icon" : "")", symbol: "dock.rectangle", tint: .blue) {
                        if showInDock {
                            confirmHide.toggle()
                        } else {
                            NSApp.keyWindow?.close()
                        }
                    }
                    .alert(isPresented: $confirmHide) {
                        Alert(
                            title: Text("Hide Armed Dock icon."),
                            message: Text("This will hide the Armed app icon from the dock. (recommended)"),
                            primaryButton: .default(Text("Hide Dock Icon + Main Window")) {
                                showInDock = false
                                NSApp.setActivationPolicy(.prohibited)
                                NSApp.keyWindow?.close()
                            },
                            secondaryButton: .cancel()
                        )
                    }

                    HStack {
                        Text("To view this window again, simply re-launch Armed app.")
                        Spacer()
                    }

                    .font(.callout)
                    .padding(8)
                    .background(.thickMaterial)
                    .cornerRadius(12)
                    Divider()
                    HStack {
                        CustomCleanButton("Website", symbol: "safari") {
                            openURL(URL(string: "https://armed.aayush.art")!)
                        }
                        CustomCleanButton("Release Notes", symbol: "list.bullet.clipboard") {
                            openURL(URL(string: "https://github.com/Aayush9029/Armed/releases")!)
                        }
                    }
                }
                .padding(12)
            }
        }
        .frame(width: 320, height: 640)
        .background(VisualEffect.popoverWindow().ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isMenuPresented: .constant(false))
            .background(.black.opacity(0.125))
            .environmentObject(ArmedVM())
            .frame(width: 320, height: 640)
    }
}
