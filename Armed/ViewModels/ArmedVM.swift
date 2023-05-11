//
//  ArmedVM.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import Combine
import Defaults
import IOKit.ps
import LocalAuthentication
import SwiftUI

class ArmedVM: ObservableObject {
//    UI control variables
    @Published var highPitchedPlayer = HighPitchedAudioPlayer()

    @Published var armed: Bool = false

    //    UI View variables
    @Published var isConnected: Bool = false
    @Published var showFrequencyPopover: Bool = false

    private var monitor: AnyCancellable?
    private var refreshInterval: TimeInterval = 1.0

    @Default(.sirenTimer) var sirenTimer
    @Default(.siren) var siren
    init() {
        startMonitoringBattery()
    }

    deinit {
        stopMonitoringBattery()
    }

    func stopMonitoringBattery() {
        monitor?.cancel()
    }

    func startMonitoringBattery() {
        monitor = Timer.publish(every: refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateBatteryStatus()
            }
    }

    private func updateBatteryStatus() {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        for source in sources {
            let description = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as NSDictionary
            let powerSourceState = description[kIOPSPowerSourceStateKey] as? String
            isConnected = powerSourceState == kIOPSACPowerValue

            if isConnected || !armed || !siren {
                if highPitchedPlayer.isPlaying() { highPitchedPlayer.stop() }
                return
            }

            if !isConnected && armed && !highPitchedPlayer.isPlaying() {
                print("Playing Sound after \(sirenTimer * 30)")
                highPitchedPlayer.play(after: sirenTimer * 30)
                return
            }
        }
    }

    func authenticate() -> Bool {
        let context = LAContext()
        var error: NSError?
        var authenticated = false
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unarm device"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                if success {
                    DispatchQueue.main.async {
                        self.armed = false
                    }
                    authenticated = true
                }
            }
        }
        return authenticated
    }

    static func isConnected() -> Bool {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        for source in sources {
            let description = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as NSDictionary
            let powerSourceState = description[kIOPSPowerSourceStateKey] as? String
            return powerSourceState == kIOPSACPowerValue
        }
        return false
    }
}
