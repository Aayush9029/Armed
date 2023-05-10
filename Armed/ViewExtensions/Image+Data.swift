//
//  Image+Data.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-17.
//

import AppKit

extension NSImage {
    var data: Data? {
        if let tiffRepresentation = tiffRepresentation,
           let bitmapImageRep = NSBitmapImageRep(data: tiffRepresentation) {
            return bitmapImageRep.representation(using: .jpeg, properties: [:])
        }
        return nil
    }
}
