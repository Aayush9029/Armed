//
//  CameraVM.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import AppKit
import AVFoundation
import Combine
import CoreData
import CoreImage
import Defaults
import SwiftUI

struct BufferImageModel: Identifiable {
    var id: Double { dateTime }
    let dateTime: Double
    let image: CIImage
}

class CameraVM: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var currentFrame: Image?
    private let captureSession = AVCaptureSession()

    private let fps: Int = 30

    private var frameCount: Int = 1 // first frame appears dark
    private var bufferInterval: Int = 60
    private var maxBufferCount: Int = 10

    var bufferUploaded: Bool = false
    @Published var imageBuffer: [BufferImageModel] = []

    @Default(.captureImage) var captureImage

    override init() {
        super.init()
        setupCamera()
    }

    func startCamera() {
        captureSession.startRunning()
    }

    func stopCamera() {
        captureSession.stopRunning()
    }

    func hasCameraAccess() -> Bool {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .authorized:
            return true
        case .notDetermined, .restricted, .denied:
            return false
        @unknown default:
            return false
        }
    }

    private func addToBuffer(image: CIImage?) {
        if imageBuffer.count >= maxBufferCount { _ = imageBuffer.removeFirst() }
        if let image {
            imageBuffer.append(BufferImageModel(dateTime: Date().timeIntervalSince1970, image: image))
        }
    }

    private func listAllAvailableCameras() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .externalUnknown], mediaType: .video, position: .unspecified)

        let devices = discoverySession.devices

        if devices.isEmpty {
            print("No available cameras")
        } else {
            for device in devices {
                print("Camera: \(device.localizedName), Position: \(device.position.rawValue)")
            }
        }
    }

    private func setupCamera() {
        captureSession.beginConfiguration()
        listAllAvailableCameras()
        // Set up the capture device and input
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) { captureSession.addInput(input) }
            captureSession.sessionPreset = .medium
        } catch {
            print("Error setting up camera input: \(error)")
            return
        }

        // Set up the video output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

        if captureSession.canAddOutput(videoOutput) { captureSession.addOutput(videoOutput) }

        // Set up custom fps
        guard let connection = videoOutput.connection(with: .video) else { return }

        connection.videoOrientation = .portrait
        if connection.isVideoMinFrameDurationSupported {
            connection.videoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(fps))
        }

        if connection.isVideoMaxFrameDurationSupported {
            connection.videoMaxFrameDuration = CMTime(value: 1, timescale: CMTimeScale(fps))
        }

        captureSession.commitConfiguration()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvImageBuffer: imageBuffer)

        DispatchQueue.main.async {
            self.currentFrame = ciImageToImage(ciImage)
            self.frameCount += 1

            if (self.frameCount % self.bufferInterval) != 0 { return }

            if self.captureImage || !ArmedVM.isConnected() {
                guard let data = ciImageToData(ciImage) else { return }
                addStoredImage(imageData: data, connected: ArmedVM.isConnected())
            }

            self.addToBuffer(image: ciImage)

            if !self.captureImage && !ArmedVM.isConnected() && !self.bufferUploaded {
                self.bufferUploaded = true
                for buffer in self.imageBuffer {
                    guard let data = ciImageToData(buffer.image) else { return }
                    addStoredImage(imageData: data, connected: false)
                }
            }

            self.frameCount = 0
        }
    }

    static func showCameraSettingsAlert() {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Camera Access Required"
            alert.informativeText = "This app requires access to the camera. Please update your settings to allow camera access."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Open Settings")
            alert.addButton(withTitle: "Cancel")
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                if let settingsURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera") {
                    NSWorkspace.shared.open(settingsURL)
                }
            }
        }
    }
}

struct CameraView: View {
    @ObservedObject var cameraVM: CameraVM

    var body: some View {
        VStack {
            if let currentFrame = cameraVM.currentFrame {
                currentFrame
                    .resizable()
                    .scaledToFill()

            } else {
                Text("No camera input")
            }
        }
    }
}

func ciImageToImage(_ ciImage: CIImage) -> Image? {
    // Convert CIImage to NSCIImageRep
    let ciImageRep = NSCIImageRep(ciImage: ciImage)

    // Convert NSCIImageRep to NSImage
    let nsImage = NSImage(size: ciImageRep.size)
    nsImage.addRepresentation(ciImageRep)
    return Image(nsImage: nsImage)
}

func ciImageToData(_ ciImage: CIImage) -> Data? {
    let ciImageRep = NSCIImageRep(ciImage: ciImage)

    // Convert NSCIImageRep to NSImage
    let nsImage = NSImage(size: ciImageRep.size)
    nsImage.addRepresentation(ciImageRep)
    return nsImage.data
}
