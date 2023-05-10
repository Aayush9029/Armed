//
//  AppStorage+Extensions.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-21.
//

import Defaults
import SwiftUI

public extension Defaults.Keys {
    static let warnTheif = Key<Bool>("WARNTHEIF", default: false)
    static let siren = Key<Bool>("SIREN", default: false)
    static let flashes = Key<Bool>("FLASHES", default: false)
    static let captureImage = Key<Bool>("CAPTUREIMAGE", default: false)
    static let blurPreview = Key<Bool>("BLURPREVIEW", default: false)
    static let message = Key<String>("MESSAGE", default: "Siren will play")
    static let topFrequency = Key<CGFloat>("TOPFREQUENCY", default: 0.6)
    static let bottomFrequency = Key<CGFloat>("BOTTOMFREQUENCY", default: 0.2)
    static let showInDock = Key<Bool>("SHOWINDOCK", default: false)

    static let launchAtLogin = Key<Bool>("LAUNCHATLOGIN", default: false)
    static let chargeLimit = Key<Double>("CHARGELIMIT", default: 80)
}
