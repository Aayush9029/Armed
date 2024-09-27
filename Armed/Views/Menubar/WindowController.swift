import AppKit
import SwiftUI

/// A helper class to manage the NSWindow with a SwiftUI view as a full-screen screen saver.
class ScreenSaverWindowController<Content: View>: NSWindowController {
    init(rootView: Content) {
        let hostingController = NSHostingController(rootView: rootView)
        let window = NSWindow(
            contentViewController: hostingController
        )
        super.init(window: window)
        
        setupFullScreenScreenSaver()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFullScreenScreenSaver() {
        guard let window = window, let screen = NSScreen.main else { return }
        
        // Set window properties
        window.styleMask = [.borderless, .hudWindow]
        window.level = .screenSaver
        window.collectionBehavior = [.stationary, .ignoresCycle, .primary]
        
        // Set window frame to cover the entire screen
        window.setFrame(screen.frame, display: true)
        
        // Make the window key and visible
        window.makeKeyAndOrderFront(nil)
        
        // Hide the cursor
        NSCursor.hide()
        
        // Add event monitor to exit on user input
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .keyDown]) { _ in
            NSApplication.shared.terminate(nil)
        }
    }
}

/// Opens a new full-screen window with the provided SwiftUI view as a screen saver.
///
/// - Parameter view: The SwiftUI view to display as a screen saver.
/// - Returns: An instance of `ScreenSaverWindowController` for the window.
func openScreenSaver<Content: View>(with view: Content) -> ScreenSaverWindowController<Content> {
    let windowController = ScreenSaverWindowController(rootView: view)
    return windowController
}
