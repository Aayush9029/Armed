//
//  ArmedVM.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import BatteryClient
import CameraClient
import Combine
import Defaults
import Dependencies
import LocalAuthentication
import PlayerClient
import Shared
import SwiftUI

@MainActor
class ArmedVM: ObservableObject {
    @Dependency(\.batteryClient) private var batteryClient
    @Dependency(\.playerClient) private var playerClient
    @Dependency(\.cameraClient) private var cameraClient

    @Published var armed: Bool = false
    @Published var isConnected: Bool = false
    @Published var showFrequencyPopover: Bool = false
    @Published var hasCameraAccess: Bool = false

    @Default(.sirenTimer) private var sirenTimer
    @Default(.siren) private var siren

    private var batteryMonitorTask: Task<Void, Never>?
    private var cameraTask: Task<Void, Never>?
    private var cameraAccessTask: Task<Void, Never>?

    init() {
        startMonitoringBattery()
        startMonitoringCameraAccess()
    }

    deinit {
        Task {
            await self.stopMonitoringBattery()
            await self.stopCamera()
            await self.stopMonitoringCameraAccess()
        }
    }

    func startMonitoringBattery() {
        batteryMonitorTask = Task {
            for await connected in batteryClient.batteryStatusStream {
                self.isConnected = connected
                await self.updateBatteryStatus(connected: connected)
            }
        }
    }

    func stopMonitoringBattery() {
        batteryMonitorTask?.cancel()
    }

    private func updateBatteryStatus(connected: Bool) async {
        if connected || !armed || !siren {
            if playerClient.isPlaying() {
                playerClient.stop()
            }
            return
        }

        if !connected && armed && !playerClient.isPlaying() {
            print("Playing Sound after \(sirenTimer * 30)")
            playerClient.play(after: sirenTimer * 30, again: false)
            startCamera()
        }
    }

    func openCameraSettings() {
        cameraClient.openCameraSettings()
    }

    func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unarm device"
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                if success {
                    armed = false
                    stopCamera()
                    return true
                }
            } catch {
                print("Authentication failed: \(error.localizedDescription)")
                return false
            }
        }
        return false
    }

    func startCamera() {
        cameraClient.startCamera()
    }

    func stopCamera() {
        cameraTask?.cancel()
        cameraClient.stopCamera()
    }

    func startMonitoringCameraAccess() {
        cameraAccessTask = Task {
            for await access in cameraClient.cameraAccessStream {
                self.hasCameraAccess = access
            }
        }
    }

    func stopMonitoringCameraAccess() {
        cameraAccessTask?.cancel()
    }
}
