//
//  AdditionalAnalyticsViews.swift
//  RaceTrian
//
//  Created to resolve missing view errors
//

#if !os(watchOS)

import SwiftUI

// MARK: - Running Analytics View

struct RunningAnalyticsView: View {
    @State private var selectedTimeframe: Timeframe = .week
    
    enum Timeframe: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Timeframe selector
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(Timeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Stats cards
                HStack(spacing: 16) {
                    StatCard(title: "Total Distance", value: "125.4", unit: "km", icon: "figure.run")
                    StatCard(title: "Total Time", value: "12:30", unit: "hrs", icon: "clock.fill")
                }
                .padding(.horizontal)
                
                HStack(spacing: 16) {
                    StatCard(title: "Avg Pace", value: "5:45", unit: "min/km", icon: "speedometer")
                    StatCard(title: "Calories", value: "8,250", unit: "kcal", icon: "flame.fill")
                }
                .padding(.horizontal)
                
                // Chart placeholder
                VStack(alignment: .leading, spacing: 12) {
                    Text("Weekly Distance")
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.surface)
                        .frame(height: 200)
                        .overlay(
                            Text("Chart Coming Soon")
                                .foregroundStyle(Theme.textSecondary)
                        )
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Running Analytics")
        .background(PaperBackground())
    }
}

// MARK: - Weather Impact View

struct WeatherImpactView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Weather Impact Analysis")
                    .font(.title2.bold())
                    .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                    WeatherImpactRow(
                        condition: "Sunny",
                        icon: "sun.max.fill",
                        color: .yellow,
                        avgPace: "5:30",
                        sessions: 12
                    )
                    
                    WeatherImpactRow(
                        condition: "Cloudy",
                        icon: "cloud.fill",
                        color: .gray,
                        avgPace: "5:25",
                        sessions: 18
                    )
                    
                    WeatherImpactRow(
                        condition: "Rainy",
                        icon: "cloud.rain.fill",
                        color: .blue,
                        avgPace: "5:45",
                        sessions: 8
                    )
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Weather Impact")
        .background(PaperBackground())
    }
}

struct WeatherImpactRow: View {
    let condition: String
    let icon: String
    let color: Color
    let avgPace: String
    let sessions: Int
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(condition)
                    .font(.headline)
                Text("\(sessions) sessions")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Avg Pace")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                Text(avgPace)
                    .font(.headline)
                    .foregroundStyle(Theme.primary)
            }
        }
        .padding()
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Competition Readiness View

struct CompetitionReadinessView: View {
    @State private var readinessScore: Double = 0.75
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Readiness gauge
                VStack(spacing: 12) {
                    Text("Readiness Score")
                        .font(.headline)
                    
                    ZStack {
                        Circle()
                            .stroke(Theme.surface, lineWidth: 20)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: readinessScore)
                            .stroke(
                                Theme.primary,
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(Int(readinessScore * 100))%")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.primary)
                            Text("Ready")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }
                .padding()
                .glassCard(cornerRadius: 20, tint: Theme.primary)
                .padding(.horizontal)
                
                // Factors
                VStack(alignment: .leading, spacing: 12) {
                    Text("Readiness Factors")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    FactorRow(name: "Training Load", score: 0.8, icon: "figure.run")
                    FactorRow(name: "Recovery", score: 0.7, icon: "bed.double.fill")
                    FactorRow(name: "Nutrition", score: 0.75, icon: "fork.knife")
                    FactorRow(name: "Sleep Quality", score: 0.85, icon: "moon.stars.fill")
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Competition Readiness")
        .background(PaperBackground())
    }
}

struct FactorRow: View {
    let name: String
    let score: Double
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Theme.primary)
                .frame(width: 30)
            
            Text(name)
                .font(.subheadline)
            
