//
//  ContentView.swift
//  Friendface
//
//  Created by Selva Ganesh on 21/11/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\User.name)]) private var users: [User]

    @State private var searchText = ""
    @State private var filterActiveOnly = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showErrorAlert = false
    @State private var path = [User]()

    var filteredUsers: [User] {
        users.filter { user in
            let matchesFilter = !filterActiveOnly || user.isActive
            let matchesSearch = searchText.isEmpty ||
                user.name.localizedCaseInsensitiveContains(searchText) ||
                user.company.localizedCaseInsensitiveContains(searchText) ||
                user.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            return matchesFilter && matchesSearch
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if users.isEmpty && isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.3)
                        Text("Fetching Friendface directory...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if users.isEmpty {
                    ContentUnavailableView {
                        Label("No Users Found", systemImage: "person.3.fill")
                    } description: {
                        Text("Connect to the internet and pull down to refresh, or tap below to fetch users.")
                    } actions: {
                        Button("Download Directory") {
                            Task {
                                await loadData()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if filteredUsers.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List {
                        Section {
                            ForEach(filteredUsers) { user in
                                NavigationLink(value: user) {
                                    UserRowView(user: user)
                                }
                            }
                        } header: {
                            HStack {
                                Text("\(filteredUsers.count) People")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                Spacer()
                                if filterActiveOnly {
                                    Text("Active Only")
                                        .font(.caption2.bold())
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Friendface")
            .navigationDestination(for: User.self) { user in
                UserDetailView(user: user)
            }
            .searchable(text: $searchText, prompt: "Search by name, company, or tag")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        filterActiveOnly.toggle()
                    } label: {
                        Label(
                            filterActiveOnly ? "Show All" : "Active Only",
                            systemImage: filterActiveOnly ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
                        )
                        .foregroundStyle(filterActiveOnly ? .green : .accentColor)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await loadData(force: true)
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isLoading)
                }
            }
            .refreshable {
                await loadData(force: true)
            }
            .task {
                // Fulfill challenge requirement:
                // "Before you start your download, check that your User array is empty so that you don’t keep starting the download every time the view is shown."
                if users.isEmpty {
                    await loadData()
                }
            }
            .onAppear {
                if ProcessInfo.processInfo.arguments.contains("-showDetail") {
                    if let first = users.first {
                        path.append(first)
                    }
                }
                if ProcessInfo.processInfo.arguments.contains("-filterActive") {
                    filterActiveOnly = true
                }
                if ProcessInfo.processInfo.arguments.contains("-searchSample") {
                    searchText = "Imkan"
                }
            }
            .alert("Download Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
                Button("Retry") {
                    Task {
                        await loadData(force: true)
                    }
                }
            } message: {
                Text(errorMessage ?? "An unknown error occurred while downloading user data.")
            }
        }
    }

    @MainActor
    private func loadData(force: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let userDTOs = try await DataService.fetchUsers()

            // If forced refresh, clear existing data
            if force {
                for user in users {
                    modelContext.delete(user)
                }
            }

            // Insert new users into SwiftData context
            for dto in userDTOs {
                let userModel = dto.toModel()
                modelContext.insert(userModel)
            }

            try? modelContext.save()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Friend.self], inMemory: true)
}
