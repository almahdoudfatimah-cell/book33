import SwiftUI

enum Theme {
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
    
    // Surface and background colors - cross-platform
    static let surface = Color(red: 0.96, green: 0.95, blue: 0.92)
    static let surfaceDark = Color(red: 0.16, green: 0.15, blue: 0.13)
    static let pageBackground = Color(red: 0.99, green: 0.98, blue: 0.95)
    static let pageBackgroundDark = Color(red: 0.10, green: 0.10, blue: 0.06)
    static let textPrimary   = Color.primary
    static let textSecondary = Color.secondary
    static let textTertiary  = Color.secondary.opacity(0.6)
}

struct PaperBackground: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        ZStack {
            (scheme == .dark ? Theme.pageBackgroundDark : Theme.pageBackground)
                .ignoresSafeArea()
            if scheme == .light {
                GridPaperOverlay().opacity(0.08).ignoresSafeArea()
            }
        }
        .allowsHitTesting(false)
    }
}

// Faint grid lines like a notebook page
struct GridPaperOverlay: View {
    var body: some View {
        Canvas { ctx, size in
            let step: CGFloat = 22
            let color = Color(red: 0.55, green: 0.72, blue: 0.20).opacity(0.20)
            var x: CGFloat = 0
            while x <= size.width {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                ctx.stroke(path, with: .color(color), lineWidth: 0.5)
                x += step
            }
            var y: CGFloat = 0
            while y <= size.height {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                ctx.stroke(path, with: .color(color), lineWidth: 0.5)
                y += step
            }
        }
    }
}

// Decorative helpers — used by sticker tags, washi tape
struct WashiTape: View {
    var color: Color = Theme.secondary
    var angle: Double = -3
    var body: some View {
        Rectangle()
            .fill(color.opacity(0.85))
            .frame(width: 120, height: 22)
            .rotationEffect(.degrees(angle))
    }
}

struct StickerTag: View {
    let text: String
    var color: Color = Theme.primary
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 24
    var tint: Color = .white
    @Environment(\.colorScheme) private var scheme
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(scheme == .dark ? Theme.surfaceDark : Theme.surface)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [tint.opacity(0.04), tint.opacity(0.01)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.55),
                                    Color.white.opacity(0.10),
                                    Color.white.opacity(0.0),
                                    Color.white.opacity(0.18)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                        .blendMode(.plusLighter)
                }
                .allowsHitTesting(false)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.20), lineWidth: 0.5)
                    .allowsHitTesting(false)
            )
            .shadow(color: Color.black.opacity(0.10), radius: 22, x: 0, y: 12)
            .shadow(color: tint.opacity(0.10), radius: 8, x: 0, y: 4)
    }
}

// Pill / capsule liquid glass — for buttons, chips, tab pills
struct LiquidGlassPill: ViewModifier {
    var tint: Color = .white
    @Environment(\.colorScheme) private var scheme
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Capsule().fill(scheme == .dark ? Theme.surfaceDark : Theme.surface)
                    Capsule().fill(
                        LinearGradient(
                            colors: [tint.opacity(0.22), tint.opacity(0.05)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    Capsule().stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.55), Color.white.opacity(0.10)],
                            startPoint: .top, endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
                    .blendMode(.plusLighter)
                    Capsule().strokeBorder(Color.white.opacity(0.25), lineWidth: 0.5)
                }
                .allowsHitTesting(false)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
}

struct StickyNoteCard: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .background(color.opacity(0.90), in: RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: color.opacity(0.30), radius: 8, x: 0, y: 4)
    }
}

struct PressScaleButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.97
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? 0.88 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 24, tint: Color = Theme.primary) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, tint: tint))
    }
    func liquidGlass(cornerRadius: CGFloat = 24, tint: Color = Theme.primary) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius, tint: tint))
    }
    func liquidGlassPill(tint: Color = Theme.primary) -> some View {
        modifier(LiquidGlassPill(tint: tint))
    }
    func stickyNote(color: Color, cornerRadius: CGFloat = 16) -> some View {
        modifier(StickyNoteCard(color: color, cornerRadius: cornerRadius))
    }
    
    /// Applies a glass effect with the specified style
    func glassEffect<S: ShapeStyle, SS: Shape>(_ style: S, in shape: SS) -> some View {
        self
            .background(style, in: shape)
    }
}

// MARK: - Glass Effect Container
struct GlassEffectContainer<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    
    init(spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        content
            .glassCard(cornerRadius: 20, tint: Theme.primary)
    }
}

