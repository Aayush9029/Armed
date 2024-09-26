//
//  MenuView.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-16.
//

import AppKit
import Defaults
import MacControlCenterUI
import SwiftUI

struct MenuView: View {
    @EnvironmentObject var armedVM: ArmedVM
    @EnvironmentObject var cameraVM: CameraVM
    @Binding var isMenuPresented: Bool

    let persistenceController = PersistenceController.shared
    @Default(.siren) var siren
    @Default(.showInDock) var showInDock
    @Default(.maxVolume) var maxVolume

    var body: some View {
        NavigationStack {
            MacControlCenterMenu(isPresented: $isMenuPresented) {
                VStack(spacing: 8) {
                    MenuHeader("Armed") {
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    Group {
                        VStack {
                            HStack {
                                BlinkingSymbol(onSymbol: "bolt", offSymbol: "bolt.slash", state: armedVM.isConnected)
                                Text("\(!armedVM.isConnected ? "Not" : "") Ready")
                                    .bold()
                                Spacer()
                                Text("\(!armedVM.isConnected ? "connect" : "connected") to power source")
                                    .foregroundStyle(.secondary)
                            }
                            if armedVM.isConnected && siren && NSSound.systemVolume < 0.5 && !maxVolume {
                                HStack {
                                    BlinkingSymbol(onSymbol: "speaker.wave.2.fill", offSymbol: "speaker.fill", state: false)
                                    Spacer()
                                    Text("Sound Volume is only \(Int(NSSound.systemVolume * 100))%")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            if !cameraVM.hasCameraAccess() {
                                EnableCameraLabel()
                            }

                            Group {
                                HStack(spacing: 8) {
                                    if !armedVM.isConnected && !armedVM.armed {
                                        Group {
                                            ControlCenterButton(
                                                false,
                                                title: "Connect to charger",
                                                icon: "powerplug.fill",
                                                tint: .red,
                                                size: .title2
                                            ) {}
                                        }
                                    } else {
                                        ControlCenterButton(
                                            armedVM.armed,
                                            title: armedVM.armed ? "Unarm\nMacbook" : "Arm\nMacbook",
                                            icon: armedVM.armed ? "touchid" : "shield.lefthalf.filled",
                                            tint: .red
                                        ) {
                                            if armedVM.armed {
                                                if armedVM.authenticate() && !showInDock {
                                                    NSApp.setActivationPolicy(.regular)
                                                }
                                            } else {
                                                if showInDock {
                                                    NSApp.setActivationPolicy(.prohibited)
                                                }
                                                armedVM.armed.toggle()
                                            }
                                        }
                                    }

                                    if !armedVM.armed && armedVM.isConnected {
                                        ArmedOptions()
                                            .environmentObject(armedVM)
                                    }
                                }
                            }

                            if !armedVM.armed {
                                SirenSlider()
                                    .environmentObject(armedVM)
                            }

                            if !armedVM.armed {
                                VStack {
                                    HStack {
                                        NavigationLink(destination: {
                                            CloudPhotosView()
                                                .padding(.top, -24)
                                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                        }, label: {
                                            HStack {
                                                Label("Cloud Images", systemImage: "icloud")
                                                Spacer()
                                                Image(systemName: "chevron.forward")
                                                    .foregroundStyle(.tertiary)
                                            }.ccGlassButton()

                                        })
                                        .buttonStyle(.plain)
                                    }

                                    HStack {
                                        Label("Info", systemImage: "info.circle")
                                            .frame(width: 124)
                                            .ccGlassButton()
                                            .onTapGesture {
                                                showStandardAboutWindow()
                                            }
                                        Label("Quit", systemImage: "power")
                                            .frame(width: 124)
                                            .ccGlassButton()
                                            .onTapGesture {
                                                quit()
                                            }
                                    }
                                    .labelStyle(.titleAndIcon)
                                }
                            }
                        }
                    }
                }
                .floatingPanel(isPresented: $armedVM.armed, content: {
                    WarnTimerView()
                        .environmentObject(armedVM)
                        .environmentObject(cameraVM)

                })
                .onChange(of: armedVM.armed) { newValue in
                    if !cameraVM.hasCameraAccess() { print("Need access to camera"); return }
                    if newValue {
                        cameraVM.startCamera()
                    } else {
                        cameraVM.stopCamera()
                    }
                }
            }
        }
    }

    // MARK: Actions

    func quit() { NSApp.terminate(nil) }

    func showStandardAboutWindow() {
        NSApp.sendAction(
            #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
            to: nil,
            from: nil
        )
    }
}

// MARK: - Menu Options

struct ArmedOptions: View {
    @Default(.showInDock) var showInDock
    @Default(.maxVolume) var maxVolume
    @Default(.captureImage) var captureImage
    @Default(.siren) var siren

    var body: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
                ControlCenterButton(captureImage, title: "Capture\nPlugged", icon: "camera") {
                    captureImage.toggle()
                }
                ControlCenterButton(!showInDock, title: "Hide\n Dock", icon: "dock.arrow.down.rectangle") {
                    showInDock.toggle()
                    NSApp.setActivationPolicy(showInDock ? .regular : .prohibited)
                }
            }
            GridRow {
                ControlCenterButton(siren, title: "Play\nSiren", icon: "light.beacon.max") {
                    siren.toggle()
                }
                ControlCenterButton(maxVolume, title: "Max\nVolume", icon: "speaker.wave.3.fill", tint: .red) {
                    maxVolume.toggle()
                }
                .disabled(!siren)
                .opacity(siren ? 1 : 0.15)
            }
        }
    }
}

// MARK: - Enable Camera Label

struct EnableCameraLabel: View {
    var body: some View {
        HStack {
            Image(systemName: "hand.raised.fill")
                .foregroundColor(.red)
            Text("Not Ready")
                .bold()
            Spacer()
            Text("Grant Access to Camera")
                .foregroundStyle(.secondary)
                .onTapGesture {
                    CameraVM.showCameraSettingsAlert()
                }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(isMenuPresented: .constant(true))
            .environmentObject(ArmedVM())
            .environmentObject(CameraVM())
            .frame(width: 320, height: 420)
    }
}
