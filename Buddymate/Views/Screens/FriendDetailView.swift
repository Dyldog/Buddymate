//
//  FriendDetailView.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import SwiftUI
import HighlightedTextEditor

struct FriendDetailView: View {
    enum ListType: CaseIterable {
        case notes
        case meetings
        
        var title: String {
            switch self {
            case .notes: return "Notes"
            case .meetings: return "Meetings"
            }
        }
    }
    
    @ObservedObject var database: Database
    @State var friend: Friend
    
    @State var showingDatePicker: Bool = false
    @State var showingEditView: Bool = false
    
    @State var selectedList: ListType = .notes
    @State var notes: String = ""
    
    init(database: Database, friend: Friend) {
        _database = .init(initialValue: database)
        _friend = .init(initialValue: friend)
        _notes = .init(initialValue: friend.notes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let lastMeeting = friend.lastMeeting {
                VStack {
                    Text("Last Meeting")
                        .fontWeight(.bold)
                        .font(.footnote)
                    
                    let timeSince = lastMeeting.daysSince == 0 ? "Today" : "\(lastMeeting.daysSince) days ago"
                    Text(timeSince)
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    NumberView(
                        number: friend.meetingFrequency.compactString,
                        label: "average meeting frequency"
                    )
                        .frame(maxWidth: .infinity)
                    
                    NumberView(
                        number: "\(friend.desiredFrequency)",
                        label: "desired meeting frequency"
                    )
                    .frame(maxWidth: .infinity)
                }
                
                VStack {
                    Picker("", selection: $selectedList) {
                        ForEach(ListType.allCases, id: \.self) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    list(for: selectedList)
                }
            } else {
                VStack {
                    Text("No meetings yet")
                    
                    NumberView(
                        number: "\(friend.desiredFrequency)",
                        label: "desired meeting frequency"
                    )
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
            }
            
            HStack {
                Button {
                    friend = database.logMeeting(for: friend)
                } label: {
                    Text("Met Today")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                
                Button {
                    showingDatePicker = true
                } label: {
                    Text("Add Past Meeting")
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .navigationTitle(friend.name)
        .toolbar(content: {
            Button {
                showingEditView = true
            } label: {
                Text("Edit")
            }
        })
        .popover(isPresented: $showingDatePicker) {
            DatePickerPopover(date: .now, onSelection: { date in
                showingDatePicker = false
                friend = database.logMeeting(for: friend, for: date)
            })
        }
        .popover(isPresented: $showingEditView) {
            AddFriendView((name: friend.name, desiredFrequency: friend.desiredFrequency)) { name, freq in
                friend = database.updateFriend(friend, name: name, desiredFrequency: freq)
                showingEditView = false
            }
        }
        
    }
    
    @ViewBuilder
    func list(for style: ListType) -> some View {
        switch style {
        case .notes:
            HighlightedTextEditor(
                text: $notes,
                highlightRules: HighlightRule.markDylan,
                onLinkClick: { url, text, range in
                    if url.scheme != nil {
                        return true
                    } else {
                        didSelectLink(url: url, text: text, at: range)
                        return false
                    }
                }
            )
            .onChange(of: notes) { newValue in
                database.updateNotes(for: friend, to: notes)
            }
        case .meetings:
            List {
                Section("All Meetings") {
                    ForEach(friend.meetings.sorted(by: { $0.date > $1.date })) { meeting in
                        Text(meeting.date.description)
                            .swipeActions {
                                Button {
                                    friend = database.deleteMeeting(withID: meeting.id, for: friend)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)

                            }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    func didSelectLink(url: URL, text: String, at range: NSRange) {
            func replace(_ a: String, with b: String) {
                notes = (notes as NSString).replacingCharacters(
                    in: range,
                    with: text.replacingOccurrences(of: a, with: b)
                )
            }
            switch HighlightRule.MarkdownToken(rawValue: url.absoluteString) {
            case .uncheckedTodo:
                replace(HighlightRule.MarkdownSymbol.Todo.unchecked.rawValue, with: HighlightRule.MarkdownSymbol.Todo.checked.rawValue)
            case .checkedTodo:
                replace(HighlightRule.MarkdownSymbol.Todo.checked.rawValue, with: HighlightRule.MarkdownSymbol.Todo.unchecked.rawValue)
            case .none:
                break
            }
        }
}


struct FriendDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let database = Database()
        FriendDetailView(database: database, friend: database.friends.first!)
    }
}
