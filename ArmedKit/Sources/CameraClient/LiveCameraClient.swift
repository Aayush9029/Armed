//
//  LiveCameraClient.swift
//  Armed
//
//  Created by yush on 9/26/24.
//

import AVFoundation
import Combine
import CoreImage
import SwiftUI

class LiveCameraClient: NSObject, CameraClient, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private let fps: Int = 30
    private let videoOutput = AVCaptureVideoDataOutput()
    private var frameContinuation: AsyncThrowingStream<CIImage?, Error>.Continuation?
    private var framesStream: AsyncThrowingStream<CIImage?, Error>?
    private var cameraAccessContinuation: AsyncStream<Bool>.Continuation?

    lazy var cameraAccessStream: AsyncStream<Bool> = AsyncStream { continuation in
        self.cameraAccessContinuation = continuation
        self.checkCameraAccess()
    }

    var frames: AsyncThrowingStream<CIImage?, Error> {
        if let framesStream = framesStream {
            return framesStream
        } else {
            let stream = AsyncThrowingStream<CIImage?, Error> { continuation in
                self.frameContinuation = continuation
            }
            framesStream = stream
            return stream
        }
    }

    override init() {
        super.init()
        setupCamera()
    }

    private func checkCameraAccess() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                self.cameraAccessContinuation?.yield(granted)
            }
        case .restricted, .denied:
            cameraAccessContinuation?.yield(false)
        case .authorized:
            cameraAccessContinuation?.yield(true)
        @unknown default:
            cameraAccessContinuation?.yield(false)
        }
    }

    func startCamera() {
        captureSession.startRunning()
        checkCameraAccess()
    }

    func stopCamera() {
        captureSession.stopRunning()
        frameContinuation?.finish()
    }

    func hasCameraAccess() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return true
        default:
            return false
        }
    }

    private func setupCamera() {
        captureSession.beginConfiguration()

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) { captureSession.addInput(input) }
            captureSession.sessionPreset = .medium
        } catch {
            print("Error setting up camera input: \(error)")
            return
        }

        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) { captureSession.addOutput(videoOutput) }

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

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let frameContinuation = frameContinuation else { return }
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        frameContinuation.yield(ciImage)
    }
}
