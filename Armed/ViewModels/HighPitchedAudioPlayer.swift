//
//  HighPitchedAudioPlayer.swift
//  Armed
//
//  Created by Aayush Pokharel on 2023-04-18.
//

import AVFoundation
import SwiftUI

import Defaults

class HighPitchedAudioPlayer: ObservableObject {
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var buffer: AVAudioPCMBuffer!
    private let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
    private var timer: Timer?

    private var frequencies: [Float] = []
    private var frequencyIndex = 0

    @Default(.topFrequency) var topFrequency
    @Default(.bottomFrequency) var bottomFrequency
    @Default(.maxVolume) var maxVolume

    var customPlaying: Bool = false

    init() {
        updateFrequencies()
    }

    func updateFrequencies() {
        frequencies = [
            HighPitchedAudioPlayer.valueToFrequency(topFrequency),
            HighPitchedAudioPlayer.valueToFrequency(bottomFrequency)
        ]
    }

    static func valueToFrequency(_ value: CGFloat) -> Float {
        return Float(value * 2000) + 1000
    }

    func createBuffer(forFrequency frequency: Float) -> AVAudioPCMBuffer {
        let buffer = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: AVAudioFrameCount(format!.sampleRate))
        buffer?.frameLength = buffer!.frameCapacity

        let sampleRate = Float(format!.sampleRate)
        let amplitude: Float = 1
        for i in 0 ..< Int(buffer!.frameLength) {
            let sample = sinf(2 * .pi * frequency * Float(i) / sampleRate)
            buffer?.floatChannelData![0][i] = amplitude * sample
        }

        return buffer!
    }

    func isPlaying() -> Bool {
        return playerNode.isPlaying || engine.isRunning
    }

    func playDemo() {
        frequencyIndex = 0
        customPlaying = true
        play(after: 0.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.customPlaying = false
            self.stop()
        }
    }

    func play(after seconds: TimeInterval, again: Bool = true) {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        do { try engine.start() } catch {
            print("Error starting engine: \(error)")
            return
        }

        if again {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.playNextFrequency()
                self.startTimer()
            }
        }
    }

    func playNextFrequency() {
        if !isPlaying() { return }

        if !customPlaying && maxVolume {
            NSSound.systemVolume = 1.0
        }

        buffer = createBuffer(forFrequency: frequencies[frequencyIndex])
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        playerNode.play()
        frequencyIndex = (frequencyIndex + 1) % frequencies.count
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.playerNode.stop()
            self?.playNextFrequency()
        }
    }

    func stop() {
        if customPlaying { return }
        timer?.invalidate()
        playerNode.stop()
        engine.stop()
    }
}
