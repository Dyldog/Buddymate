//
//  ContentView.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var database: Database
    
    var friends: [Friend] {
        database.friends.sorted(by: {
            $0.daysUntilNextMeeting < $1.daysUntilNextMeeting
        })
    }
    
    @State var selectedFriend: Friend? = nil
    
    @State var showAddFriend: Bool = false
    @State var showAddMeeting: Bool = false
    
    var body: some View {
        NavigationView {
            List{
                Section {
                    Button("Add Meeting") {
                        showAddMeeting = true
                    }
                    .buttonStyle(RaisedButtonStyle(depth: 1))
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                    .padding(.top)
                }
                
                Section {
                    if !friends.isEmpty {
                        ForEach(friends) { friend in
                            NavigationLink {
                                FriendDetailView(database: database, friend: friend)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(friend.name)
                                    
                                    Text(friend.status.text)
                                        .foregroundColor(friend.status.color)
                                        .font(.footnote)
                                }
                            }
                            .swipeActions {
                                Button {
                                    _ = database.logMeeting(for: friend)
                                } label: {
                                    Image(systemName: "person.2")
                                }
                                .tint(.blue)

                            }
                        }
                    } else {
                        Text("Add a friend to get started")
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Section {
                    Button("Add Friend") {
                        showAddFriend = true
                    }
                    .buttonStyle(RaisedButtonStyle(depth: 1))
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Buddymates")
        }
        .popover(isPresented: $showAddFriend, content: {
            AddFriendView { name, freq in
                database.addFriend(name, desiredFrequency: freq)
                showAddFriend = false
            }
        })
        .popover(isPresented: $showAddMeeting) {
            SearchView(title: "Who With?", items: friends) { selected, _ in
                _ = database.logMeeting(for: selected)
                showAddMeeting = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(database: .init())
    }
}

struct RaisedButtonStyle: ButtonStyle {

    let depth: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        let currentDepth = configuration.isPressed ? 0 : depth
        return configuration.label
            .offset(x: 0, y: -currentDepth/1.5)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Rectangle().fill(Color.secondary)
                    .frame(height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8).fill(Color.accentColor)
                    .offset(x: 0, y: -currentDepth)
                )
            )
    }
}
