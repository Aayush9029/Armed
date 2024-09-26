//
//  ArmedApp.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import Defaults
import MacControlCenterUI
import MenuBarExtraAccess
import SwiftUI

@main
struct ArmedApp: App {
    @StateObject var armedVM: ArmedVM = .init()

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State var isMenuPresented: Bool = false

    var body: some Scene {
        Window("Armed Window", id: "armed-window") {
            ContentView(isMenuPresented: $isMenuPresented)
                .environmentObject(armedVM)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .appInfo) {
                // Create a custom Quit menu item with a custom action.
                Button(self.armedVM.armed ? "Authenticate" : "Quit Armed") {
                    if !self.armedVM.armed { NSApp.terminate(nil) }
                    else {
                        Task {
                            let status = await self.armedVM.authenticate()
                            print(status)
                            if status {
                                NSApp.terminate(nil)
                            }
                        }
                    }
                }
                .keyboardShortcut("q", modifiers: [.command])
            }
        }
        MenuBarExtra(content: {
            MenuView(isMenuPresented: $isMenuPresented)
                .frame(width: 320, height: 380)
                .environmentObject(armedVM)

        }) {
            Label("Armed", systemImage: armedVM.armed ? "lock.shield.fill" : "lock.shield")
        }
        .menuBarExtraStyle(.window).menuBarExtraAccess(isPresented: $isMenuPresented)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    @Default(.showInDock) var showInDock

    // Override the `applicationDidFinishLaunching` method.
    func applicationDidFinishLaunching(_ notification: Notification) {
//        Disable Content (non-menu) view launch if not first time or not called from menu bar.

        NSApp.setActivationPolicy(showInDock ? .regular : .prohibited)
        let sharedApplication = CustomNSApplication.shared
        sharedApplication.delegate = self
    }
}

class CustomNSApplication: NSApplication {
    override func terminate(_ sender: Any?) {
        // Do nothing to prevent the app from closing.
    }
}