            Spacer()
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.surface)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.primary)
                        .frame(width: geo.size.width * score, height: 8)
                }
            }
            .frame(width: 100, height: 8)
            
            Text("\(Int(score * 100))%")
                .font(.caption.bold())
                .foregroundStyle(Theme.textSecondary)
                .frame(width: 40, alignment: .trailing)
        }
        .padding()
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Performance Predictor View

struct PerformancePredictorView: View {
    @State private var selectedDistance: Distance = .fiveK
    
    enum Distance: String, CaseIterable {
        case fiveK = "5K"
        case tenK = "10K"
        case halfMarathon = "Half Marathon"
        case marathon = "Marathon"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("Distance", selection: $selectedDistance) {
                    ForEach(Distance.allCases, id: \.self) { distance in
                        Text(distance.rawValue).tag(distance)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Predicted Finish Time")
                        .font(.headline)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(predictedTime(for: selectedDistance))
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.primary)
                            
                            Text("Based on recent training")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Theme.accent.gradient)
                    }
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Training Recommendations")
                        .font(.headline)
                    
                    RecommendationRow(
                        icon: "figure.run",
                        title: "Increase long runs",
                        detail: "Build endurance with weekly long runs"
                    )
                    
                    RecommendationRow(
                        icon: "speedometer",
                        title: "Add speed work",
                        detail: "Include interval training twice per week"
                    )
                    
                    RecommendationRow(
                        icon: "bed.double.fill",
                        title: "Prioritize recovery",
                        detail: "Ensure adequate rest between hard sessions"
                    )
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Performance Predictor")
        .background(PaperBackground())
    }
    
    func predictedTime(for distance: Distance) -> String {
        switch distance {
        case .fiveK: return "22:30"
        case .tenK: return "47:15"
        case .halfMarathon: return "1:45:30"
        case .marathon: return "3:35:00"
        }
    }
}

struct RecommendationRow: View {
    let icon: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Theme.primary)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding()
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Additional Sport-Specific Views

struct CyclingMetricsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Cycling Metrics")
                    .font(.title2.bold())
                    .padding()
                
                HStack(spacing: 16) {
                    StatCard(title: "Avg Power", value: "245", unit: "W", icon: "bolt.fill")
                    StatCard(title: "FTP", value: "280", unit: "W", icon: "gauge.high")
                }
                .padding(.horizontal)
                
                HStack(spacing: 16) {
                    StatCard(title: "Cadence", value: "88", unit: "rpm", icon: "rotate.right.fill")
                    StatCard(title: "TSS", value: "275", unit: "pts", icon: "chart.bar.fill")
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Cycling Metrics")
        .background(PaperBackground())
    }
}

struct SwimmingTrackingView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Swimming Tracking")
                    .font(.title2.bold())
                    .padding()
                
                HStack(spacing: 16) {
                    StatCard(title: "Pool Length", value: "50", unit: "m", icon: "figure.pool.swim")
                    StatCard(title: "Strokes", value: "1,245", unit: "count", icon: "hand.wave.fill")
                }
                .padding(.horizontal)
                
                HStack(spacing: 16) {
                    StatCard(title: "Pace", value: "1:45", unit: "/100m", icon: "speedometer")
                    StatCard(title: "SWOLF", value: "42", unit: "score", icon: "chart.line.uptrend.xyaxis")
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Swimming Tracking")
        .background(PaperBackground())
    }
}

struct TrainingLoadView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Training Load")
                    .font(.title2.bold())
                    .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Acute Training Load (ATL)")
                        .font(.headline)
                    
                    HStack {
                        Text("Current: 425")
                            .font(.title3.bold())
                            .foregroundStyle(Theme.primary)
                        Spacer()
                        Text("7-day avg")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Chronic Training Load (CTL)")
                        .font(.headline)
                    
                    HStack {
                        Text("Current: 380")
                            .font(.title3.bold())
                            .foregroundStyle(Theme.secondary)
                        Spacer()
                        Text("42-day avg")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.secondary)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Training Stress Balance (TSB)")
                        .font(.headline)
                    
                    HStack {
                        Text("-45")
                            .font(.title3.bold())
                            .foregroundStyle(Theme.accent)
                        Spacer()
                        Text("Optimal training zone")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.accent)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Training Load")
        .background(PaperBackground())
    }
}

