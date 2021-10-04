//
//  Friend.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import Foundation
import SwiftUI

enum NextMeetingStatus {
    case noPreviousMeetings
    case metToday
    case dueIn(Int)
    case overdueBy(Int)
    
    var color: Color {
        switch self {
        case .dueIn(1): return .yellow
        case .noPreviousMeetings, .dueIn: return  .gray
        case .overdueBy: return .red
        case .metToday: return .green
        }
    }
    
    var text: String {
        switch self {
            
        case .noPreviousMeetings: return "No meetings yet"
        case .metToday: return "Met today"
        case .dueIn(1): return "Due in 1 day"
        case .dueIn(let days): return "Due in \(days) days"
        case .overdueBy(1): return "Overdue by 1 day"
        case .overdueBy(let days): return "Overdue by \(days) days"
        }
    }
}

struct Friend: Codable, Identifiable {
    let id: UUID
    let name: String
    var meetings: [Meeting]
    var notes: String
    
    /// In days
    let desiredFrequency: Int
    
    /// In days
    var meetingFrequency: Float { meetings.map { Float($0.daysSince) }.mean }
    
    init(id: UUID = .init(), name: String, desiredFrequency: Int, meetings: [Meeting] = [], notes: String = "") {
        self.id = id
        self.name = name
        self.meetings = meetings
        self.desiredFrequency = desiredFrequency
        self.notes = notes
    }
}

extension Friend {
    var lastMeeting: Meeting? { meetings.sorted(by: { $0.date < $1.date}).last }
    var daysSinceLastMeeting: Int? { lastMeeting?.daysSince }
    var daysUntilNextMeeting: Int {
        guard let lastMeeting = meetings.last else { return 0 }
        return desiredFrequency - lastMeeting.daysSince
    }
    
    var status: NextMeetingStatus {
        guard !meetings.isEmpty else { return .noPreviousMeetings }
        switch daysUntilNextMeeting {
        case ..<0: return .overdueBy(abs(daysUntilNextMeeting))
        case 0: return .metToday
        case 1...: return .dueIn(daysUntilNextMeeting)
        default: fatalError()
        }
    }
}

extension Friend: SearchItem {
    var title: String { name }
}

extension Friend {
    static var mocks: [Friend] { return [
        .init(name: "Bryant Best", desiredFrequency: 1, meetings: [.init(date: .now)]),
        .init(name: "Michael Barr", desiredFrequency: 2),
        .init(name: "Michael Nowara", desiredFrequency: 3, meetings: [.init(date: .init(timeIntervalSinceNow: TimeInterval(-20 * TimeInterval.oneDay)))])
    ] }
}

extension Array where Element == Float {
    var mean: Float {
        self.reduce(0, +) / Float(self.count)
    }
}
