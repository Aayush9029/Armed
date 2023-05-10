//
//  ArmedApp.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import MacControlCenterUI
import MenuBarExtraAccess
import SwiftUI

@main
struct ArmedApp: App {
    @StateObject var armedVM: ArmedVM = .init()
    @StateObject var cameraVM: CameraVM = .init()

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State var isMenuPresented: Bool = false

    var body: some Scene {
        Window("Armed Window", id: "armed-window") {
            ContentView(isMenuPresented: $isMenuPresented)
                .frame(width: 320, height: 640)
                .background(VisualEffect.popoverWindow().ignoresSafeArea())
                .environmentObject(armedVM)
                .environmentObject(cameraVM)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .appInfo) {
                // Create a custom Quit menu item with a custom action.
                Button(armedVM.armed ? "Authenticate" : "Quit Armed") {
                    if !armedVM.armed { NSApp.terminate(nil) } else {
                        let status = armedVM.authenticate()
                        print(status)
                        if status {
                            NSApp.terminate(nil)
                        }
                    }
                }
                .keyboardShortcut("q", modifiers: [.command])
            }
        }

        MenuBarExtra(content: {
            MenuView(isMenuPresented: $isMenuPresented)
                .frame(width: 320, height: 360)
                .environmentObject(armedVM)
                .environmentObject(cameraVM)

        }) {
            Label("Armed", systemImage: armedVM.armed ? "lock.shield.fill" : "lock.shield")
        }
        .menuBarExtraStyle(.window).menuBarExtraAccess(isPresented: $isMenuPresented)
    }
}

import Defaults

class AppDelegate: NSObject, NSApplicationDelegate {
    @Default(.showInDock) var showInDock

    // Override the `applicationDidFinishLaunching` method.
    func applicationDidFinishLaunching(_ notification: Notification) {
//        Disable Content (non-menu) view launch if not first time or not called from menu bar.
        NSApp.setActivationPolicy(showInDock ? .regular : .prohibited)
        NSApp.setActivationPolicy(.regular)
        let sharedApplication = CustomNSApplication.shared
        sharedApplication.delegate = self
    }
}
