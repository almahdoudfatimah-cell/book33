import SwiftUI

/// Global theme configuration
struct Theme {
    /// Primary accent color - dynamically updates based on selected app theme
    static var primary: Color {
        ProfileStore.shared.appTheme.primary
    }
    
    /// Secondary accent color - dynamically updates based on selected app theme
    static var secondary: Color {
        ProfileStore.shared.appTheme.secondary
    }
    
    /// Accent color for highlights and important UI elements
    static let accent = Color(red: 0.40, green: 0.82, blue: 0.25)
    
    /// Mint color for specific use cases
    static let mint = Color(red: 0.62, green: 0.95, blue: 0.85)
    
    /// Glass background with blur effect
    static let glass = Color.white.opacity(0.12)
    
    /// Gradient for theme-aware backgrounds
    static var gradient: LinearGradient {
        ProfileStore.shared.appTheme.gradient
    }
}
