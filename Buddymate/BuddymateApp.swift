//
//  BuddymateApp.swift
//  Buddymate
//
//  Created by Dylan Elliott on 30/9/21.
//

import SwiftUI

@main
struct BuddymateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(database: Database())
        }
    }
}
