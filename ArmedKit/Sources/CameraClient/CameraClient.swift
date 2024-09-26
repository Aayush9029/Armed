import AppKit
import AVFoundation
import Dependencies
import SwiftUI

public protocol CameraClient {
    var frames: AsyncThrowingStream<CIImage?, Error> { get }
    func startCamera()
    func stopCamera()
    func hasCameraAccess() -> Bool
    func openCameraSettings()
}

public extension DependencyValues {
    var cameraClient: CameraClient {
        get { self[CameraClientKey.self] }
        set { self[CameraClientKey.self] = newValue }
    }
}

public struct CameraClientKey: DependencyKey {
    public static let liveValue: CameraClient = LiveCameraClient()
}

extension CameraClient {
    func openCameraSettings() {
        let prefPaneURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera")!
        NSWorkspace.shared.open(prefPaneURL)
    }
}
