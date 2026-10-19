#if os(watchOS)

import SwiftUI

enum WatchTheme {
    // Yellow-Orange-Green palette — energetic, warm, nature-inspired
    static let primary   = Color(red: 1.00, green: 0.40, blue: 0.00)    // Vivid orange
    static let secondary = Color(red: 0.25, green: 0.75, blue: 0.35)    // Fresh green
    static let accent    = Color(red: 1.00, green: 0.82, blue: 0.00)    // Golden yellow
    static let mint      = Color(red: 0.60, green: 0.90, blue: 0.55)    // Lime green
    static let rose      = Color(red: 1.00, green: 0.45, blue: 0.10)    // Deep orange
    static let blush     = Color(red: 1.00, green: 0.96, blue: 0.80)    // Pale yellow cream
    static let paper     = Color(red: 1.00, green: 0.98, blue: 0.88)    // Warm paper

    // Sticky-note colors — yellow, amber, lime, peach tones
    static let stickyPink   = Color(red: 1.00, green: 0.95, blue: 0.65) // Bright yellow
    static let stickyPeach  = Color(red: 1.00, green: 0.85, blue: 0.55) // Amber
    static let stickyYellow = Color(red: 0.85, green: 0.98, blue: 0.65) // Lime yellow
    static let stickyCoral  = Color(red: 1.00, green: 0.78, blue: 0.55) // Peach orange
    static let stickySage   = Color(red: 0.75, green: 0.95, blue: 0.70) // Soft sage

    // Background gradient method
    static func backgroundGradient(for scheme: ColorScheme) -> LinearGradient {
        if scheme == .dark {
            return LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.10, blue: 0.06),
                    Color(red: 0.14, green: 0.12, blue: 0.05),
                    Color(red: 0.10, green: 0.15, blue: 0.07)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [
                    Color(red: 1.00, green: 0.98, blue: 0.88),
                    Color(red: 1.00, green: 0.96, blue: 0.80),
                    Color(red: 0.95, green: 0.98, blue: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    // Hero gradient — deep orange → vivid orange → golden yellow
    static let heroGradient = LinearGradient(
        colors: [
            Color(red: 0.85, green: 0.32, blue: 0.00),  // Burnt orange
            Color(red: 1.00, green: 0.55, blue: 0.05),  // Vivid orange
            Color(red: 1.00, green: 0.82, blue: 0.00)   // Golden yellow
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Surface Colors - watchOS compatible
    static let surface = Color(red: 0.11, green: 0.11, blue: 0.12)
    static let background = Color.black
    
    // Additional Colors
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    // Text colors
    static let textPrimary   = Color.primary
    static let textSecondary = Color.secondary
    static let textTertiary  = Color.gray
    
    // Page background
    static let pageBackground = Color.black
}

// Typealias so Watch code can use "Theme"
typealias Theme = WatchTheme

#endif


