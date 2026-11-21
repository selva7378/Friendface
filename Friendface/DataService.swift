//
//  DataService.swift
//  Friendface
//
//  Created by Selva Ganesh on 21/11/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(Error)
    case transportError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The endpoint URL is invalid."
        case .invalidResponse(let code):
            return "Server responded with status code: \(code)."
        case .decodingFailed(let error):
            return "Failed to parse user data: \(error.localizedDescription)"
        case .transportError(let error):
            return "Network connection error: \(error.localizedDescription)"
        }
    }
}

struct DataService {
    static let endpoint = "https://www.hackingwithswift.com/samples/friendface.json"

    static func fetchUsers() async throws -> [UserDTO] {
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 15

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.transportError(error)
        }

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([UserDTO].self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
