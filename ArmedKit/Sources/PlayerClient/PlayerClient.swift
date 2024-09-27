//
//  PlayerClient.swift
//  Armed
//
//  Created by yush on 9/26/24.
//

import Dependencies
import Foundation

public protocol PlayerClient {
    func playDemo()
    func play(after seconds: TimeInterval, again: Bool)
    func stop()
    func isPlaying() -> Bool
    func updateFrequencies()
}

public extension DependencyValues {
    var playerClient: PlayerClient {
        get { self[PlayerClientKey.self] }
        set { self[PlayerClientKey.self] = newValue }
    }
}

public struct PlayerClientKey: DependencyKey {
    public static let liveValue: PlayerClient = LivePlayerClient()
}
