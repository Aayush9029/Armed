import SwiftUI

public struct SingleVideo: View {
    @Environment(\.openURL) private var openURL
    @State private var isHovered = false
    
    private let video: VideoModel
    
    public init(_ video: VideoModel) {
        self.video = video
    }
    
    public var body: some View {
        VStack {
            ZStack {
                thumbnailImage
                typeOverlay
            }
        }
        .clipShape(.rect(cornerRadius: 8))
        .overlay(borderOverlay)
    }
    
    private var thumbnailImage: some View {
        Image(video.thumbnail)
            .resizable()
            .scaledToFill()
    }
    
    private var typeOverlay: some View {
        HStack {
            Image(systemName: "play.fill")
            Text("Play Video")
        }
        .foregroundColor(isHovered ? .white : .red)
        .padding(.horizontal, 6)
        .padding(4)
        .background(isHovered ? .red : .white)
        .clipShape(.capsule)
        .onHover { isHovered = $0 }
        .animation(.easeInOut, value: isHovered)
        .onTapGesture { openURL(video.url) }
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(.tertiary, lineWidth: 2)
    }
}

// MARK: - Video Model

public struct VideoModel {
    let url: URL
    let thumbnail: String
    
    public init(
        url: URL,
        thumbnail: String
    ) {
        self.url = url
        self.thumbnail = thumbnail
    }
    
    public static let demo = VideoModel(
        url: URL(string: "https://www.youtube.com/watch?v=MeVpmNFGqZA&list=PLUBjdhA9EwE5NzjU4-uO5ewEILcJ0UIWG")!,
        thumbnail: "BasicIntroduction"
    )
}

#Preview {
    SingleVideo(.demo)
        .padding()
        .frame(width: 512, height: 128)
}
