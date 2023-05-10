//
//  ContentView.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import AppKit
import FluidGradient
import InformationKit
import MenuBarExtraAccess
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cameraVM: CameraVM
    @EnvironmentObject var armedVM: ArmedVM
    @Binding var isMenuPresented: Bool

    var body: some View {
        NavigationStack {
            VStack {
                if !cameraVM.hasCameraAccess() {
                    MessageBanner(
                        "Camera Access Required",
                        symbol: "camera.fill.badge.ellipsis",
                        detail: "Access to camera is required to capture images and sync with iOS app. Information will never leave your iCloud account."
                    ) {
                        CameraVM.showCameraSettingsAlert()
                    }
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

                    HStack {
                        CustomCleanButton("Website", symbol: "safari") {
                            print("Hi")
                        }
                        CustomCleanButton("Release Notes", symbol: "list.bullet.clipboard") {
                            print("Hi")
                        }
                    }
                }
                .padding(12)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isMenuPresented: .constant(false))
            .background(.black.opacity(0.125))
            .environmentObject(ArmedVM())
            .environmentObject(CameraVM())
            .frame(width: 320, height: 640)
    }
}
