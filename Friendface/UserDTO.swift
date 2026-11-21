//
//  UserDTO.swift
//  Friendface
//
//  Created by Selva Ganesh on 21/11/26.
//

import Foundation

struct FriendDTO: Codable, Identifiable {
    let id: UUID
    let name: String
}

struct UserDTO: Codable, Identifiable {
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [FriendDTO]

    func toModel() -> User {
        let modelFriends = friends.map { Friend(id: $0.id, name: $0.name) }
        return User(
            id: id,
            isActive: isActive,
            name: name,
            age: age,
            company: company,
            email: email,
            address: address,
            about: about,
            registered: registered,
            tags: tags,
            friends: modelFriends
        )
    }
}
