//
//  Image+.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

import AppKit
import SwiftUI

public func ciImageToImage(_ ciImage: CIImage) -> Image? {
    let context = CIContext()
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
    return Image(decorative: cgImage, scale: 1.0, orientation: .up)
}

public extension NSImage {
    var data: Data? {
        if let tiffRepresentation = tiffRepresentation,
           let bitmapImageRep = NSBitmapImageRep(data: tiffRepresentation)
        {
            return bitmapImageRep.representation(using: .jpeg, properties: [:])
        }
        return nil
    }
}
