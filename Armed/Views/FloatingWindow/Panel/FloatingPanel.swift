//
//  FloatingPanel.swift
//  Float
//
//  Created by Aayush Pokharel on 2022-11-16.
//  Adapted from https://float.aayush.art

import Carbon
import SwiftUI

class FloatingPanel<Content: View>: NSPanel {
    @Binding var isPresented: Bool
    init(view: () -> Content,
         contentRect: NSRect,
         backing: NSWindow.BackingStoreType = .buffered,
         defer flag: Bool = false,
         isPresented: Binding<Bool>)
    {
        // Initialize the binding variable by assigning the whole value via an underscore
        self._isPresented = isPresented

        // Init the window as usual
        super.init(contentRect: contentRect,
                   styleMask: [.nonactivatingPanel, .fullSizeContentView],
                   backing: backing,
                   defer: flag)

        // Allow the panel to be on top of other windows
        isFloatingPanel = true
        level = .floating

        // Allow the pannel to be overlaid in a fullscreen space
        collectionBehavior.insert(.auxiliary)

        // Don't show a window title, even if it's set
        titleVisibility = .hidden
        titlebarAppearsTransparent = true

        // Since there is no title bar make the window moveable by dragging on the background
//        isMovableByWindowBackground = false

        // Hide when unfocused
        hidesOnDeactivate = false

        // Hide all traffic light buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true

        // Sets animations accordingly
        animationBehavior = .utilityWindow

        // Set the content view.
        // The safe area is ignored because the title bar still interferes with the geometry
        contentView = NSHostingView(rootView: view()
            .ignoresSafeArea()
            .environment(\.floatingPanel, self))
    }

    // Don't close automatically
    override func resignMain() {
//        super.resignMain()
//        close()
    }

    // Only close on authentication on on armed state
    override func close() {
        if !isPresented {
            super.close()
        }
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == .keyDown,
           event.modifierFlags.contains(.command),
           event.keyCode == kVK_ANSI_Q
        {
            return false
        }
        return super.performKeyEquivalent(with: event)
    }

    override func keyDown(with event: NSEvent) {
        if event.type == .keyDown,
           event.modifierFlags.contains(.command),
           event.keyCode == kVK_ANSI_Q
        {
            return
        }
        super.keyDown(with: event)
    }

    // `canBecomeKey` and `canBecomeMain` are both required so that text inputs inside the panel can receive focus
    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }
}

private struct FloatingPanelKey: EnvironmentKey {
    static let defaultValue: NSPanel? = nil
}

extension EnvironmentValues {
    var floatingPanel: NSPanel? {
        get { self[FloatingPanelKey.self] }
        set { self[FloatingPanelKey.self] = newValue }
    }
}
