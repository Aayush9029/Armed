//
//  FrequencyFormatter.swift
//  Armed macOS
//
//  Created by Aayush Pokharel on 2023-05-09.
//

import Foundation

enum FrequencyFormatter {
    static func format(frequency: Double) -> String {
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
}
