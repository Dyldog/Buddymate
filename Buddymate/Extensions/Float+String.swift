//
//  Float+String.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import Foundation

extension Float {
    var compactString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1

        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }
}
