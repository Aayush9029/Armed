//
//  ImageBufferRow.swift
//  Armed
//
//  Created by yush on 9/26/24.
//


//
//  ImageBufferRow.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-13.
//

import SwiftUI

struct ImageBufferRow: View {
    let imageBuffer: [BufferImageModel]

    init(_ imageBuffer: [BufferImageModel]) {
        self.imageBuffer = imageBuffer
    }

    var body: some View {
        HStack {
            ForEach(imageBuffer) { buffer in
                buffer.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                    .cornerRadius(12)
                    .foregroundStyle(.tertiary)
                    .padding(2)
            }
        }
        .padding(.horizontal, 2)
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
    }
}
