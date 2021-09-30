//
//  Database.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import SwiftUI

class Database: NSObject, ObservableObject {
    @Published private(set) var friends: [Friend] = []
    
    override init() {
        super.init()
        restorePersistedData()
    }
    
    private func index(for friend: Friend) -> Int? {
        return friends.firstIndex(where: {$0.id == friend.id })
    }
    
    func logMeeting(for friend: Friend, for date: Date = .now) -> Friend {
        guard let idx = index(for: friend) else { return friend }
        var friend = friends[idx]
        friend.meetings.append(.init(date: date))
        friends[idx] = friend
        
        persistData()
        
        return friend
    }
    
    func addFriend(_ name: String, desiredFrequency: Int) {
        friends.append(.init(name: name, desiredFrequency: desiredFrequency))
        persistData()
    }
    
    func updateFriend(_ friend: Friend, name: String, desiredFrequency: Int) -> Friend {
        guard let idx = index(for: friend) else { return friend }
        let friend = Friend(id: friend.id, name: name, desiredFrequency: desiredFrequency, meetings: friend.meetings)        
        friends[idx] = friend
        
        persistData()
        
        return friend
    }
    
    func updateNotes(for friend: Friend, to newNotes: String) {
        guard let idx = index(for: friend) else { return }
        var friend = friends[idx]
        friend.notes = newNotes
        friends[idx] = friend
        persistData()
    }
    
    func deleteMeeting(withID id: UUID, for friend: Friend) -> Friend {
        guard let idx = index(for: friend) else { return friend }
        var friend = friends[idx]
        friend.meetings.removeAll(where: { $0.id == id })
        friends[idx] = friend
        
        persistData()
        
        return friend
    }
    
    // MARK: - Data Persistence
    
    let encoder = JSONEncoder()
    
    private func persistData() {
        do {
            let friendsData = try encoder.encode(friends)
            UserDefaults.standard.set(friendsData, forKey: UserDefaultsKeys.friends.rawValue)
            
            UserDefaults.standard.synchronize()
        } catch {
            print(error)
        }
    }
    
    let decoder = JSONDecoder()
    
    private func restorePersistedData() {
        do {
            if let friendsData = UserDefaults.standard.data(forKey: UserDefaultsKeys.friends.rawValue) {
                friends = try decoder.decode([Friend].self, from: friendsData)
            }
        } catch {
            print(error)
        }
    }
}

extension Database {
    enum UserDefaultsKeys: String {
        case friends
    }
}
