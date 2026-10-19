import Foundation
import SwiftUI
import Combine
import Security
import CryptoKit
import AuthenticationServices

struct MoreView: View {
    @StateObject private var assessment = AssessmentStore.shared
    @State private var showAssessment  = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: Training
                Section("Training") {
                    NavigationLink {
                        SportsTrackingView()
                    } label: {
                        MoreRow(title: "Sports Tracking",
                                subtitle: "Log runs, swims, rides & more",
                                icon: "figure.run",
                                color: .orange)
                    }
                    NavigationLink {
                        TrainingTrackingView()
                    } label: {
                        MoreRow(title: "Training Log",
                                subtitle: "Workouts, exercises & sets",
                                icon: "dumbbell.fill",
                                color: .red)
                    }
                    NavigationLink {
                        PlaceholderView(title: "Race Events",
                                        subtitle: "Track upcoming races and results",
                                        icon: "flag.checkered")
                    } label: {
                        MoreRow(title: "Race Events",
                                subtitle: "Upcoming races & results",
                                icon: "flag.checkered",
                                color: .purple)
                    }
                    NavigationLink {
                        PlaceholderView(title: "Race Calendar",
                                        subtitle: "Browse and plan race events",
                                        icon: "calendar.badge.clock")
                    } label: {
                        MoreRow(title: "Race Calendar",
                                subtitle: "Browse & plan race events",
                                icon: "calendar.badge.clock",
                                color: .blue)
                    }
                }

                // MARK: Health & Wellness
                Section("Health & Wellness") {
                    NavigationLink {
                        PlaceholderView(title: "Nutrition",
                                        subtitle: "Track meals and macros",
                                        icon: "fork.knife")
                    } label: {
                        MoreRow(title: "Nutrition",
                                subtitle: "Meals and macro tracking",
                                icon: "fork.knife",
                                color: .green)
                    }
                    NavigationLink {
                        PlaceholderView(title: "Sleep Tracker",
                                        subtitle: "Monitor your sleep quality",
                                        icon: "moon.zzz.fill")
                    } label: {
                        MoreRow(title: "Sleep Tracker",
                                subtitle: "Monitor your sleep quality",
                                icon: "moon.zzz.fill",
                                color: Color(red: 0.3, green: 0.2, blue: 0.7))
                    }
                    NavigationLink {
                        PlaceholderView(title: "Body Metrics",
                                        subtitle: "Weight, heart rate and more",
                                        icon: "heart.text.square.fill")
                    } label: {
                        MoreRow(title: "Body Metrics",
                                subtitle: "Weight, HR & measurements",
                                icon: "heart.text.square.fill",
                                color: .pink)
                    }
                }

                // MARK: Tools
                Section("Tools") {
                    NavigationLink {
                        CoachView()
                    } label: {
                        MoreRow(title: "AI Coach",
                                subtitle: "Get personalised training advice",
                                icon: "brain.head.profile",
                                color: .indigo)
                    }
                    NavigationLink {
                        ProjectsView()
                    } label: {
                        MoreRow(title: "Projects",
                                subtitle: "Manage your training projects",
                                icon: "folder.fill",
                                color: .yellow)
                    }
                    NavigationLink {
                        NotesView()
                    } label: {
                        MoreRow(title: "Notes",
                                subtitle: "Quick notes and ideas",
                                icon: "note.text",
                                color: .teal)
                    }
                }

                // MARK: Personal
                Section("Personal") {
                    NavigationLink {
                        DiaryView()
                    } label: {
                        MoreRow(title: "Diary",
                                subtitle: "Daily reflections & entries",
                                icon: "book.fill",
                                color: .brown)
                    }

                    Button {
                        showAssessment = true
                    } label: {
                        HStack {
                            MoreRow(title: "Athlete Assessment",
                                    subtitle: assessment.isCompleted
                                        ? "Profile complete — tap to view"
                                        : "Tell us about yourself",
                                    icon: "person.text.rectangle.fill",
                                    color: Theme.primary)
                            Spacer()
                            if !assessment.isCompleted {
                                Text("New")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Theme.primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        PlaceholderView(title: "Achievements",
                                        subtitle: "Badges and milestones you have earned",
                                        icon: "trophy.fill")
                    } label: {
                        MoreRow(title: "Achievements",
                                subtitle: "Badges & milestones",
                                icon: "trophy.fill",
                                color: .yellow)
                    }
                    NavigationLink {
                        ProfileView()
                    } label: {
                        MoreRow(title: "Profile",
                                subtitle: "Account settings & preferences",
                                icon: "person.crop.circle.fill",
                                color: .gray)
                    }
                }
            }
            .navigationTitle("More")
        }
        .sheet(isPresented: $showAssessment) {
            AssessmentView()
        }
    }
}

private struct MoreRow: View {
    let title:    String
    let subtitle: String
    let icon:     String
    let color:    Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(color)
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}
