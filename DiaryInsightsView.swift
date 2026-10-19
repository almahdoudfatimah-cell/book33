//
//  DiaryInsightsView.swift
//  RaceTrian
//
//  Created to provide diary insights and analytics
//

#if !os(watchOS)

import SwiftUI

struct DiaryInsightsView: View {
    @StateObject private var store = DiaryStore.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Streak card
                streakCard
                
                // Mood trends
                moodTrendsCard
                
                // Stats grid
                statsGrid
                
                // Tags overview
                tagsCard
            }
            .padding(20)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Streak Card
    
    private var streakCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(Theme.primary)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Streak")
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("\(store.streakDays) days in a row")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                Spacer()
                
                Text("\(store.streakDays)")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.primary)
            }
        }
        .padding()
        .glassCard(cornerRadius: 16, tint: Theme.primary)
    }
    
    // MARK: - Mood Trends
    
    private var moodTrendsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Trends (Last 7 Days)")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
            
            let scores = store.moodScores(last: 7)
            
            if scores.isEmpty {
                Text("Not enough data yet")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(Array(scores.enumerated()), id: \.offset) { index, data in
                        VStack(spacing: 6) {
                            // Bar
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Theme.primary.opacity(0.2 + data.1 * 0.8))
                                .frame(width: 32, height: CGFloat(data.1 * 100))
                            
                            // Day label
                            Text(dayLabel(for: data.0))
                                .font(.caption2)
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                
                HStack {
                    Circle()
                        .fill(Theme.primary.opacity(0.3))
                        .frame(width: 12, height: 12)
                    Text("Low")
                        .font(.caption2)
                        .foregroundStyle(Theme.textSecondary)
                    
                    Spacer()
                    
                    Circle()
                        .fill(Theme.primary)
                        .frame(width: 12, height: 12)
                    Text("High")
                        .font(.caption2)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .padding()
        .glassCard(cornerRadius: 16, tint: Theme.primary)
    }
    
    // MARK: - Stats Grid
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatBox(
                icon: "book.fill",
                label: "Total Entries",
                value: "\(store.entries.count)",
                color: Theme.primary
            )
            
            StatBox(
                icon: "text.word.spacing",
                label: "Words Written",
                value: formatNumber(store.totalWords),
                color: Theme.secondary
            )
            
            StatBox(
                icon: "face.smiling.fill",
                label: "Avg Mood",
                value: String(format: "%.0f%%", store.averageMoodScore * 100),
                color: Theme.accent
            )
            
            StatBox(
                icon: "star.fill",
                label: "Favourites",
                value: "\(store.entries.filter(\.isFavorite).count)",
                color: Theme.mint
            )
        }
    }
    
    // MARK: - Tags Card
    
    private var tagsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Most Used Tags")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
            
            let tagCounts = calculateTagCounts()
            
            if tagCounts.isEmpty {
                Text("No tags used yet")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(tagCounts.prefix(5)), id: \.key) { tag, count in
                        HStack {
                            Image(systemName: tag.icon)
                                .foregroundStyle(tag.color)
                                .frame(width: 24)
                            
                            Text(tag.rawValue)
                                .font(.subheadline)
                                .foregroundStyle(Theme.textPrimary)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Theme.surface, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding()
        .glassCard(cornerRadius: 16, tint: Theme.primary)
    }
    
    // MARK: - Helper Methods
    
    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            return String(format: "%.1fk", Double(number) / 1000.0)
        }
        return "\(number)"
    }
    
    private func calculateTagCounts() -> [(key: DiaryTag, value: Int)] {
        var counts: [DiaryTag: Int] = [:]
        
        for entry in store.entries {
            for tag in entry.tags {
                counts[tag, default: 0] += 1
            }
        }
        
        return counts.sorted { $0.value > $1.value }
    }
}

// MARK: - Stat Box Component

struct StatBox: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .glassCard(cornerRadius: 12, tint: color)
    }
}

// MARK: - Preview

#Preview {
    DiaryInsightsView()
}

#endif
