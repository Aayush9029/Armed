//
//  Defaults+.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

import Defaults
import SwiftUI

public extension Defaults.Keys {
    static let siren = Key<Bool>("SIREN", default: false)
    static let maxVolume = Key<Bool>("MAXVOLUME", default: false)
    static let captureImage = Key<Bool>("CAPTUREIMAGE", default: false)
    static let sirenTimer = Key<CGFloat>("SIRENTIMER", default: 0.333) // 0.333 * 30 = 10 sec

    static let message = Key<String>("MESSAGE", default: "Siren will play")

    static let topFrequency = Key<CGFloat>("TOPFREQUENCY", default: 0.6)
    static let bottomFrequency = Key<CGFloat>("BOTTOMFREQUENCY", default: 0.2)

    static let showInDock = Key<Bool>("SHOWINDOCK", default: true)
    static let appOpenCount = Key<Int>("APPOPENCOUNT", default: 0)

    static let launchAtLogin = Key<Bool>("LAUNCHATLOGIN", default: false)
}
