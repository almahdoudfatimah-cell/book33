import Foundation

// MARK: - Chat Message

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
    
    init(id: UUID = UUID(), role: MessageRole, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
    
    enum MessageRole {
        case user
        case assistant
    }
}

// MARK: - Coach Service

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
    
    private let apiKey: String?
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    private init() {
        // Try to load API key from environment or configuration
        // For now, it's nil which will trigger demo mode
        self.apiKey = nil
    }
    
    func sendMessages(_ messages: [[String: String]]) async throws -> String {
        // Check if API key is configured
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            throw CoachError.notConfigured
        }
        
        // Prepare the request
        guard let url = URL(string: endpoint) else {
            throw CoachError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": messages,
            "max_tokens": 500,
            "temperature": 0.7
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // Make the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CoachError.networkError
        }
        
        // Parse the response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw CoachError.invalidResponse
        }
        
        return content
    }
}
