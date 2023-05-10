//
//  SingleVideo.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-17.
//

import SwiftUI

struct VideoModel {
    let url: URL
    let type: VideoModelType
    let title: String
    let thumbnail: String

    static let video =
        VideoModel(
            url: URL(string: "https://www.youtube.com/watch?v=MeVpmNFGqZA&list=PLUBjdhA9EwE5NzjU4-uO5ewEILcJ0UIWG")!,
            type: .video,
            title: "Basic Introduction",
            thumbnail: "BasicIntroduction"
        )
}

enum VideoModelType {
    case video, link
}

struct SingleVideo: View {
    @Environment(\.openURL) var openURL
    @State private var hovered: Bool = false

    let video: VideoModel

    init(_ video: VideoModel) {
        self.video = video
    }

    var body: some View {
        VStack {
            ZStack {
                Image(video.thumbnail)
                    .resizable()
                    .scaledToFit()

                HStack {
                    switch video.type {
                    case .video:
                        Group {
                            Image(systemName: "play.circle.fill")
                            Text("Video")
                        }
                    case .link:
                        Group {
                            Image(systemName: "doc.text.below.ecg.fill")
                            Text("Blog")
                        }
                    }
                }
                .foregroundColor(.white.opacity(hovered ? 1 : 0.5))
                .font(.title3)
                .padding(.horizontal, 4)
                .padding(6)
                .background(.thickMaterial)
                .cornerRadius(8)
                .onHover(perform: { state in
                    withAnimation {
                        hovered = state
                    }
                })
                .onTapGesture {
                    openURL(video.url)
                }
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.tertiary, lineWidth: 2)
        )
    }
}

struct SingleVideo_Previews: PreviewProvider {
    static var previews: some View {
        SingleVideo(VideoModel.video)
    }
}
