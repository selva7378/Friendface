//
//  User.swift
//  Friendface
//
//  Created by Selva Ganesh on 21/11/26.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable, Hashable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    @Relationship(deleteRule: .cascade, inverse: \Friend.user) var friends: [Friend]

    init(
        id: UUID,
        isActive: Bool,
        name: String,
        age: Int,
        company: String,
        email: String,
        address: String,
        about: String,
        registered: Date,
        tags: [String],
        friends: [Friend] = []
    ) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.address = address
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }

    var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            let first = parts[0].prefix(1)
            let last = parts[1].prefix(1)
            return "\(first)\(last)".uppercased()
        }
        return name.prefix(2).uppercased()
    }

    var formattedRegisteredDate: String {
        registered.formatted(date: .abbreviated, time: .omitted)
    }
}

#if DEBUG
extension User {
    static let example = User(
        id: UUID(uuidString: "50a48fa3-2c0f-4397-ac50-64da464f9954")!,
        isActive: true,
        name: "Alford Rodriguez",
        age: 21,
        company: "Imkan",
        email: "alfordrodriguez@imkan.com",
        address: "907 Nelson Street, Cotopaxi, South Dakota, 5913",
        about: "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore.",
        registered: .now,
        tags: ["cillum", "consequat", "deserunt", "nostrud", "eiusmod"],
        friends: [
            Friend(id: UUID(uuidString: "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0")!, name: "Hawkins Patel"),
            Friend(id: UUID(uuidString: "0c395a95-57e2-4d53-b4f6-9b9e46a32cf6")!, name: "Jewel Sexton")
        ]
    )
}
#endif
