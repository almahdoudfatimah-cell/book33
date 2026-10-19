import SwiftUI

struct Theme {
    // MARK: - Primary Color
    static let primary = Color(red: 1.00, green: 0.82, blue: 0.00)
    static let accent = Color(red: 1.00, green: 0.55, blue: 0.05)
    static let rose = Color(red: 1.00, green: 0.40, blue: 0.50)
    
    // MARK: - Gradients
    static let heroGradient = LinearGradient(
        colors: [
            Color(red: 0.85, green: 0.32, blue: 0.00),
            Color(red: 1.00, green: 0.55, blue: 0.05),
            Color(red: 1.00, green: 0.82, blue: 0.00)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static func backgroundGradient(for colorScheme: ColorScheme) -> LinearGradient {
        if colorScheme == .dark {
            return LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.12),
                    Color(red: 0.15, green: 0.15, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color(red: 0.97, green: 0.97, blue: 0.97),
                    Color(red: 0.95, green: 0.95, blue: 0.96)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

