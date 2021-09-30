//
//  Meeting.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import Foundation

struct Meeting: Codable, Identifiable {
    let id: UUID
    let date: Date
    
    init(id: UUID = .init(), date: Date) {
        self.id = id
        self.date = date
    }
}

extension Meeting {
    var daysSince: Int { -date.timeIntervalSinceNow.days }
}

extension TimeInterval {
    static let oneMinute: Int = 60
    static let oneHour: Int = TimeInterval.oneMinute * 60
    static let oneDay: Int = TimeInterval.oneHour * 24
    
    var days: Int {
        Int(self) / TimeInterval.oneDay
    }
}