struct InjuryPreventionView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Injury Prevention")
                    .font(.title2.bold())
                    .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Risk Assessment")
                        .font(.headline)
                    
                    RiskFactorRow(factor: "Training Load", level: .low, icon: "figure.run")
                    RiskFactorRow(factor: "Recovery Time", level: .medium, icon: "bed.double.fill")
                    RiskFactorRow(factor: "Muscle Fatigue", level: .low, icon: "person.fill")
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recommendations")
                        .font(.headline)
                    
                    Text("• Add more recovery days between hard sessions")
                    Text("• Include mobility work 3x per week")
                    Text("• Monitor muscle soreness closely")
                    Text("• Stay hydrated and fuel properly")
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.secondary)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Injury Prevention")
        .background(PaperBackground())
    }
}

struct RiskFactorRow: View {
    let factor: String
    let level: RiskLevel
    let icon: String
    
    enum RiskLevel {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .red
            }
        }
        
        var text: String {
            switch self {
            case .low: return "Low Risk"
            case .medium: return "Medium Risk"
            case .high: return "High Risk"
            }
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(level.color)
                .frame(width: 30)
            
            Text(factor)
                .font(.subheadline)
            
            Spacer()
            
            Text(level.text)
                .font(.caption.bold())
                .foregroundStyle(level.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(level.color.opacity(0.15), in: Capsule())
        }
        .padding()
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct FormAnalysisView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Form Analysis")
                    .font(.title2.bold())
                    .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Running Form Metrics")
                        .font(.headline)
                    
                    FormMetricRow(metric: "Cadence", value: "172", target: "180", unit: "spm")
                    FormMetricRow(metric: "Stride Length", value: "1.28", target: "1.35", unit: "m")
                    FormMetricRow(metric: "Ground Contact", value: "245", target: "220", unit: "ms")
                    FormMetricRow(metric: "Vertical Oscillation", value: "8.2", target: "7.5", unit: "cm")
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Form Analysis")
        .background(PaperBackground())
    }
}

struct FormMetricRow: View {
    let metric: String
    let value: String
    let target: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric)
                .font(.subheadline.bold())
            
            HStack {
                Text("\(value) \(unit)")
                    .font(.title3.bold())
                    .foregroundStyle(Theme.primary)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Target")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                    Text("\(target) \(unit)")
                        .font(.caption.bold())
                }
            }
        }
        .padding()
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct SeasonalTrendsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Seasonal Trends")
                    .font(.title2.bold())
                    .padding()
                
                Text("Your performance patterns throughout the year")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    SeasonRow(season: "Spring", avgDistance: "45 km/week", improvement: "+12%")
                    SeasonRow(season: "Summer", avgDistance: "52 km/week", improvement: "+8%")
                    SeasonRow(season: "Autumn", avgDistance: "38 km/week", improvement: "-5%")
                    SeasonRow(season: "Winter", avgDistance: "30 km/week", improvement: "-15%")
                }
                .padding()
                .glassCard(cornerRadius: 16, tint: Theme.primary)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Seasonal Trends")
        .background(PaperBackground())
    }
}

struct SeasonRow: View {
    let season: String
    let avgDistance: String
    let improvement: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(season)
                    .font(.headline)
                Text(avgDistance)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
            
            Spacer()
            
            Text(improvement)
                .font(.subheadline.bold())
                .foregroundStyle(improvement.hasPrefix("+") ? .green : .red)
        }
        .padding()
        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Stat Card Component

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(Theme.primary)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                Text(unit)
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 12, tint: Theme.primary)
    }
}

#endif
