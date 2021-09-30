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
    
    var body: some View {
        NavigationView {
            List{
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
                
                HStack {
                    Button {
                        showAddFriend = true
                    } label: {
                        Text("Add Friend")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity)

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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(database: .init())
    }
}
