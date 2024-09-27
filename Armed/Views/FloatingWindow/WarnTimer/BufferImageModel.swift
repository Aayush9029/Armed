//
//  BufferImageModel.swift
//  Armed
//
//  Created by yush on 9/26/24.
//

import SwiftUI

struct BufferImageModel: Identifiable {
    var id: Double { dateTime }
    let dateTime: Double = Date().timeIntervalSince1970
    let image: CIImage
}
