import Foundation

enum CoachError: Error, LocalizedError {
    case notConfigured
    case networkError
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "AI Coach is not configured. Using demo mode."
        case .networkError:
            return "Network connection failed. Please check your internet connection."
        case .invalidResponse:
            return "Received invalid response from server."
        }
    }
}

actor CoachService {
    static let shared = CoachService()

    func sendMessages(_ messages: [[String: String]]) async throws -> String {
        throw CoachError.notConfigured
    }
}
