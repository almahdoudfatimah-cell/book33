//
//  ThemeFix.swift
//  RaceTrian
//
//  Created by Fatimah on 15/10/2026.
//

import Foundation
import SwiftUI

// MARK: - Theme
public enum Theme {
    public static let primary = Color(red: 1.00, green: 0.40, blue: 0.00)
    public static let secondary = Color(red: 0.25, green: 0.75, blue: 0.35)
    public static let accent = Color(red: 1.00, green: 0.82, blue: 0.00)
    public static let mint = Color(red: 0.60, green: 0.90, blue: 0.55)
    public static let rose = Color(red: 1.00, green: 0.45, blue: 0.10)
    public static let blush = Color(red: 1.00, green: 0.96, blue: 0.80)
    public static let paper = Color(red: 1.00, green: 0.98, blue: 0.88)
    public static let stickyPink = Color(red: 1.00, green: 0.95, blue: 0.65)
    public static let stickyPeach = Color(red: 1.00, green: 0.85, blue: 0.55)
    public static let stickyYellow = Color(red: 0.85, green: 0.98, blue: 0.65)
    public static let stickyCoral = Color(red: 1.00, green: 0.78, blue: 0.55)
    public static let stickySage = Color(red: 0.75, green: 0.95, blue: 0.70)
    public static let surface = Color(red: 0.96, green: 0.95, blue: 0.92)
    public static let surfaceDark = Color(red: 0.16, green: 0.15, blue: 0.13)
    public static let pageBackground = Color(red: 0.99, green: 0.98, blue: 0.95)
    public static let pageBackgroundDark = Color(red: 0.10, green: 0.10, blue: 0.06)
    public static let textPrimary = Color.primary
    public static let textSecondary = Color.secondary
    public static let textTertiary = Color.secondary.opacity(0.6)
    
    public static func backgroundGradient(for scheme: ColorScheme) -> LinearGradient {
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
    
    public static let heroGradient = LinearGradient(
        colors: [
            Color(red: 0.85, green: 0.32, blue: 0.00),
            Color(red: 1.00, green: 0.55, blue: 0.05),
            Color(red: 1.00, green: 0.82, blue: 0.00)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - PaperBackground
public struct PaperBackground: View {
    @Environment(\.colorScheme) private var scheme
    public init() {}
    public var body: some View {
        ZStack {
            (scheme == .dark ? Theme.pageBackgroundDark : Theme.pageBackground)
                .ignoresSafeArea()
        }
        .allowsHitTesting(false)
    }
}

// MARK: - TrackingData
public struct TrackingData: Identifiable {
    public let id = UUID()
    public var title: String
    public var value: String
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    public static let sample: [TrackingData] = [
        .init(title: "Sample Metric", value: "42"),
        .init(title: "Another Metric", value: "3.14")
    ]
}

// MARK: - View Modifiers
public struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat
    var tint: Color
    @Environment(\.colorScheme) private var scheme
    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(scheme == .dark ? Theme.surfaceDark : Theme.surface)
            )
            .shadow(color: Color.black.opacity(0.10), radius: 22, x: 0, y: 12)
    }
}

public extension View {
    func glassCard(cornerRadius: CGFloat = 24, tint: Color = Theme.primary) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, tint: tint))
    }
    func appPageTheme() -> some View {
        self.tint(Theme.primary)
    }
}
