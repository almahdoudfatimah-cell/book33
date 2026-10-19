//
//  MissingViews.swift
//  RaceTrian
//
//  Stub implementations for missing views
//

import SwiftUI

// MARK: - Training & Analytics Views

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

// MARK: - Preview Providers

#Preview("Training Load") {
    NavigationStack {
        TrainingLoadView()
    }
}

#Preview("Swimming Tracking") {
    NavigationStack {
        SwimmingTrackingView()
    }
}

#Preview("Seasonal Trends") {
    NavigationStack {
        SeasonalTrendsView()
    }
}

#Preview("Performance Predictor") {
    NavigationStack {
        PerformancePredictorView()
    }
}

#Preview("Injury Prevention") {
    NavigationStack {
        InjuryPreventionView()
    }
}

#Preview("Weather Impact") {
    NavigationStack {
        WeatherImpactView()
    }
}

#Preview("Competition Readiness") {
    NavigationStack {
        CompetitionReadinessView()
    }
}

#Preview("Cycling Metrics") {
    NavigationStack {
        CyclingMetricsView()
    }
}

#Preview("Form Analysis") {
    NavigationStack {
        FormAnalysisView()
    }
}