// MARK: - RaceTrian Logo wordmark
struct RaceTrianLogo: View {
    var size: CGFloat = 44
    var stacked: Bool = true
    var body: some View {
        VStack(alignment: .leading, spacing: -size * 0.18) {
            if stacked {
                Text("RACE")
                    .font(.system(size: size, weight: .heavy, design: .rounded))
                    .foregroundStyle(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.35), radius: 0, x: 2, y: 2)
                Text("TRIAN")
                    .font(.system(size: size, weight: .heavy, design: .rounded))
                    .foregroundStyle(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.35), radius: 0, x: 2, y: 2)
            } else {
                Text("RACETRIAN")
                    .font(.system(size: size, weight: .heavy, design: .rounded))
                    .foregroundStyle(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.35), radius: 0, x: 2, y: 2)
            }
        }
        .tracking(1)
    }
}

// Hero "notebook" mark — paper card with sticky-note + washi tape + RaceTrian
struct RaceTrianNotebookMark: View {
    var body: some View {
        ZStack {
            // Cream paper card with binding edge
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Theme.paper)
                .overlay(
                    HStack(spacing: 0) {
                        // Black spine with rings
                        ZStack {
                            Rectangle().fill(Color.black.opacity(0.88))
                            VStack(spacing: 6) {
                                ForEach(0..<7, id: \.self) { _ in
                                    Capsule()
                                        .fill(Color.white.opacity(0.75))
                                        .frame(width: 8, height: 12)
                                }
                            }
                        }
                        .frame(width: 22)
                        Spacer()
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)

            // Sticky note + washi tape stack (right side)
            VStack(spacing: 6) {
                ZStack {
                    Rectangle()
                        .fill(Theme.stickyYellow)
                        .frame(width: 56, height: 14)
                        .rotationEffect(.degrees(-4))
                        .offset(y: -2)
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Theme.stickyPink)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(2))
                }
                .padding(.top, 18)

                // AI PLANNER wordmark on top
                RaceTrianLogo(size: 14, stacked: true)
                    .scaleEffect(0.85)
            }
            .padding(.leading, 30)
        }
        .frame(width: 160, height: 160)
    }
}

// Shared page treatment for all destinations and presented forms.
private struct AppPageTheme: ViewModifier {
    func body(content: Content) -> some View {
        content
            .tint(Theme.primary)
            #if !os(watchOS)
            .scrollContentBackground(.hidden)
            .background { PaperBackground() }
            .toolbarBackground(Theme.pageBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .presentationBackground(Theme.pageBackground)
            #endif
    }
}

extension View {
    func appPageTheme() -> some View {
        modifier(AppPageTheme())
    }
}
// MARK: - Placeholder Views
// These are temporary placeholder views for features that haven't been implemented yet

struct TrainingLoadView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundStyle(Theme.primary)
            
            Text("Training Load")
                .font(.title.bold())
            
            Text("Monitor your training load and recovery needs")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Training Load")
    }
}

struct SwimmingTrackingView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.pool.swim")
                .font(.system(size: 60))
                .foregroundStyle(.cyan)
            
            Text("Swimming Tracking")
                .font(.title.bold())
            
            Text("Track your swimming workouts and progress")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Swimming")
    }
}

struct SeasonalTrendsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            
            Text("Seasonal Trends")
                .font(.title.bold())
            
            Text("Analyze your performance trends across seasons")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Seasonal Trends")
    }
}

struct PerformancePredictorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            Text("Performance Predictor")
                .font(.title.bold())
            
            Text("Predict future performance based on current training")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Performance Predictor")
    }
}

struct InjuryPreventionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 60))
                .foregroundStyle(.red)
            
            Text("Injury Prevention")
                .font(.title.bold())
            
            Text("Tips and insights to prevent training injuries")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Injury Prevention")
    }
}

struct WeatherImpactView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text("Weather Impact")
                .font(.title.bold())
            
            Text("Understand how weather affects your performance")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Weather Impact")
    }
}

struct CompetitionReadinessView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)
            
            Text("Competition Readiness")
                .font(.title.bold())
            
            Text("Assess your readiness for upcoming competitions")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Competition Readiness")
    }
}

struct CyclingMetricsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bicycle")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            Text("Cycling Metrics")
                .font(.title.bold())
            
            Text("Detailed metrics for your cycling activities")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Cycling Metrics")
    }
}

struct RunningAnalyticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.run")
                .font(.system(size: 60))
                .foregroundStyle(Theme.primary)
            
            Text("Running Analytics")
                .font(.title.bold())
            
            Text("Detailed analysis of your running performance")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Running Analytics")
    }
}

struct FormAnalysisView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 60))
                .foregroundStyle(.purple)
            
            Text("Form Analysis")
                .font(.title.bold())
            
            Text("Analyze and improve your athletic form")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("Form Analysis")
    }
}
