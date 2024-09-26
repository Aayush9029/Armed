//
//  CameraView.swift
//  Armed
//
//  Created by yush on 9/26/24.
//


//
//  CameraView.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import SwiftUI
import Dependencies

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
                    if let frame = frame {
                        frameImage = frame
                    }
                }
            } catch {
                print("Error receiving camera frames: \(error)")
            }
        }
    }
}
