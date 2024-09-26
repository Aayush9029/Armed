//
//  FrequencyFormatter.swift
//  ArmedKit
//
//  Created by yush on 9/26/24.
//

import Foundation

public enum FrequencyFormatter {
    public static func format(frequency: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2

        if frequency < 1_000 {
            return "\(numberFormatter.string(from: NSNumber(value: frequency))!) Hz"
        } else if frequency >= 1_000 && frequency < 1_000_000 {
            let kilohertzValue = frequency / 1_000
            return "\(numberFormatter.string(from: NSNumber(value: kilohertzValue))!) kHz"
        } else if frequency >= 1_000_000 && frequency < 1_000_000_000 {
            let megahertzValue = frequency / 1_000_000
            return "\(numberFormatter.string(from: NSNumber(value: megahertzValue))!) MHz"
        } else {
            let gigahertzValue = frequency / 1_000_000_000
            return "\(numberFormatter.string(from: NSNumber(value: gigahertzValue))!) GHz"
        }
    }

    public static func valueToFrequency(_ value: CGFloat) -> Float {
        return Float(value * 2_000) + 1_000
    }
}
