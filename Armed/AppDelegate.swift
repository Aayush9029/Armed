//
//  AppDelegate.swift
//  Armed
//
//  Created by yush on 9/26/24.
//

import Defaults
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    @Default(.showInDock) private var showInDock

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(showInDock ? .regular : .prohibited)
        (NSApp as? CustomNSApplication)?.delegate = self
    }
}

class CustomNSApplication: NSApplication {
    override func terminate(_ sender: Any?) {
        // Do nothing to prevent the app from closing.
    }
}
