//
//  Friend.swift
//  Friendface
//
//  Created by Selva Ganesh on 21/11/26.
//

import Foundation
import SwiftData

@Model
final class Friend: Identifiable, Hashable {
    var id: UUID
    var name: String
    var user: User?

    init(id: UUID, name: String, user: User? = nil) {
        self.id = id
        self.name = name
        self.user = user
    }
}
