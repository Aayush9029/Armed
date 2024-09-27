import Defaults
import MacControlCenterUI
import MenuBarExtraAccess
import SwiftUI

@main
struct ArmedApp: App {
    @StateObject private var armedVM = ArmedVM()
    @State private var isMenuPresented = false
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(isMenuPresented: $isMenuPresented)
                .frame(width: 420, height: 640)
                .environmentObject(armedVM)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            customCommands
        }

        MenuBarExtra {
            menuBarContent
        } label: {
            menuBarLabel
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isMenuPresented)
    }

    private var customCommands: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button(armedVM.armed ? "Authenticate" : "Quit Armed") {
                armedVM.armed ? authenticateAndQuit() : NSApp.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        }
    }

    private var menuBarContent: some View {
        MenuView(isMenuPresented: $isMenuPresented)
            .frame(width: 320, height: 420)
            .environmentObject(armedVM)
    }

    private var menuBarLabel: some View {
        Label("Armed", systemImage: armedVM.armed ? "lock.shield.fill" : "lock.shield")
    }

    private func authenticateAndQuit() {
        Task {
            if await armedVM.authenticate() {
                NSApp.terminate(nil)
            }
        }
    }
}
