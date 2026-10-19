import SwiftUI

/// A minimal theme type to unblock compilation.
/// Replace with your real theme implementation when available.
public struct Theme {
    public var background: Color = Color(.systemBackground)
    public var primary: Color = .accentColor
    public var secondary: Color = .secondary
    public var textPrimary: Color = .primary
    public var textSecondary: Color = .secondary

    public static let `default` = Theme()

    public init(background: Color = Color(.systemBackground),
                primary: Color = .accentColor,
                secondary: Color = .secondary,
                textPrimary: Color = .primary,
                textSecondary: Color = .secondary) {
        self.background = background
        self.primary = primary
        self.secondary = secondary
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
    }
}
