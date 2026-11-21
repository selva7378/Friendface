//
//  UserRowView.swift
//  Friendface
//
//  Created by Selva Ganesh on 21/11/26.
//

import SwiftUI

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack(spacing: 14) {
            // Avatar with initials and active indicator
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: user.isActive ? [.blue, .indigo] : [.gray.opacity(0.6), .secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .overlay {
                        Text(user.initials)
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                    }

                Circle()
                    .fill(user.isActive ? Color.green : Color(UIColor.systemGray3))
                    .frame(width: 13, height: 13)
                    .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 2))
                    .offset(x: 2, y: 2)
            }

            // User Info
            VStack(alignment: .leading, spacing: 3) {
                Text(user.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                HStack(spacing: 6) {
                    Text(user.company)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                    Text("\(user.age) yrs")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Status capsule badge
            if user.isActive {
                Text("Active")
                    .font(.caption2.bold())
                    .foregroundStyle(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.12))
                    .clipShape(Capsule())
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.caption2)
                    Text("\(user.friends.count)")
                        .font(.caption2.bold())
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(UIColor.secondarySystemFill))
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        UserRowView(user: .example)
        UserRowView(user: .offlineExample)
    }
}
