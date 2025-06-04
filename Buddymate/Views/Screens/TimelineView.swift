//
//  TimelineView.swift
//  Buddymate
//
//  Created by Dylan Elliott on 4/10/21.
//

import SwiftUI

struct Person {
    let name: String
    let id: UUID
    
    init(id: UUID = .init(), name: String) {
        self.id = id
        self.name = name
    }
    
    init(friend: Friend) {
        self.name = friend.name
        self.id = friend.id
    }
}

/// Self-contained full description of a meeting, i.e: Also detailing the person it was with
struct MeetingInfo: Identifiable {
    var id: String { meeting.id.uuidString + person.id.uuidString }
    let meeting: Meeting
    let person: Person
}

struct TimelineView: View {
    let meetings: [MeetingInfo]
    
    var splitMeetings: [SectionModel] {
        meetings.splitByDate { $0.meeting.date }.sorted(by: { $0.key > $1.key }).map { SectionModel(header: $0.key.dayDisplayString, meetings: $0.value) }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(splitMeetings) { group in
                    Section(group.header) {
                        ForEach(group.meetings) { meeting in
                            Text(meeting.person.name)
                        }
                    }
                }
            }
            .navigationBarTitle("Past Meetings")
        }
    }
    
    struct SectionModel: Identifiable {
        var id: String { header }
        let header: String
        let meetings: [MeetingInfo]
    }
}



extension DateComponents {
    private static var dayDisplayFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter
    }()
    var dayDisplayString: String {
        guard let date = Calendar.current.date(from: self) else { return "ERROR, DATE WAS NIL" }
        return DateComponents.dayDisplayFormatter.string(from: date)
    }
}

extension Array {
    func splitByDate(_ retriever: (Element) -> Date) -> [DateComponents: [Element]] {
        return Dictionary(grouping: self) { (pendingCamera) -> DateComponents in
            let date = Calendar.current.dateComponents([.day, .year, .month], from: retriever(pendingCamera))
            return date
        }
        
    }
}

extension DateComponents: Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        guard let lhs = Calendar.current.date(from: lhs), let rhs = Calendar.current.date(from: rhs) else { return false }
        return lhs < rhs
    }
    
    
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(meetings: [
            .init(meeting: Meeting(date: .now), person: Person(name: "Michael Nowara"))
        ])
    }
}
