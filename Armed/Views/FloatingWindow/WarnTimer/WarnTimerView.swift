import Defaults
import Dependencies
import SwiftUI
import UI

struct WarnTimerView: View {
    @EnvironmentObject var armedVM: ArmedVM
    @Dependency(\.cameraClient) private var cameraClient

    @Default(.message) var message
    @Default(.sirenTimer) var sirenTimer
    @Default(.maxVolume) var maxVolume

    @State private var imageBuffer: [BufferImageModel] = []
    @State private var cameraTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            if !armedVM.isConnected {
                ZStack {
                    FlashLights()
                    TimerView(inputTime: sirenTimer) {
                        _ = await armedVM.authenticate()
                    }
                }
                .ignoresSafeArea()
            } else {
                Group {
                    CameraView()
                        .blur(radius: 16)
                        .ignoresSafeArea()
                }
                VStack {
                    DangerOverlay(message)

                    if !imageBuffer.isEmpty {
                        ImageBufferRow(imageBuffer)
                    }
                    TouchIDButton {
                        _ = await armedVM.authenticate()
                    }
                }
                .padding()
            }
        }
        .frame(
            minWidth: NSScreen.main?.frame.width ?? 720,
            minHeight: NSScreen.main?.frame.height ?? 640
        )
        .onAppear {
            if armedVM.armed {
                startCamera()
            }
        }
        .onDisappear {
            stopCamera()
        }
    }

    func startCamera() {
        cameraTask = Task {
            cameraClient.startCamera()
            do {
                for try await frame in cameraClient.frames {
                    if let frame = frame {
                        let bufferImage = BufferImageModel(image: frame)
                        imageBuffer.append(bufferImage)
                        if imageBuffer.count > 5 {
                            imageBuffer.removeFirst()
                        }
                    }
                }
            } catch {
                print("Error receiving camera frames: \(error)")
            }
        }
    }

    func stopCamera() {
        cameraTask?.cancel()
        cameraClient.stopCamera()
    }
}
