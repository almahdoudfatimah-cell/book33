import SwiftUI

/// A namespace for the app's theme related definitions.
enum Theme {
    
    /// The shared instance of the app's theme.
    static let shared = ThemeInstance()
    
    /// Represents the app's color palette.
    struct Colors {
        /// The primary color used throughout the app.
        let primary = Color.blue
        /// The secondary color used for accents.
        let secondary = Color.green
        /// The background color of views.
        let background = Color.white
        /// The color used for text labels.
        let text = Color.black
    }
    
    /// Represents the app's font styles.
    struct Fonts {
        /// The default font for body text.
        let body = Font.body
        /// The font used for titles.
        let title = Font.title
        /// The font used for captions.
        let caption = Font.caption
    }
    
    /// The theme instance containing colors and fonts.
    struct ThemeInstance {
        /// The app colors
        let colors = Colors()
        /// The app fonts
        let fonts = Fonts()
    }
}
