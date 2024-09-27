//
//  BatteryClient.swift
//  Armed
//
//  Created by yush on 9/26/24.
//

import Dependencies
import Foundation
import IOKit.ps

public protocol BatteryClient {
    var isConnected: Bool { get }
    var batteryStatusStream: AsyncStream<Bool> { get }
}

public extension DependencyValues {
    var batteryClient: BatteryClient {
        get { self[BatteryClientKey.self] }
        set { self[BatteryClientKey.self] = newValue }
    }
}

public struct BatteryClientKey: DependencyKey {
    public static let liveValue: BatteryClient = LiveBatteryClient()
}
