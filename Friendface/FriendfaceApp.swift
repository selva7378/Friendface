//
//  FriendfaceApp.swift
//  Friendface
//
//  Created by Selva Ganesh on 21/11/26.
//

import SwiftUI
import SwiftData

@main
struct FriendfaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Friend.self])
    }
}
