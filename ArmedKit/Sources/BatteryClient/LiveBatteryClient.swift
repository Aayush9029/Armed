//
//  LiveBatteryClient.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

import Dependencies
import DependenciesMacros
import Foundation
import IOKit.ps
import SwiftUI

struct LiveBatteryClient: BatteryClient {
    var isConnected: Bool {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        for source in sources {
            if let description = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as? NSDictionary,
               let powerSourceState = description[kIOPSPowerSourceStateKey] as? String
            {
                return powerSourceState == kIOPSACPowerValue
            }
        }
        return false
    }

    var batteryStatusStream: AsyncStream<Bool> {
        AsyncStream { continuation in
            Task {
                while !Task.isCancelled {
                    continuation.yield(!self.isConnected)
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                }
                continuation.finish()
            }
        }
    }
}
