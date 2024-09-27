import SwiftUI

public struct MessageBanner: View {
    private let data: MessageBannerData
    @State private var isHovered: Bool = false
    let onAction: () -> Void

    public init(
        _ title: String,
        symbol: String = "circle",
        detail: String,
        tint: Color = .red,
        action: @escaping () -> Void
    ) {
        self.data = MessageBannerData(
            title: title,
            symbol: symbol,
            detail: detail,
            tint: tint
        )
        self.onAction = action
    }

    public init(
        _ data: MessageBannerData,
        action: @escaping () -> Void
    ) {
        self.data = data
        self.onAction = action
    }

    public var body: some View {
        VStack {
            HStack { Spacer() }
            headerView
            detailView
        }
        .padding()
        .background(
            data.tint.saturation(isHovered ? 1 : 0.75)
        )
        .clipShape(
            RoundedCorner(
                radius: 20,
                corners: [.bottomLeft, .bottomRight]
            )
        )
        .animation(.easeInOut, value: isHovered)
        .onHover { self.isHovered = $0 }
        .onTapGesture(perform: onAction)
    }

    private var headerView: some View {
        VStack {
            Image(systemName: data.symbol)
                .imageScale(.large)
            Text(data.title)
        }
        .font(.headline)
    }

    private var detailView: some View {
        Text(data.detail)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
    }
}

public struct MessageBannerData {
    let title: String
    let symbol: String
    let detail: String
    let tint: Color

    public static let camera = MessageBannerData(
        title: "Camera Access Required",
        symbol: "camera.badge.ellipsis",
        detail: "Access to camera is required to capture live data. The data never leaves your iCloud account.",
        tint: .red
    )
}

#Preview {
    MessageBanner(.camera) {}
        .frame(width: 512)
//        .padding()
}
