import Dependencies
import Shared
import SwiftUI

struct CameraView: View {
    @Dependency(\.cameraClient) private var cameraClient
    @State private var frameImage: Image?
    @State private var cameraFramesTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            if let frameImage = frameImage {
                frameImage
                    .resizable()
                    .scaledToFill()
            } else {
                Color.black
            }
        }
        .onAppear {
            startCameraFramesTask()
        }
        .onDisappear {
            cameraFramesTask?.cancel()
        }
    }

    func startCameraFramesTask() {
        cameraFramesTask = Task {
            do {
                for try await frame in cameraClient.frames {
                    if let frame {
                        frameImage = ciImageToImage(frame)
                    }
                }
            } catch {
                print("Error receiving camera frames: \(error)")
            }
        }
    }
}
