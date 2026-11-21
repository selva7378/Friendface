//
//  UserDetailView.swift
//  Friendface
//
//  Created by Selva Ganesh on 21/11/26.
//

import SwiftUI
import SwiftData

struct UserDetailView: View {
    let user: User
    @Query private var allUsers: [User]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Profile Card
                VStack(spacing: 12) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: user.isActive ? [.blue, .indigo] : [.gray.opacity(0.7), .secondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay {
                            Text(user.initials)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                        .shadow(color: (user.isActive ? Color.blue : Color.gray).opacity(0.3), radius: 8, x: 0, y: 4)

                    Text(user.name)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    HStack(spacing: 8) {
                        // Online badge
                        HStack(spacing: 5) {
                            Circle()
                                .fill(user.isActive ? Color.green : Color.gray)
                                .frame(width: 8, height: 8)
                            Text(user.isActive ? "Active Now" : "Offline")
                                .font(.caption.bold())
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            (user.isActive ? Color.green : Color.gray).opacity(0.12)
                        )
                        .clipShape(Capsule())

                        // Registered date badge
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption2)
                            Text("Joined \(user.formattedRegisteredDate)")
                                .font(.caption)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                )

                // Info Section
                VStack(alignment: .leading, spacing: 14) {
                    Text("Information")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    VStack(spacing: 12) {
                        InfoRow(icon: "briefcase.fill", label: "Company", value: user.company, iconColor: .blue)
                        Divider()
                        InfoRow(icon: "number", label: "Age", value: "\(user.age) years old", iconColor: .orange)
                        Divider()
                        InfoRow(icon: "envelope.fill", label: "Email", value: user.email, iconColor: .red, isLink: true)
                        Divider()
                        InfoRow(icon: "mappin.circle.fill", label: "Address", value: user.address, iconColor: .green)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(UIColor.secondarySystemGroupedBackground))
                    )
                }

                // About Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    Text(user.about)
                        .font(.body)
                        .lineSpacing(4)
                        .foregroundStyle(.primary)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(UIColor.secondarySystemGroupedBackground))
                        )
                }

                // Tags Section
                if !user.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tags")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(user.tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(.caption.bold())
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.blue.opacity(0.12))
                                        .foregroundStyle(.blue)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                }

                // Friends Section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Friends")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)

                        Spacer()

                        Text("^[\(user.friends.count) friend](inflect: true)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 8) {
                        ForEach(user.friends) { friend in
                            if let friendUser = allUsers.first(where: { $0.id == friend.id }) {
                                NavigationLink(value: friendUser) {
                                    FriendRow(friend: friend, isRegisteredUser: true)
                                }
                            } else {
                                FriendRow(friend: friend, isRegisteredUser: false)
                            }
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(UIColor.secondarySystemGroupedBackground))
                    )
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    let iconColor: Color
    var isLink: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if isLink, let url = URL(string: "mailto:\(value)") {
                    Link(value, destination: url)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                } else {
                    Text(value)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            }

            Spacer()
        }
    }
}

private struct FriendRow: View {
    let friend: Friend
    let isRegisteredUser: Bool

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.indigo.opacity(0.15))
                .frame(width: 36, height: 36)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundStyle(.indigo)
                }

            Text(friend.name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)

            Spacer()

            if isRegisteredUser {
                Image(systemName: "chevron.right")
                    .font(.caption2.bold())
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, Friend.self, configurations: config)
        let user = User.example
        let friend = User.offlineExample

        container.mainContext.insert(user)
        container.mainContext.insert(friend)

        return NavigationStack {
            UserDetailView(user: user)
        }
        .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
