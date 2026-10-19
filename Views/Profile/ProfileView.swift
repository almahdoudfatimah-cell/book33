#if !os(watchOS)
import SwiftUI
import Combine

@MainActor
struct ProfileView: View {
    @ObservedObject private var store: ProfileStore = .shared
    @State private var showSignOutConfirmation = false
    @State private var quickDestination: ProfileQuickDestination?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Header with title
                    Text("More")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    // Profile Card Section
                    VStack(spacing: 0) {
                        HStack(spacing: 16) {
                            // Avatar
                            Text(store.avatarEmoji)
                                .font(.system(size: 50))
                                .frame(width: 80, height: 80)
                                .background(
                                    LinearGradient(colors: [Theme.primary, Theme.accent], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 3)
                                )
                                .shadow(color: Theme.primary.opacity(0.3), radius: 10, y: 5)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(store.name)
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                
                                Text(store.tagline)
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                
                                // Premium Badge
                                HStack(spacing: 6) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 12))
                                    Text("Premium Member")
                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                                }
                                .foregroundStyle(Color(red: 1.0, green: 0.8, blue: 0.0))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.15))
                                )
                                .padding(.top, 4)
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                        .background(Theme.surface)
                        
                        Divider()
                        
                        // Quick Settings Row
                        HStack(spacing: 0) {
                            Button {
                                quickDestination = .theme
                            } label: {
                                quickSettingLabel(
                                    icon: "paintbrush.fill",
                                    title: "Theme",
                                    detail: "Style",
                                    color: Theme.accent
                                )
                            }
                            .buttonStyle(.plain)

                            Divider()

                            Button {
                                quickDestination = .premium
                            } label: {
                                quickSettingLabel(
                                    icon: "crown.fill",
                                    title: "Premium",
                                    detail: "Benefits",
                                    color: Color(red: 1.0, green: 0.68, blue: 0.0)
                                )
                            }
                            .buttonStyle(.plain)

                            Divider()

                            Button {
                                quickDestination = .editProfile
                            } label: {
                                quickSettingLabel(
                                    icon: "person.crop.circle.fill",
                                    title: "Edit",
                                    detail: "Profile",
                                    color: Theme.primary
                                )
                            }
                            .buttonStyle(.plain)

                            Divider()

                            Button {
                                quickDestination = .alerts
                            } label: {
                                quickSettingLabel(
                                    icon: "bell.badge.fill",
                                    title: "Alerts",
                                    detail: "Manage",
                                    color: Theme.rose
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .background(Theme.surface)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                    .padding(.horizontal, 20)
                    
                    // Training Section
                    CategorySection(title: "Training") {
                        NavigationMenuRow(
                            icon: "figure.run",
                            title: "Sports Tracking",
                            subtitle: "Log runs, swims, rides & more",
                            color: .orange,
                            destination: AnyView(SportsTrackingView())
                        )
                        
                        NavigationMenuRow(
                            icon: "dumbbell.fill",
                            title: "Training Log",
                            subtitle: "Track workouts, sets & exercises",
                            color: .red,
                            destination: AnyView(TrainingLogView())
                        )
                        
                        NavigationMenuRow(
                            icon: "chart.bar.fill",
                            title: "Training Tracking",
                            subtitle: "Monitor training progress",
                            color: .blue,
                            destination: AnyView(TrainingTrackingView())
                        )
                        
                        NavigationMenuRow(
                            icon: "flag.checkered",
                            title: "Race Events",
                            subtitle: "Upcoming races & competitions",
                            color: .purple,
                            destination: AnyView(RaceEventsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "calendar.badge.clock",
                            title: "Training Calendar",
                            subtitle: "Plan your training schedule",
                            color: Color(red: 0.3, green: 0.7, blue: 0.9),
                            destination: AnyView(TrainingCalendarView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bolt.heart.fill",
                            title: "Interval Training",
                            subtitle: "HIIT & interval workouts",
                            color: Color(red: 1.0, green: 0.5, blue: 0.0),
                            destination: AnyView(IntervalTrainingView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.cooldown",
                            title: "Recovery Tracker",
                            subtitle: "Monitor rest & recovery",
                            color: Color(red: 0.4, green: 0.8, blue: 0.6),
                            destination: AnyView(RecoveryTrackerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "person.fill.checkmark",
                            title: "Personal Coach",
                            subtitle: "AI-powered training advice",
                            color: Color(red: 0.9, green: 0.3, blue: 0.5),
                            destination: AnyView(PersonalCoachView())
                        )
                        
                        NavigationMenuRow(
                            icon: "target",
                            title: "Training Goals",
                            subtitle: "Set & achieve your targets",
                            color: Color(red: 0.2, green: 0.6, blue: 0.9),
                            destination: AnyView(TrainingGoalsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "film.fill",
                            title: "Exercise Library",
                            subtitle: "Videos & form guides",
                            color: Color(red: 0.7, green: 0.4, blue: 0.9),
                            destination: AnyView(ExerciseLibraryView())
                        )
                        
                        NavigationMenuRow(
                            icon: "list.clipboard.fill",
                            title: "Workout Plans",
                            subtitle: "Pre-built training programs",
                            color: Color(red: 0.5, green: 0.7, blue: 0.3),
                            destination: AnyView(WorkoutPlansView())
                        )
                        
                        NavigationMenuRow(
                            icon: "waveform.path.ecg",
                            title: "Zone Training",
                            subtitle: "Heart rate zone workouts",
                            color: .pink,
                            destination: AnyView(ZoneTrainingView())
                        )
                        
                        NavigationMenuRow(
                            icon: "stopwatch.fill",
                            title: "Workout Timer",
                            subtitle: "Custom timers & stopwatch",
                            color: Color(red: 0.3, green: 0.6, blue: 0.8),
                            destination: AnyView(WorkoutTimerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.run.circle.fill",
                            title: "Running Coach",
                            subtitle: "AI running plans & tips",
                            color: Color(red: 1.0, green: 0.6, blue: 0.3),
                            destination: AnyView(RunningCoachView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.swimming",
                            title: "Swim Training",
                            subtitle: "Pool workouts & technique",
                            color: Color(red: 0.2, green: 0.6, blue: 0.9),
                            destination: AnyView(SwimTrainingView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bicycle.circle.fill",
                            title: "Cycling Coach",
                            subtitle: "Indoor & outdoor rides",
                            color: Color(red: 0.4, green: 0.7, blue: 0.3),
                            destination: AnyView(CyclingCoachView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.martial.arts",
                            title: "Functional Training",
                            subtitle: "CrossFit & HIIT programs",
                            color: Color(red: 0.8, green: 0.3, blue: 0.2),
                            destination: AnyView(FunctionalTrainingView())
                        )
                    }
                    
                    // Tracking & Analytics Section (10+ Features)
                    CategorySection(title: "Tracking & Analytics") {
                        NavigationMenuRow(
                            icon: "chart.xyaxis.line",
                            title: "Performance Tracking",
                            subtitle: "Monitor all your activities",
                            color: .blue,
                            destination: AnyView(PerformanceTrackingView())
                        )
                        
                        NavigationMenuRow(
                            icon: "calendar.badge.checkmark",
                            title: "Workout Logger",
                            subtitle: "Log exercises, sets & reps",
                            color: .red,
                            destination: AnyView(WorkoutLoggerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "flame.fill",
                            title: "Calorie Tracker",
                            subtitle: "Track calories in & out",
                            color: .orange,
                            destination: AnyView(CalorieTrackerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.walk",
                            title: "Steps Counter",
                            subtitle: "Daily step tracking & goals",
                            color: Color(red: 0.2, green: 0.8, blue: 0.4),
                            destination: AnyView(StepsCounterView())
                        )
                        
                        NavigationMenuRow(
                            icon: "heart.fill",
                            title: "Heart Rate Monitor",
                            subtitle: "Track HR zones & trends",
                            color: .pink,
                            destination: AnyView(HeartRateMonitorView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.strengthtraining.functional",
                            title: "Strength Progress",
                            subtitle: "Track lifting PRs & volume",
                            color: Color(red: 0.6, green: 0.2, blue: 0.8),
                            destination: AnyView(StrengthProgressView())
                        )
                        
                        NavigationMenuRow(
                            icon: "gauge.with.dots.needle.67percent",
                            title: "Distance Tracker",
                            subtitle: "Running, cycling & swimming",
                            color: .cyan,
                            destination: AnyView(DistanceTrackerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Progress Charts",
                            subtitle: "Visualize improvements",
                            color: Color(red: 0.2, green: 0.7, blue: 0.9),
                            destination: AnyView(ProgressChartsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "scalemass.fill",
                            title: "Weight Tracking",
                            subtitle: "Monitor body weight changes",
                            color: Color(red: 0.8, green: 0.5, blue: 0.2),
                            destination: AnyView(WeightTrackingView())
                        )
                        
                        NavigationMenuRow(
                            icon: "percent",
                            title: "Body Fat Tracker",
                            subtitle: "Track body composition",
                            color: Color(red: 0.9, green: 0.4, blue: 0.5),
                            destination: AnyView(BodyFatTrackerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "ruler.fill",
                            title: "Measurements",
                            subtitle: "Arms, chest, waist & more",
                            color: Color(red: 0.5, green: 0.6, blue: 0.9),
                            destination: AnyView(MeasurementsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "clock.arrow.circlepath",
                            title: "Workout Duration",
                            subtitle: "Time spent training",
                            color: Color(red: 0.7, green: 0.3, blue: 0.9),
                            destination: AnyView(WorkoutDurationView())
                        )
                        
                        NavigationMenuRow(
                            icon: "trophy.fill",
                            title: "Personal Records",
                            subtitle: "All-time bests & achievements",
                            color: Color(red: 1.0, green: 0.7, blue: 0.0),
                            destination: AnyView(PersonalRecordsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "chart.pie.fill",
                            title: "Activity Breakdown",
                            subtitle: "See where time goes",
                            color: Color(red: 0.3, green: 0.8, blue: 0.6),
                            destination: AnyView(ActivityBreakdownView())
                        )
                        
                        NavigationMenuRow(
                            icon: "speedometer",
                            title: "Pace Analysis",
                            subtitle: "Track running & cycling pace",
                            color: Color(red: 0.1, green: 0.5, blue: 0.9),
                            destination: AnyView(PaceAnalysisView())
                        )
                        
                        NavigationMenuRow(
                            icon: "wind",
                            title: "VO2 Max Tracker",
                            subtitle: "Monitor cardio fitness level",
                            color: Color(red: 0.0, green: 0.7, blue: 0.8),
                            destination: AnyView(VO2MaxTrackerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "drop.fill",
                            title: "Hydration Log",
                            subtitle: "Daily water intake tracking",
                            color: Color(red: 0.2, green: 0.6, blue: 1.0),
                            destination: AnyView(HydrationLogView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.mixed.cardio",
                            title: "Cardio Stats",
                            subtitle: "Running, cycling & swimming data",
                            color: Color(red: 1.0, green: 0.4, blue: 0.0),
                            destination: AnyView(CardioStatsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bolt.circle.fill",
                            title: "Energy Levels",
                            subtitle: "Track daily energy & fatigue",
                            color: Color(red: 1.0, green: 0.8, blue: 0.2),
                            destination: AnyView(EnergyLevelsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.stairs",
                            title: "Elevation Gain",
                            subtitle: "Track climbing & altitude",
                            color: Color(red: 0.5, green: 0.3, blue: 0.1),
                            destination: AnyView(ElevationGainView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bed.double.circle.fill",
                            title: "Recovery Score",
                            subtitle: "Track sleep & recovery metrics",
                            color: Color(red: 0.4, green: 0.6, blue: 0.9),
                            destination: AnyView(RecoveryScoreView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.flexibility",
                            title: "Flexibility Tracker",
                            subtitle: "Monitor stretching & mobility",
                            color: Color(red: 0.8, green: 0.4, blue: 0.7),
                            destination: AnyView(FlexibilityTrackerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "thermometer.medium",
                            title: "Training Zones",
                            subtitle: "Power, pace & HR zone analysis",
                            color: Color(red: 0.9, green: 0.5, blue: 0.3),
                            destination: AnyView(TrainingZonesView())
                        )
                        
                        NavigationMenuRow(
                            icon: "chart.bar.doc.horizontal",
                            title: "Weekly Summary",
                            subtitle: "Comprehensive weekly stats",
                            color: Color(red: 0.3, green: 0.5, blue: 0.8),
                            destination: AnyView(WeeklySummaryView())
                        )
                        
                        NavigationMenuRow(
                            icon: "moon.zzz.fill",
                            title: "Sleep Quality",
                            subtitle: "Detailed sleep analysis & insights",
                            color: Color(red: 0.5, green: 0.4, blue: 0.7),
                            destination: AnyView(SleepQualityView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.walk.motion",
                            title: "Activity Rings",
                            subtitle: "Daily move, exercise & stand goals",
                            color: Color(red: 0.9, green: 0.2, blue: 0.4),
                            destination: AnyView(ActivityRingsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bolt.badge.automatic",
                            title: "Smart Insights",
                            subtitle: "AI-powered training recommendations",
                            color: Color(red: 0.2, green: 0.8, blue: 0.9),
                            destination: AnyView(SmartInsightsView())
                        )
                    }
                    
                    // Health & Wellness Section
                    CategorySection(title: "Health & Wellness") {
                        NavigationMenuRow(
                            icon: "fork.knife",
                            title: "Nutrition",
                            subtitle: "Meals and macro tracking",
                            color: .green,
                            destination: AnyView(NutritionView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bed.double.fill",
                            title: "Sleep Tracker",
                            subtitle: "Monitor your sleep quality",
                            color: Color(red: 0.4, green: 0.3, blue: 0.8),
                            destination: AnyView(SleepTrackerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "heart.text.square.fill",
                            title: "Body Metrics",
                            subtitle: "Weight, HR & measurements",
                            color: .pink,
                            destination: AnyView(BodyMetricsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.mind.and.body",
                            title: "Meditation & Mindfulness",
                            subtitle: "Guided sessions & breathing exercises",
                            color: Color(red: 0.5, green: 0.7, blue: 0.9),
                            destination: AnyView(MeditationView())
                        )
                        
                        NavigationMenuRow(
                            icon: "brain.fill",
                            title: "Mental Health",
                            subtitle: "Mood tracking & wellness check-ins",
                            color: Color(red: 0.6, green: 0.4, blue: 0.9),
                            destination: AnyView(MentalHealthView())
                        )
                        
                        NavigationMenuRow(
                            icon: "pills.fill",
                            title: "Supplements & Vitamins",
                            subtitle: "Track daily supplement intake",
                            color: Color(red: 0.9, green: 0.6, blue: 0.2),
                            destination: AnyView(SupplementsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "cross.case.fill",
                            title: "Injury Log",
                            subtitle: "Track injuries & recovery timeline",
                            color: .red,
                            destination: AnyView(InjuryLogView())
                        )
                        
                        NavigationMenuRow(
                            icon: "leaf.fill",
                            title: "Wellness Score",
                            subtitle: "Overall health & fitness rating",
                            color: Color(red: 0.3, green: 0.8, blue: 0.5),
                            destination: AnyView(WellnessScoreView())
                        )
                        
                        NavigationMenuRow(
                            icon: "lungs.fill",
                            title: "Breathing Exercises",
                            subtitle: "Guided breathing & relaxation",
                            color: Color(red: 0.2, green: 0.7, blue: 0.8),
                            destination: AnyView(BreathingExercisesView())
                        )
                        
                        NavigationMenuRow(
                            icon: "figure.yoga",
                            title: "Yoga & Stretching",
                            subtitle: "Flexibility & mobility routines",
                            color: Color(red: 0.7, green: 0.5, blue: 0.9),
                            destination: AnyView(YogaStretchingView())
                        )
                        
                        NavigationMenuRow(
                            icon: "chart.line.uptrend.xyaxis.circle.fill",
                            title: "Health Trends",
                            subtitle: "Long-term health analytics",
                            color: Color(red: 0.5, green: 0.8, blue: 0.4),
                            destination: AnyView(HealthTrendsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "drop.circle.fill",
                            title: "Water Intake",
                            subtitle: "Daily hydration goals",
                            color: Color(red: 0.2, green: 0.7, blue: 1.0),
                            destination: AnyView(WaterIntakeView())
                        )
                        
                        NavigationMenuRow(
                            icon: "carrot.fill",
                            title: "Meal Planning",
                            subtitle: "Weekly meal prep & recipes",
                            color: Color(red: 1.0, green: 0.6, blue: 0.0),
                            destination: AnyView(MealPlanningView())
                        )
                        
                        NavigationMenuRow(
                            icon: "chart.bar.fill",
                            title: "Macro Tracker",
                            subtitle: "Protein, carbs & fats",
                            color: Color(red: 0.3, green: 0.7, blue: 0.4),
                            destination: AnyView(MacroTrackerView())
                        )
                    }
                    
                    // Motivation & Learning Section
                    CategorySection(title: "Motivation & Learning") {
                        NavigationMenuRow(
                            icon: "rectangle.stack.fill",
                            title: "Flash Cards",
                            subtitle: "Daily motivation & inspiration",
                            color: Color(red: 1.0, green: 0.6, blue: 0.0),
                            destination: AnyView(FlashCardsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "quote.bubble.fill",
                            title: "Daily Quotes",
                            subtitle: "Inspirational messages",
                            color: Color(red: 0.9, green: 0.3, blue: 0.5),
                            destination: AnyView(DailyQuotesView())
                        )
                        
                        NavigationMenuRow(
                            icon: "sparkles",
                            title: "Affirmations",
                            subtitle: "Positive daily reminders",
                            color: Color(red: 0.6, green: 0.4, blue: 0.9),
                            destination: AnyView(AffirmationsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "brain.head.profile",
                            title: "Learning Decks",
                            subtitle: "Study & memorize anything",
                            color: Color(red: 0.2, green: 0.7, blue: 0.9),
                            destination: AnyView(LearningDecksView())
                        )
                        
                        NavigationMenuRow(
                            icon: "book.fill",
                            title: "Study Guides",
                            subtitle: "Educational resources & notes",
                            color: Color(red: 0.8, green: 0.3, blue: 0.4),
                            destination: AnyView(StudyGuidesView())
                        )
                        
                        NavigationMenuRow(
                            icon: "graduationcap.fill",
                            title: "Achievements",
                            subtitle: "Badges & milestones earned",
                            color: Color(red: 1.0, green: 0.7, blue: 0.2),
                            destination: AnyView(AchievementsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "flame.circle.fill",
                            title: "Streaks & Challenges",
                            subtitle: "Daily streaks & competitions",
                            color: Color(red: 1.0, green: 0.4, blue: 0.0),
                            destination: AnyView(StreaksChallengesView())
                        )
                        
                        NavigationMenuRow(
                            icon: "newspaper.fill",
                            title: "Training Articles",
                            subtitle: "Expert tips & techniques",
                            color: Color(red: 0.4, green: 0.6, blue: 0.8),
                            destination: AnyView(TrainingArticlesView())
                        )
                        
                        NavigationMenuRow(
                            icon: "video.fill",
                            title: "Video Tutorials",
                            subtitle: "Learn proper form & technique",
                            color: Color(red: 0.8, green: 0.2, blue: 0.5),
                            destination: AnyView(VideoTutorialsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "person.2.wave.2.fill",
                            title: "Community Stories",
                            subtitle: "Success stories & inspiration",
                            color: Color(red: 0.3, green: 0.8, blue: 0.7),
                            destination: AnyView(CommunityStoriesView())
                        )
                    }
                    
                    // Equipment & Gear Section
                    CategorySection(title: "Equipment & Gear") {
                        NavigationMenuRow(
                            icon: "shoeprints.fill",
                            title: "Shoe Tracker",
                            subtitle: "Track mileage & replacements",
                            color: Color(red: 0.6, green: 0.4, blue: 0.2),
                            destination: AnyView(ShoeTrackerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bicycle",
                            title: "Bike Maintenance",
                            subtitle: "Service history & reminders",
                            color: Color(red: 0.2, green: 0.5, blue: 0.9),
                            destination: AnyView(BikeMaintenanceView())
                        )
                        
                        NavigationMenuRow(
                            icon: "applewatch",
                            title: "Device Sync",
                            subtitle: "Connect wearables & sensors",
                            color: .black,
                            destination: AnyView(DeviceSyncView())
                        )
                    }
                    
                    // Weather & Environment Section
                    CategorySection(title: "Weather & Environment") {
                        NavigationMenuRow(
                            icon: "cloud.sun.fill",
                            title: "Weather Forecast",
                            subtitle: "Plan workouts by weather",
                            color: Color(red: 0.3, green: 0.6, blue: 1.0),
                            destination: AnyView(WeatherForecastView())
                        )
                        
                        NavigationMenuRow(
                            icon: "map.fill",
                            title: "Route Planner",
                            subtitle: "Discover new training routes",
                            color: Color(red: 0.2, green: 0.8, blue: 0.4),
                            destination: AnyView(RoutePlannerView())
                        )
                        
                        NavigationMenuRow(
                            icon: "location.circle.fill",
                            title: "Saved Locations",
                            subtitle: "Favorite training spots",
                            color: Color(red: 0.9, green: 0.3, blue: 0.3),
                            destination: AnyView(SavedLocationsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "sunrise.fill",
                            title: "Sunrise/Sunset",
                            subtitle: "Plan early/late workouts",
                            color: Color(red: 1.0, green: 0.7, blue: 0.3),
                            destination: AnyView(SunriseSunsetView())
                        )
                    }
                    
                    // Premium & Advanced Section
                    CategorySection(title: "Premium & Advanced") {
                        NavigationMenuRow(
                            icon: "crown.fill",
                            title: "Premium Membership",
                            subtitle: "Unlock all features",
                            color: Color(red: 1.0, green: 0.8, blue: 0.0),
                            destination: AnyView(PremiumMembershipView())
                        )
                        
                        NavigationMenuRow(
                            icon: "chart.pie.fill",
                            title: "Advanced Analytics",
                            subtitle: "Deep dive into your data",
                            color: Color(red: 0.6, green: 0.3, blue: 0.9),
                            destination: AnyView(AdvancedAnalyticsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "sparkles.rectangle.stack.fill",
                            title: "AI Training Plans",
                            subtitle: "Personalized AI coaching",
                            color: Color(red: 0.4, green: 0.8, blue: 0.9),
                            destination: AnyView(AITrainingPlansView())
                        )
                        
                        NavigationMenuRow(
                            icon: "brain.fill",
                            title: "Performance Insights",
                            subtitle: "AI-powered recommendations",
                            color: Color(red: 0.8, green: 0.4, blue: 0.6),
                            destination: AnyView(PerformanceInsightsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "person.fill.checkmark",
                            title: "Virtual Coach",
                            subtitle: "Real-time training guidance",
                            color: Color(red: 0.3, green: 0.7, blue: 0.5),
                            destination: AnyView(VirtualCoachView())
                        )
                    }
                    
                    // Community & Social Section
                    CategorySection(title: "Community & Social") {
                        NavigationMenuRow(
                            icon: "person.2.fill",
                            title: "Friends & Following",
                            subtitle: "Connect with athletes",
                            color: Color(red: 0.3, green: 0.6, blue: 0.9),
                            destination: AnyView(FriendsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "trophy.fill",
                            title: "Leaderboards",
                            subtitle: "Compete with others",
                            color: Color(red: 1.0, green: 0.7, blue: 0.0),
                            destination: AnyView(LeaderboardsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bubble.left.and.bubble.right.fill",
                            title: "Community Chat",
                            subtitle: "Chat with other athletes",
                            color: Color(red: 0.5, green: 0.8, blue: 0.4),
                            destination: AnyView(CommunityChatView())
                        )
                        
                        NavigationMenuRow(
                            icon: "flag.2.crossed.fill",
                            title: "Group Challenges",
                            subtitle: "Team competitions",
                            color: Color(red: 0.9, green: 0.3, blue: 0.5),
                            destination: AnyView(GroupChallengesView())
                        )
                        
                        NavigationMenuRow(
                            icon: "share.circle.fill",
                            title: "Share Activity",
                            subtitle: "Post your workouts",
                            color: Color(red: 0.4, green: 0.5, blue: 0.9),
                            destination: AnyView(ShareActivityView())
                        )
                        
                        NavigationMenuRow(
                            icon: "camera.circle.fill",
                            title: "Social Feed",
                            subtitle: "See what friends are doing",
                            color: Color(red: 0.9, green: 0.4, blue: 0.7),
                            destination: AnyView(SocialFeedView())
                        )
                        
                        NavigationMenuRow(
                            icon: "person.3.fill",
                            title: "Training Groups",
                            subtitle: "Join workout communities",
                            color: Color(red: 0.5, green: 0.6, blue: 0.9),
                            destination: AnyView(TrainingGroupsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "medal.fill",
                            title: "Challenges",
                            subtitle: "Monthly fitness challenges",
                            color: Color(red: 1.0, green: 0.5, blue: 0.0),
                            destination: AnyView(ChallengesView())
                        )
                        
                        NavigationMenuRow(
                            icon: "heart.circle.fill",
                            title: "Activity Likes",
                            subtitle: "Your liked workouts",
                            color: Color(red: 1.0, green: 0.2, blue: 0.4),
                            destination: AnyView(ActivityLikesView())
                        )
                    }
                    
                    // Settings Section
                    CategorySection(title: "Settings") {
                        NavigationMenuRow(
                            icon: "person.circle.fill",
                            title: "Profile",
                            subtitle: "Edit your personal info",
                            color: Theme.primary,
                            destination: AnyView(ProfileSettingsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "paintbrush.fill",
                            title: "Appearance",
                            subtitle: "Themes & customization",
                            color: Theme.accent,
                            destination: AnyView(AppearanceSettingsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "bell.badge.fill",
                            title: "Notifications",
                            subtitle: "Manage your alerts",
                            color: Theme.rose,
                            destination: AnyView(NotificationSettingsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "lock.shield.fill",
                            title: "Privacy & Security",
                            subtitle: "Keep your data safe",
                            color: Color(red: 0.2, green: 0.6, blue: 0.9),
                            destination: AnyView(PrivacySettingsView())
                        )
                        
                        NavigationMenuRow(
                            icon: "arrow.clockwise.circle.fill",
                            title: "Backup & Sync",
                            subtitle: "Cloud backup & device sync",
                            color: Color(red: 0.3, green: 0.7, blue: 0.5),
                            destination: AnyView(BackupSyncView())
                        )
                        
                        NavigationMenuRow(
                            icon: "globe",
                            title: "Language & Region",
                            subtitle: "App language & units",
                            color: Color(red: 0.5, green: 0.5, blue: 0.9),
                            destination: AnyView(LanguageRegionView())
                        )
                        
                        NavigationMenuRow(
                            icon: "link.circle.fill",
                            title: "Connected Apps",
                            subtitle: "Strava, Garmin & more",
                            color: Color(red: 0.9, green: 0.4, blue: 0.6),
                            destination: AnyView(ConnectedAppsView())
                        )
                    }
                    
                    // Support Section
                    CategorySection(title: "Support") {
                        NavigationMenuRow(
                            icon: "questionmark.circle.fill",
                            title: "Help Center",
                            subtitle: "FAQs and guides",
                            color: .orange,
                            destination: AnyView(HelpCenterView())
                        )
                        
                        NavigationMenuRow(
                            icon: "envelope.fill",
                            title: "Contact Us",
                            subtitle: "Get in touch with support",
                            color: .blue,
                            destination: AnyView(ContactSupportView())
                        )
                        
                        NavigationMenuRow(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Share your feedback",
                            color: Color(red: 1.0, green: 0.8, blue: 0.0),
                            destination: AnyView(RateAppView())
                        )
                        
                        NavigationMenuRow(
                            icon: "megaphone.fill",
                            title: "What's New",
                            subtitle: "Latest features & updates",
                            color: Color(red: 0.4, green: 0.7, blue: 0.9),
                            destination: AnyView(WhatsNewView())
                        )
                        
                        NavigationMenuRow(
                            icon: "info.circle.fill",
                            title: "About",
                            subtitle: "App version & credits",
                            color: Color(red: 0.6, green: 0.6, blue: 0.6),
                            destination: AnyView(AboutView())
                        )
                        
                        NavigationMenuRow(
                            icon: "ladybug.fill",
                            title: "Report Bug",
                            subtitle: "Help us improve the app",
                            color: .red,
                            destination: AnyView(ReportBugView())
                        )
                    }
                    
                    // Sign Out Button
                    Button {
                        showSignOutConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Sign Out")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    // Debug: Reset to Onboarding (for testing)
                    #if DEBUG
                    Button {
                        withAnimation {
                            // Reset onboarding
                            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                            NotificationCenter.default.post(name: NSNotification.Name("ResetToOnboarding"), object: nil)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise.circle")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Reset to Onboarding (Debug)")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.orange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    #endif
                    
                    Color.clear.frame(height: 40)
                }
                .padding(.bottom, 20)
            }
            .background(Theme.pageBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        quickDestination = .alerts
                    } label: {
                        Label("Notifications", systemImage: "bell.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.blue)
                            .labelStyle(.iconOnly)
                    }
                    .overlay(alignment: .topTrailing) {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 4, y: -4)
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // Search through settings
                    Button {
                        quickDestination = .search
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundStyle(.secondary)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Settings
                    Button {
                        quickDestination = .theme
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .font(.system(size: 20))
                            .foregroundStyle(.gray)
                            .labelStyle(.iconOnly)
                    }
                    
                    // Edit profile
                    NavigationLink {
                        ProfileSettingsView()
                    } label: {
                        Label("Edit Profile", systemImage: "pencil.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.primary)
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .fullScreenCover(item: $quickDestination) { destination in
                ProfileQuickDestinationView(destination: destination)
            }
            .confirmationDialog(
                "Are you sure you want to sign out?",
                isPresented: $showSignOutConfirmation,
                titleVisibility: .visible
            ) {
                Button("Sign Out", role: .destructive) {
                    withAnimation {
                        AuthManager.shared.signOut()
                        UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                        NotificationCenter.default.post(name: .showSignIn, object: nil)
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }.appPageTheme()
    }
    
    private func quickSettingLabel(
        icon: String,
        title: LocalizedStringKey,
        detail: LocalizedStringKey,
        color: Color
    ) -> some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(
                    LinearGradient(
                        colors: [color, color.opacity(0.72)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
                .shadow(color: color.opacity(0.25), radius: 4, y: 2)
            
            VStack(spacing: 1) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(.black)
                    .lineLimit(1)
                
                Text(detail)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(.black.opacity(0.68))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 88)
        .contentShape(Rectangle())
        .background(color.opacity(0.07))
        .accessibilityElement(children: .combine)
    }
}

private enum ProfileQuickDestination: String, Identifiable {
    case theme
    case premium
    case editProfile
    case alerts
    case search

    var id: String { rawValue }
}

private struct ProfileQuickDestinationView: View {
    let destination: ProfileQuickDestination
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            destinationContent
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Label("Close", systemImage: "xmark.circle.fill")
                        }
                        .foregroundStyle(Theme.primary)
                    }
                }
        }
        .appPageTheme()
    }

    @ViewBuilder
    private var destinationContent: some View {
        switch destination {
        case .theme:
            AppearanceSettingsView()
        case .premium:
            PremiumMembershipView()
        case .editProfile:
            ProfileSettingsView()
        case .alerts:
            NotificationSettingsView()
        case .search:
            ProfileSettingsSearchView()
        }
    }
}

private struct ProfileSettingsSearchView: View {
    @State private var query = ""

    var body: some View {
        List {
            if matches("Profile personal information edit account") {
                NavigationLink("Profile") { ProfileSettingsView() }
            }
            if matches("Appearance theme style dark mode") {
                NavigationLink("Appearance") { AppearanceSettingsView() }
            }
            if matches("Notifications alerts reminders") {
                NavigationLink("Notifications") { NotificationSettingsView() }
            }
            if matches("Privacy security data") {
                NavigationLink("Privacy & Security") { PrivacySettingsView() }
            }
            if matches("Backup sync cloud") {
                NavigationLink("Backup & Sync") { BackupSyncView() }
            }
        }
        .navigationTitle("Search Settings")
        .searchable(text: $query, prompt: "Search settings")
    }

    private func matches(_ keywords: String) -> Bool {
        query.isEmpty || keywords.localizedCaseInsensitiveContains(query)
    }
}

// MARK: - Helper Views

struct SectionHeader: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Theme.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text(subtitle)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - View Modifiers
// glassCard modifier is defined in Theme.swift

// MARK: - Category Section
struct CategorySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Navigation Menu Row
struct NavigationMenuRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var action: (() -> Void)? = nil
    var destination: AnyView? = nil
    
    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink {
                    MoreFullScreenDestination(destination: destination)
                } label: {
                    rowContent
                }
            } else {
                Button {
                    action?()
                } label: {
                    rowContent
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var rowContent: some View {
        HStack(spacing: 14) {
            // Icon with colored background
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color)
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // Text content
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.black)
                
                Text(subtitle)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.black.opacity(0.68))
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black.opacity(0.55))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Theme.surface)
    }
}

private struct MoreFullScreenDestination: View {
    let destination: AnyView
    
    var body: some View {
        ZStack(alignment: .top) {
            PaperBackground()
                .ignoresSafeArea()
            
            destination
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appPageTheme()
    }
}

// MARK: - Display Settings Section
struct DisplaySettingsSection: View {
    @ObservedObject var store: ProfileStore
    @State private var textSize: Double = 1.0
    @State private var showLabels: Bool = true
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            SectionHeader(title: "Display", subtitle: "Customize your viewing experience", icon: "textformat.size")
            
            VStack(spacing: isIPad ? 14 : 12) {
                // Compact Mode Toggle
                HStack {
                    Image(systemName: "rectangle.compress.vertical")
                        .font(.system(size: isIPad ? 16 : 14))
                        .foregroundStyle(Theme.primary)
                        .frame(width: isIPad ? 32 : 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Compact mode")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                        Text("Show more content at once")
                            .font(.system(size: isIPad ? 14 : 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $store.compactMode)
                        .labelsHidden()
                }
                
                Divider()
                
                // Icon Labels Toggle
                HStack {
                    Image(systemName: "character.cursor.ibeam")
                        .font(.system(size: isIPad ? 16 : 14))
                        .foregroundStyle(Theme.primary)
                        .frame(width: isIPad ? 32 : 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Show icon labels")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                        Text("Display text below icons")
                            .font(.system(size: isIPad ? 14 : 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $showLabels)
                        .labelsHidden()
                }
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
}

// MARK: - Data Insights Section
struct DataInsightsSection: View {
    @State private var showStats = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            SectionHeader(title: "Data & Insights", subtitle: "Your activity at a glance", icon: "chart.bar.doc.horizontal")
            
            VStack(spacing: isIPad ? 12 : 10) {
                StatRow(icon: "calendar.badge.checkmark", title: "Streak", value: "7 days", color: Theme.accent)
                StatRow(icon: "checkmark.circle.fill", title: "Total entries", value: "142", color: Theme.primary)
                StatRow(icon: "chart.line.uptrend.xyaxis", title: "This month", value: "28", color: Theme.rose)
            }
            
            Button {
                showStats = true
            } label: {
                HStack {
                    Text("View detailed statistics")
                        .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
                }
                .foregroundStyle(Theme.primary)
                .padding(.top, isIPad ? 8 : 6)
            }
            .buttonStyle(.plain)
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
        .sheet(isPresented: $showStats) {
            Text("Detailed Statistics View")
                .font(.title)
                .presentationDetents([.large])
        }
    }
}

private struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        HStack(spacing: isIPad ? 14 : 12) {
            Image(systemName: icon)
                .font(.system(size: isIPad ? 18 : 16))
                .foregroundStyle(color)
                .frame(width: isIPad ? 32 : 28)
            
            Text(title)
                .font(.system(size: isIPad ? 16 : 14, design: .rounded))
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: isIPad ? 18 : 16, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
    }
}

// MARK: - Export Data Section
struct ExportDataSection: View {
    @State private var showExportOptions = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            SectionHeader(title: "Export & Backup", subtitle: "Download your data", icon: "square.and.arrow.up")
            
            VStack(spacing: isIPad ? 12 : 10) {
                ExportButton(
                    icon: "doc.text",
                    title: "Export as PDF",
                    subtitle: "Download all entries as PDF",
                    color: .red
                ) {
                    // Export logic
                }
                
                ExportButton(
                    icon: "tablecells",
                    title: "Export as CSV",
                    subtitle: "Data for spreadsheets",
                    color: .green
                ) {
                    // Export logic
                }
                
                ExportButton(
                    icon: "doc.badge.gearshape",
                    title: "Export as JSON",
                    subtitle: "Raw data format",
                    color: .blue
                ) {
                    // Export logic
                }
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
}

private struct ExportButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: isIPad ? 14 : 12) {
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 18 : 16))
                    .foregroundStyle(color)
                    .frame(width: isIPad ? 32 : 28)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.system(size: isIPad ? 14 : 12, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Reminders Section
struct RemindersSection: View {
    @ObservedObject var store: ProfileStore
    @State private var dailyReminderTime = Date()
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            SectionHeader(title: "Reminders", subtitle: "Stay consistent with gentle nudges", icon: "bell.badge")
            
            VStack(spacing: isIPad ? 14 : 12) {
                HStack {
                    Image(systemName: "sunrise")
                        .font(.system(size: isIPad ? 16 : 14))
                        .foregroundStyle(Theme.accent)
                        .frame(width: isIPad ? 32 : 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Morning briefing")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                        Text("\(store.morningNotifHour):00")
                            .font(.system(size: isIPad ? 14 : 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $store.morningBriefing)
                        .labelsHidden()
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "moon.stars")
                        .font(.system(size: isIPad ? 16 : 14))
                        .foregroundStyle(Theme.primary)
                        .frame(width: isIPad ? 32 : 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Evening review")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                        Text("\(store.eveningNotifHour):00")
                            .font(.system(size: isIPad ? 14 : 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $store.eveningReview)
                        .labelsHidden()
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: isIPad ? 16 : 14))
                        .foregroundStyle(Theme.rose)
                        .frame(width: isIPad ? 32 : 28)
                    
                    Text("Habit reminders")
                        .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                    
                    Spacer()
                    
                    Toggle("", isOn: $store.habitReminders)
                        .labelsHidden()
                }
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
}

// MARK: - Privacy & Security Section
struct PrivacySecuritySection: View {
    @ObservedObject var store: ProfileStore
    @State private var biometricEnabled = false
    @State private var hideInAppSwitcher = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            SectionHeader(title: "Privacy & Security", subtitle: "Keep your data safe", icon: "lock.shield")
            
            VStack(spacing: isIPad ? 14 : 12) {
                HStack {
                    Image(systemName: "faceid")
                        .font(.system(size: isIPad ? 16 : 14))
                        .foregroundStyle(Theme.primary)
                        .frame(width: isIPad ? 32 : 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Biometric lock")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                        Text("Require Face ID to open")
                            .font(.system(size: isIPad ? 14 : 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $biometricEnabled)
                        .labelsHidden()
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "eye.slash")
                        .font(.system(size: isIPad ? 16 : 14))
                        .foregroundStyle(Theme.primary)
                        .frame(width: isIPad ? 32 : 28)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hide in app switcher")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                        Text("Blur content when multitasking")
                            .font(.system(size: isIPad ? 14 : 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $hideInAppSwitcher)
                        .labelsHidden()
                }
                
                Divider()
                
                Button {
                    // Privacy policy action
                } label: {
                    HStack {
                        Image(systemName: "hand.raised")
                            .font(.system(size: isIPad ? 16 : 14))
                            .foregroundStyle(Theme.primary)
                            .frame(width: isIPad ? 32 : 28)
                        
                        Text("Privacy policy")
                            .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
}

// MARK: - Help & Support Section
struct HelpSupportSection: View {
    @State private var showFAQ = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            SectionHeader(title: "Help & Support", subtitle: "We're here to help", icon: "questionmark.circle")
            
            VStack(spacing: isIPad ? 12 : 10) {
                HelpButton(
                    icon: "book.circle",
                    title: "User guide",
                    color: Theme.primary
                ) {
                    // User guide action
                }
                
                HelpButton(
                    icon: "bubble.left.and.bubble.right",
                    title: "Contact support",
                    color: Theme.accent
                ) {
                    // Contact support action
                }
                
                HelpButton(
                    icon: "star.bubble",
                    title: "Rate the app",
                    color: Theme.rose
                ) {
                    // Rate app action
                }
                
                HelpButton(
                    icon: "square.and.pencil",
                    title: "Send feedback",
                    color: .blue
                ) {
                    // Feedback action
                }
            }
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
}

private struct HelpButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: isIPad ? 14 : 12) {
                Image(systemName: icon)
                    .font(.system(size: isIPad ? 18 : 16))
                    .foregroundStyle(color)
                    .frame(width: isIPad ? 32 : 28)
                
                Text(title)
                    .font(.system(size: isIPad ? 16 : 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Account Section with Sign Out
struct AccountSection: View {
    @Binding var showSignOutConfirmation: Bool
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var isGuest: Bool {
        UserDefaults.standard.bool(forKey: "isGuestUser")
    }
    
    private var currentEmail: String? {
        UserDefaults.standard.string(forKey: "userEmail")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: isIPad ? 20 : 12) {
            SectionHeader(
                title: "Account",
                subtitle: accountSubtitle,
                icon: "person.crop.circle"
            )
            
            Button {
                showSignOutConfirmation = true
            } label: {
                HStack(spacing: isIPad ? 16 : 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: isIPad ? 18 : 14, weight: .semibold))
                        .foregroundStyle(.red)
                        .frame(width: isIPad ? 42 : 30, height: isIPad ? 42 : 30)
                        .background(Circle().fill(Color.red.opacity(0.12)))
                    
                    VStack(alignment: .leading, spacing: isIPad ? 4 : 2) {
                        Text("Sign Out")
                            .font(.system(size: isIPad ? 18 : 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primary)
                        Text("Log out of your account")
                            .font(.system(size: isIPad ? 16 : 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: isIPad ? 16 : 12, weight: .semibold))
                        .foregroundStyle(.tertiary)
                }
                .padding(.vertical, isIPad ? 14 : 10)
            }
            .buttonStyle(.plain)
        }
        .padding(isIPad ? 20 : 16)
        .glassCard(cornerRadius: isIPad ? 26 : 22)
    }
    
    private var accountSubtitle: String {
        if isGuest {
            return "Signed in as Guest"
        } else if let email = currentEmail {
            return email
        } else {
            return "Manage your account"
        }
    }
}

// MARK: - Flash Cards View
struct FlashCardsView: View {
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var dragOffset: CGSize = .zero
    
    private let motivationalCards: [(front: String, back: String, color: Color)] = [
        ("💪", "You are stronger than you think. Every challenge is an opportunity to grow.", .orange),
        ("🎯", "Focus on progress, not perfection. Small steps lead to big changes.", .blue),
        ("🌟", "Believe in yourself. You have the power to achieve anything you set your mind to.", .purple),
        ("🔥", "Stay consistent. Success is the sum of small efforts repeated daily.", .red),
        ("🚀", "Dream big. Work hard. Stay focused. The sky is not the limit.", .green),
        ("❤️", "Take care of yourself. You can't pour from an empty cup.", .pink),
        ("⚡️", "Your energy is your greatest asset. Protect it, nurture it, use it wisely.", Color(red: 1.0, green: 0.8, blue: 0.0)),
        ("🌈", "After every storm comes a rainbow. Keep going, better days are ahead.", Color(red: 0.6, green: 0.4, blue: 0.9))
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [motivationalCards[currentIndex].color.opacity(0.2), motivationalCards[currentIndex].color.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<motivationalCards.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentIndex ? motivationalCards[currentIndex].color : Color.gray.opacity(0.3))
                            .frame(width: index == currentIndex ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentIndex)
                    }
                }
                .padding(.top, 20)
                
                // Flash Card
                ZStack {
                    // Card shadow
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.black.opacity(0.1))
                        .blur(radius: 20)
                        .offset(y: 10)
                    
                    // Card content
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.white)
                        .shadow(color: motivationalCards[currentIndex].color.opacity(0.3), radius: 20, y: 10)
                        .overlay {
                            VStack(spacing: 24) {
                                if !isFlipped {
                                    // Front: Emoji
                                    Text(motivationalCards[currentIndex].front)
                                        .font(.system(size: 120))
                                        .transition(.scale.combined(with: .opacity))
                                } else {
                                    // Back: Motivation text
                                    VStack(spacing: 16) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 40))
                                            .foregroundStyle(motivationalCards[currentIndex].color)
                                        
                                        Text(motivationalCards[currentIndex].back)
                                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                                            .multilineTextAlignment(.center)
                                            .foregroundStyle(.primary)
                                            .lineSpacing(6)
                                    }
                                    .padding(.horizontal, 32)
                                    .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .rotation3DEffect(
                            .degrees(isFlipped ? 180 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                }
                .frame(height: 500)
                .padding(.horizontal, 32)
                .offset(dragOffset)
                .rotationEffect(.degrees(Double(dragOffset.width) / 20))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation
                        }
                        .onEnded { gesture in
                            if abs(gesture.translation.width) > 100 {
                                // Swipe detected
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if gesture.translation.width > 0 {
                                        previousCard()
                                    } else {
                                        nextCard()
                                    }
                                }
                            }
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                dragOffset = .zero
                            }
                        }
                )
                
                // Tap to flip hint
                Text(isFlipped ? "Tap to see emoji" : "Tap to reveal message")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isFlipped.toggle()
                        }
                    }
                
                Spacer()
                
                // Navigation buttons
                HStack(spacing: 20) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            previousCard()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(motivationalCards[currentIndex].color)
                            .clipShape(Circle())
                            .shadow(color: motivationalCards[currentIndex].color.opacity(0.4), radius: 10, y: 5)
                    }
                    .disabled(currentIndex == 0)
                    .opacity(currentIndex == 0 ? 0.4 : 1)
                    
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            nextCard()
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 60)
                            .background(motivationalCards[currentIndex].color)
                            .clipShape(Circle())
                            .shadow(color: motivationalCards[currentIndex].color.opacity(0.4), radius: 10, y: 5)
                    }
                    .disabled(currentIndex == motivationalCards.count - 1)
                    .opacity(currentIndex == motivationalCards.count - 1 ? 0.4 : 1)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Flash Cards")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func nextCard() {
        if currentIndex < motivationalCards.count - 1 {
            isFlipped = false
            currentIndex += 1
        }
    }
    
    private func previousCard() {
        if currentIndex > 0 {
            isFlipped = false
            currentIndex -= 1
        }
    }
}

// MARK: - Training Views
// Note: SportsTrackingView is defined in SportsTrackingView.swift
// Note: TrainingLogView is defined in TrainingLogView.swift
// Note: RaceEventsView is defined in RaceEventsView.swift
// Note: RaceCalendarView is defined in RaceCalendarView.swift

// MARK: - Health & Wellness Views

// NutritionView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// SleepTrackerView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// BodyMetricsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)



struct SupplementsView: View {
    var body: some View {
        EmptyStateView(
            icon: "pills.fill",
            title: "Supplements & Vitamins",
            subtitle: "Log and track your daily supplement intake",
            color: Color(red: 0.9, green: 0.6, blue: 0.2)
        )
        .navigationTitle("Supplements")
    }
}

struct InjuryLogView: View {
    var body: some View {
        EmptyStateView(
            icon: "cross.case.fill",
            title: "Injury Log",
            subtitle: "Track injuries, treatments, and recovery progress",
            color: .red
        )
        .navigationTitle("Injury Log")
    }
}

struct WellnessScoreView: View {
    var body: some View {
        EmptyStateView(
            icon: "leaf.fill",
            title: "Wellness Score",
            subtitle: "Your overall health and fitness rating",
            color: Color(red: 0.3, green: 0.8, blue: 0.5)
        )
        .navigationTitle("Wellness Score")
    }
}

// MARK: - Motivation & Learning Views

struct DailyQuotesView: View {
    private let quotes = [
        "The only way to do great work is to love what you do. - Steve Jobs",
        "Believe you can and you're halfway there. - Theodore Roosevelt",
        "Success is not final, failure is not fatal. - Winston Churchill",
        "The future belongs to those who believe in their dreams. - Eleanor Roosevelt"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(quotes.indices, id: \.self) { index in
                    VStack(spacing: 12) {
                        Image(systemName: "quote.bubble.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(Color(red: 0.9, green: 0.3, blue: 0.5))
                        
                        Text(quotes[index])
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.vertical, 32)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding()
        }
        .navigationTitle("Daily Quotes")
    }
}

struct AffirmationsView: View {
    private let affirmations = [
        "I am capable of achieving my goals",
        "I choose to be happy and positive today",
        "I am worthy of love and respect",
        "Every day I am getting better and stronger"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(affirmations.indices, id: \.self) { index in
                    HStack {
                        Image(systemName: "sparkles")
                            .font(.system(size: 24))
                            .foregroundStyle(Color(red: 0.6, green: 0.4, blue: 0.9))
                        
                        Text(affirmations[index])
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
        }
        .navigationTitle("Affirmations")
    }
}

struct LearningDecksView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                EmptyStateView(
                    icon: "brain.head.profile",
                    title: "Learning Decks",
                    subtitle: "Create custom decks to study anything",
                    color: Color(red: 0.2, green: 0.7, blue: 0.9)
                )
            }
            .padding()
        }
        .navigationTitle("Learning Decks")
        .toolbar {
            Button("New Deck") {
                // Create deck
            }
        }
    }
}

// MARK: - Settings Views

struct ProfileSettingsView: View {
    @ObservedObject private var store: ProfileStore = .shared
    
    var body: some View {
        Form {
            Section("Personal Information") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(store.name)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Avatar")
                    Spacer()
                    Text(store.avatarEmoji)
                        .font(.system(size: 28))
                }
            }
            
            Section("About") {
                HStack {
                    Text("Tagline")
                    Spacer()
                    Text(store.tagline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }.appPageTheme()
        .navigationTitle("Profile")
    }
}

struct AppearanceSettingsView: View {
    @ObservedObject private var store: ProfileStore = .shared
    
    var body: some View {
        Form {
            Section("Display") {
                Toggle("Compact Mode", isOn: $store.compactMode)
                Toggle("Haptic Feedback", isOn: $store.haptics)
            }
            
            Section("Theme") {
                HStack {
                    Text("Current Theme")
                    Spacer()
                    Text(store.appThemeRaw)
                        .foregroundStyle(.secondary)
                }
            }
        }.appPageTheme()
        .navigationTitle("Appearance")
    }
}

struct NotificationSettingsView: View {
    @ObservedObject private var store: ProfileStore = .shared
    
    var body: some View {
        Form {
            Section("Daily Notifications") {
                Toggle("Morning Briefing", isOn: $store.morningBriefing)
                if store.morningBriefing {
                    HStack {
                        Text("Time")
                        Spacer()
                        Text("\(store.morningNotifHour):00")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Toggle("Evening Review", isOn: $store.eveningReview)
                if store.eveningReview {
                    HStack {
                        Text("Time")
                        Spacer()
                        Text("\(store.eveningNotifHour):00")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section("Reminders") {
                Toggle("Habit Reminders", isOn: $store.habitReminders)
                Toggle("Focus Alerts", isOn: $store.focusAlerts)
                Toggle("AI Insights", isOn: $store.aiInsights)
                Toggle("Weekly Report", isOn: $store.weeklyReport)
            }
        }.appPageTheme()
        .navigationTitle("Notifications")
    }
}

// PrivacySettingsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift or MissingViewStubs 2.swift)

// MARK: - Support Views

struct HelpCenterView: View {
    private let faqs = [
        ("How do I track my workouts?", "Go to Training Log and tap the + button..."),
        ("Can I export my data?", "Yes! Go to Settings > Export Data..."),
        ("How do I change my theme?", "Visit Settings > Appearance..."),
        ("Is my data private?", "Yes, all data is encrypted and stored locally...")
    ]
    
    var body: some View {
        List {
            Section("Frequently Asked Questions") {
                ForEach(faqs.indices, id: \.self) { index in
                    DisclosureGroup {
                        Text(faqs[index].1)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 8)
                    } label: {
                        Text(faqs[index].0)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                    }
                }
            }
        }.appPageTheme()
        .navigationTitle("Help Center")
    }
}

struct ContactSupportView: View {
    @State private var subject = ""
    @State private var message = ""
    
    var body: some View {
        Form {
            Section("Contact Information") {
                HStack {
                    Text("Email")
                    Spacer()
                    Text("support@racetrian.com")
                        .foregroundStyle(.blue)
                }
            }
            
            Section("Send Message") {
                TextField("Subject", text: $subject)
                TextEditor(text: $message)
                    .frame(height: 150)
                
                Button("Send Message") {
                    // Send message
                }
            }
        }.appPageTheme()
        .navigationTitle("Contact Us")
    }
}

struct RateAppView: View {
    @State private var rating = 0
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color(red: 1.0, green: 0.8, blue: 0.0))
            
            Text("Rate RaceTrian")
                .font(.system(size: 28, weight: .bold, design: .rounded))
            
            Text("Help us improve by sharing your feedback")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        rating = star
                    } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 40))
                            .foregroundStyle(Color(red: 1.0, green: 0.8, blue: 0.0))
                    }
                }
            }
            
            if rating > 0 {
                Button("Submit Rating") {
                    // Submit rating
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.primary)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Rate App")
    }
}

// MARK: - Helper Views
// EmptyStateView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// SportActivity is defined in SportsModels.swift

// MARK: - New Training Feature Views

// TrainingCalendarView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// IntervalTrainingView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// RecoveryTrackerView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

struct PersonalCoachView: View {
    var body: some View {
        TrainingFeatureDashboard(
            title: "Personal Coach",
            subtitle: "Build a focused session from your current goal",
            icon: "person.fill.checkmark",
            color: Theme.rose,
            focusItems: ["Choose today's priority", "Complete the coached session", "Log effort and feedback"]
        )
    }
}

// TrainingGoalsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// ExerciseLibraryView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// WorkoutPlansView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

struct ZoneTrainingView: View {
    var body: some View {
        TrainingFeatureDashboard(
            title: "Zone Training",
            subtitle: "Use controlled intensity to train the right energy system",
            icon: "waveform.path.ecg",
            color: .pink,
            focusItems: ["Warm up in Zone 1", "Hold the target training zone", "Cool down below Zone 2"]
        )
    }
}

// MARK: - New Tracking Views

struct PaceAnalysisView: View {
    var body: some View {
        EmptyStateView(
            icon: "speedometer",
            title: "Pace Analysis",
            subtitle: "Track and analyze your running & cycling pace over time",
            color: Color(red: 0.1, green: 0.5, blue: 0.9)
        )
        .navigationTitle("Pace Analysis")
    }
}



struct HydrationLogView: View {
    var body: some View {
        EmptyStateView(
            icon: "drop.fill",
            title: "Hydration Log",
            subtitle: "Track your daily water intake and stay hydrated",
            color: Color(red: 0.2, green: 0.6, blue: 1.0)
        )
        .navigationTitle("Hydration")
    }
}

struct CardioStatsView: View {
    var body: some View {
        EmptyStateView(
            icon: "figure.mixed.cardio",
            title: "Cardio Stats",
            subtitle: "Comprehensive cardiovascular activity analytics",
            color: Color(red: 1.0, green: 0.4, blue: 0.0)
        )
        .navigationTitle("Cardio Stats")
    }
}

struct EnergyLevelsView: View {
    var body: some View {
        EmptyStateView(
            icon: "bolt.circle.fill",
            title: "Energy Levels",
            subtitle: "Log and track your daily energy and fatigue",
            color: Color(red: 1.0, green: 0.8, blue: 0.2)
        )
        .navigationTitle("Energy Levels")
    }
}

struct ElevationGainView: View {
    var body: some View {
        EmptyStateView(
            icon: "figure.stairs",
            title: "Elevation Gain",
            subtitle: "Track climbing, altitude, and vertical progress",
            color: Color(red: 0.5, green: 0.3, blue: 0.1)
        )
        .navigationTitle("Elevation Gain")
    }
}

struct RecoveryScoreView: View {
    var body: some View {
        EmptyStateView(
            icon: "bed.double.circle.fill",
            title: "Recovery Score",
            subtitle: "Overall recovery status based on sleep, HRV, and rest",
            color: Color(red: 0.4, green: 0.6, blue: 0.9)
        )
        .navigationTitle("Recovery Score")
    }
}

struct FlexibilityTrackerView: View {
    var body: some View {
        EmptyStateView(
            icon: "figure.flexibility",
            title: "Flexibility Tracker",
            subtitle: "Log stretching sessions and track mobility improvements",
            color: Color(red: 0.8, green: 0.4, blue: 0.7)
        )
        .navigationTitle("Flexibility")
    }
}

struct TrainingZonesView: View {
    var body: some View {
        EmptyStateView(
            icon: "thermometer.medium",
            title: "Training Zones",
            subtitle: "Analyze time spent in different power, pace, and HR zones",
            color: Color(red: 0.9, green: 0.5, blue: 0.3)
        )
        .navigationTitle("Training Zones")
    }
}

struct WeeklySummaryView: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.bar.doc.horizontal",
            title: "Weekly Summary",
            subtitle: "Complete overview of your weekly training and progress",
            color: Color(red: 0.3, green: 0.5, blue: 0.8)
        )
        .navigationTitle("Weekly Summary")
    }
}

struct BreathingExercisesView: View {
    var body: some View {
        EmptyStateView(
            icon: "lungs.fill",
            title: "Breathing Exercises",
            subtitle: "Guided breathing patterns for relaxation and focus",
            color: Color(red: 0.2, green: 0.7, blue: 0.8)
        )
        .navigationTitle("Breathing Exercises")
    }
}

struct YogaStretchingView: View {
    var body: some View {
        EmptyStateView(
            icon: "figure.yoga",
            title: "Yoga & Stretching",
            subtitle: "Guided flexibility and mobility routines",
            color: Color(red: 0.7, green: 0.5, blue: 0.9)
        )
        .navigationTitle("Yoga & Stretching")
    }
}

struct HealthTrendsView: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.line.uptrend.xyaxis.circle.fill",
            title: "Health Trends",
            subtitle: "Long-term health and wellness analytics",
            color: Color(red: 0.5, green: 0.8, blue: 0.4)
        )
        .navigationTitle("Health Trends")
    }
}

struct WorkoutTimerView: View {
    var body: some View {
        ThemedWorkoutTimerView()
    }
}

struct RunningCoachView: View {
    var body: some View {
        TrainingFeatureDashboard(
            title: "Running Coach",
            subtitle: "Improve endurance, pace, and running consistency",
            icon: "figure.run.circle.fill",
            color: Theme.primary,
            focusItems: ["Complete the running warm-up", "Run today's key session", "Log pace and effort"]
        )
    }
}

// MARK: - Motivation & Learning Additional Views

struct StudyGuidesView: View {
    var body: some View {
        EmptyStateView(
            icon: "book.fill",
            title: "Study Guides",
            subtitle: "Educational resources and study notes",
            color: Color(red: 0.8, green: 0.3, blue: 0.4)
        )
        .navigationTitle("Study Guides")
    }
}

struct AchievementsView: View {
    var body: some View {
        EmptyStateView(
            icon: "graduationcap.fill",
            title: "Achievements",
            subtitle: "Your earned badges and milestones",
            color: Color(red: 1.0, green: 0.7, blue: 0.2)
        )
        .navigationTitle("Achievements")
    }
}

struct StreaksChallengesView: View {
    var body: some View {
        EmptyStateView(
            icon: "flame.circle.fill",
            title: "Streaks & Challenges",
            subtitle: "Daily streaks and active competitions",
            color: Color(red: 1.0, green: 0.4, blue: 0.0)
        )
        .navigationTitle("Streaks & Challenges")
    }
}

// MARK: - Settings Additional Views

struct BackupSyncView: View {
    var body: some View {
        EmptyStateView(
            icon: "arrow.clockwise.circle.fill",
            title: "Backup & Sync",
            subtitle: "Cloud backup and device synchronization",
            color: Color(red: 0.3, green: 0.7, blue: 0.5)
        )
        .navigationTitle("Backup & Sync")
    }
}

struct LanguageRegionView: View {
    var body: some View {
        EmptyStateView(
            icon: "globe",
            title: "Language & Region",
            subtitle: "App language and measurement units",
            color: Color(red: 0.5, green: 0.5, blue: 0.9)
        )
        .navigationTitle("Language & Region")
    }
}

struct ConnectedAppsView: View {
    var body: some View {
        EmptyStateView(
            icon: "link.circle.fill",
            title: "Connected Apps",
            subtitle: "Strava, Garmin, Apple Health & more",
            color: Color(red: 0.9, green: 0.4, blue: 0.6)
        )
        .navigationTitle("Connected Apps")
    }
}

// MARK: - Support Additional Views

struct WhatsNewView: View {
    private let updates = [
        AppUpdateItem(
            title: "Race Vision Boards",
            date: "October 16, 2026",
            summary: "Create visual race goals, pin milestones, and start a fresh board whenever your target changes.",
            icon: "flag.checkered.2.crossed",
            color: Color.orange
        ),
        AppUpdateItem(
            title: "Smarter Training Plans",
            date: "October 15, 2026",
            summary: "Weekly, monthly, weekend, vacation, travel, and sport-specific plans now include guided planning tools.",
            icon: "sparkles",
            color: Color.purple
        ),
        AppUpdateItem(
            title: "Tracking Quick Actions",
            date: "October 16, 2026",
            summary: "Log workouts, meals, sleep, water, weight, heart rate, rides, swims, yoga, recovery, and personal records.",
            icon: "chart.xyaxis.line",
            color: Color.blue
        ),
        AppUpdateItem(
            title: "Expanded Feature Dashboards",
            date: "October 16, 2026",
            summary: "Health, learning, community, weather, nutrition, and performance pages now include useful interactive content.",
            icon: "rectangle.grid.2x2.fill",
            color: Color.green
        )
    ]

    var body: some View {
        ZStack {
            PaperBackground()

            ScrollView {
                LazyVStack(spacing: 16) {
                    VStack(spacing: 10) {
                        Image(systemName: "megaphone.fill")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(Color.blue.gradient, in: RoundedRectangle(cornerRadius: 22))
                        Text("Latest RaceTrian News")
                            .font(.title2.bold())
                            .foregroundStyle(.black)
                        Text("New tools and improvements added to your training experience.")
                            .font(.subheadline)
                            .foregroundStyle(.black.opacity(0.65))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(22)
                    .glassCard(cornerRadius: 22, tint: .blue)

                    ForEach(updates) { update in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: update.icon)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 46, height: 46)
                                    .background(update.color.gradient, in: RoundedRectangle(cornerRadius: 14))

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(update.title)
                                        .font(.headline)
                                        .foregroundStyle(.black)
                                    Text(update.date)
                                        .font(.caption)
                                        .foregroundStyle(.black.opacity(0.55))
                                }
                                Spacer()
                            }

                            Text(update.summary)
                                .font(.subheadline)
                                .foregroundStyle(.black.opacity(0.72))
                                .fixedSize(horizontal: false, vertical: true)

                            Label("New", systemImage: "sparkles")
                                .font(.caption.bold())
                                .foregroundStyle(update.color)
                        }
                        .padding(16)
                        .glassCard(cornerRadius: 18, tint: update.color)
                    }
                }
                .padding(18)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("What's New")
        .navigationBarTitleDisplayMode(.inline)
        .appPageTheme()
    }
}

private struct AppUpdateItem: Identifiable {
    let title: String
    let date: String
    let summary: String
    let icon: String
    let color: Color

    var id: String { title }
}

struct AboutView: View {
    var body: some View {
        EmptyStateView(
            icon: "info.circle.fill",
            title: "About",
            subtitle: "App version, credits, and information",
            color: Color(red: 0.6, green: 0.6, blue: 0.6)
        )
        .navigationTitle("About")
    }
}

struct ReportBugView: View {
    var body: some View {
        EmptyStateView(
            icon: "ladybug.fill",
            title: "Report Bug",
            subtitle: "Help us improve by reporting issues",
            color: .red
        )
        .navigationTitle("Report Bug")
    }
}

// MARK: - Community & Social Views
// Note: FriendsView and LeaderboardsView are defined elsewhere

struct CommunityChatView: View {
    var body: some View {
        EmptyStateView(
            icon: "bubble.left.and.bubble.right.fill",
            title: "Community Chat",
            subtitle: "Chat with other athletes and share tips",
            color: Color(red: 0.5, green: 0.8, blue: 0.4)
        )
        .navigationTitle("Community Chat")
    }
}

struct GroupChallengesView: View {
    var body: some View {
        EmptyStateView(
            icon: "flag.2.crossed.fill",
            title: "Group Challenges",
            subtitle: "Join team competitions and challenges",
            color: Color(red: 0.9, green: 0.3, blue: 0.5)
        )
        .navigationTitle("Group Challenges")
    }
}

struct ShareActivityView: View {
    var body: some View {
        EmptyStateView(
            icon: "share.circle.fill",
            title: "Share Activity",
            subtitle: "Post and share your workouts",
            color: Color(red: 0.4, green: 0.5, blue: 0.9)
        )
        .navigationTitle("Share Activity")
    }
}

// MARK: - Additional Motivation & Learning Views

struct TrainingArticlesView: View {
    var body: some View {
        EmptyStateView(
            icon: "newspaper.fill",
            title: "Training Articles",
            subtitle: "Expert tips and techniques",
            color: Color(red: 0.4, green: 0.6, blue: 0.8)
        )
        .navigationTitle("Training Articles")
    }
}

struct VideoTutorialsView: View {
    var body: some View {
        EmptyStateView(
            icon: "video.fill",
            title: "Video Tutorials",
            subtitle: "Learn proper form and technique",
            color: Color(red: 0.8, green: 0.2, blue: 0.5)
        )
        .navigationTitle("Video Tutorials")
    }
}

struct CommunityStoriesView: View {
    var body: some View {
        EmptyStateView(
            icon: "person.2.wave.2.fill",
            title: "Community Stories",
            subtitle: "Success stories and inspiration from athletes",
            color: Color(red: 0.3, green: 0.8, blue: 0.7)
        )
        .navigationTitle("Community Stories")
    }
}

// MARK: - Equipment & Gear Views
// ShoeTrackerView, BikeMaintenanceView, and DeviceSyncView are defined elsewhere.

// MARK: - Weather & Environment Views

struct WeatherForecastView: View {
    var body: some View {
        EmptyStateView(
            icon: "cloud.sun.fill",
            title: "Weather Forecast",
            subtitle: "Plan your workouts based on weather conditions",
            color: Color(red: 0.3, green: 0.6, blue: 1.0)
        )
        .navigationTitle("Weather Forecast")
    }
}

struct RoutePlannerView: View {
    var body: some View {
        EmptyStateView(
            icon: "map.fill",
            title: "Route Planner",
            subtitle: "Discover and plan new training routes",
            color: Color(red: 0.2, green: 0.8, blue: 0.4)
        )
        .navigationTitle("Route Planner")
    }
}

struct SavedLocationsView: View {
    var body: some View {
        EmptyStateView(
            icon: "location.circle.fill",
            title: "Saved Locations",
            subtitle: "Your favorite training spots",
            color: Color(red: 0.9, green: 0.3, blue: 0.3)
        )
        .navigationTitle("Saved Locations")
    }
}

struct SunriseSunsetView: View {
    var body: some View {
        EmptyStateView(
            icon: "sunrise.fill",
            title: "Sunrise/Sunset",
            subtitle: "Plan early morning or late evening workouts",
            color: Color(red: 1.0, green: 0.7, blue: 0.3)
        )
        .navigationTitle("Sunrise/Sunset")
    }
}

// MARK: - Premium & Advanced Views
// Note: PremiumMembershipView and AdvancedAnalyticsView are defined in UsersfatimahDesktopRaceTrianNewProfileView.swift

struct AITrainingPlansView: View {
    var body: some View {
        EmptyStateView(
            icon: "sparkles.rectangle.stack.fill",
            title: "AI Training Plans",
            subtitle: "Personalized AI-generated training programs",
            color: Color(red: 0.4, green: 0.8, blue: 0.9)
        )
        .navigationTitle("AI Training Plans")
    }
}

struct PerformanceInsightsView: View {
    var body: some View {
        EmptyStateView(
            icon: "brain.fill",
            title: "Performance Insights",
            subtitle: "AI-powered performance recommendations",
            color: Color(red: 0.8, green: 0.4, blue: 0.6)
        )
        .navigationTitle("Performance Insights")
    }
}

// MARK: - AI Coach View (Full Implementation)

struct VirtualCoachView: View {
    @State private var userMessage = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(role: .assistant, content: "Hi! I'm your AI coach. How can I help you with your training today?")
    ]
    @State private var isTyping = false
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages ScrollView
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                        
                        if isTyping {
                            HStack {
                                ThinkingBubble()
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20)
                }
                .onChange(of: messages.count) {
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Quick Actions
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    QuickActionButton(icon: "figure.run", title: "Running Tips") {
                        sendQuickMessage("Give me running tips")
                    }
                    QuickActionButton(icon: "dumbbell.fill", title: "Strength") {
                        sendQuickMessage("How to improve strength?")
                    }
                    QuickActionButton(icon: "heart.fill", title: "Recovery") {
                        sendQuickMessage("Recovery advice")
                    }
                    QuickActionButton(icon: "fork.knife", title: "Nutrition") {
                        sendQuickMessage("Nutrition tips for athletes")
                    }
                    QuickActionButton(icon: "calendar", title: "Plan Week") {
                        sendQuickMessage("Create a weekly training plan")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Theme.pageBackground)
            
            // Input Bar
            HStack(spacing: 12) {
                TextField("Ask your coach anything...", text: $userMessage, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .focused($isInputFocused)
                    .lineLimit(1...4)
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: userMessage.isEmpty ? "mic.fill" : "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(userMessage.isEmpty ? .secondary : Color(red: 0.3, green: 0.7, blue: 0.5))
                }
                .disabled(userMessage.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Theme.pageBackground)
        }
        .background(Theme.pageBackground)
        .navigationTitle("AI Coach")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Settings or info
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !userMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let message = ChatMessage(role: .user, content: userMessage)
        messages.append(message)
        userMessage = ""
        isInputFocused = false
        
        // Simulate AI response
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            let response = generateAIResponse(for: message.content)
            messages.append(response)
        }
    }
    
    private func sendQuickMessage(_ text: String) {
        userMessage = text
        sendMessage()
    }
    
    private func generateAIResponse(for question: String) -> ChatMessage {
        let lowercased = question.lowercased()
        var response = ""
        
        if lowercased.contains("running") || lowercased.contains("run") {
            response = "Great question about running! Here are some key tips:\n\n• Start with a proper warm-up (5-10 min easy jog)\n• Focus on form: land midfoot, keep shoulders relaxed\n• Follow the 10% rule: increase weekly mileage by max 10%\n• Include rest days for recovery\n• Mix up your training with intervals and tempo runs\n\nWhat's your current running level?"
        } else if lowercased.contains("strength") || lowercased.contains("lifting") {
            response = "Building strength is crucial for athletic performance! Here's my advice:\n\n💪 Focus on compound movements:\n• Squats\n• Deadlifts\n• Bench press\n• Pull-ups\n• Overhead press\n\nAim for 3-4 sessions per week with progressive overload. Would you like a specific program?"
        } else if lowercased.contains("recovery") || lowercased.contains("rest") {
            response = "Recovery is just as important as training! Here's what you should focus on:\n\n🛌 Sleep: 7-9 hours per night\n💧 Hydration: 3-4 liters daily\n🍽️ Nutrition: Protein-rich meals\n🧘 Active recovery: Light stretching, yoga\n❄️ Ice baths: 10-15 min post-workout\n\nRemember: muscles grow during rest, not during training!"
        } else if lowercased.contains("nutrition") || lowercased.contains("diet") || lowercased.contains("food") {
            response = "Nutrition fuels your performance! Key principles:\n\n🥗 Macros for athletes:\n• Protein: 1.6-2.2g per kg bodyweight\n• Carbs: 4-7g per kg (based on activity)\n• Fats: 0.8-1g per kg\n\n⏰ Timing matters:\n• Pre-workout: Carbs 1-2 hours before\n• Post-workout: Protein + carbs within 30 min\n\nStay consistent and track your intake!"
        } else if lowercased.contains("plan") || lowercased.contains("schedule") || lowercased.contains("week") {
            response = "Here's a balanced weekly training plan:\n\n📅 Weekly Structure:\nMon: Strength Training (Upper)\nTue: Cardio/Running (Tempo)\nWed: Strength Training (Lower)\nThu: Active Recovery (Yoga/Stretch)\nFri: HIIT/Intervals\nSat: Long Run/Endurance\nSun: Complete Rest\n\nAdjust based on your goals and fitness level!"
        } else {
            response = "That's a great question! As your AI coach, I'm here to help with:\n\n• Training plans & programs\n• Running & cardio advice\n• Strength training tips\n• Recovery strategies\n• Nutrition guidance\n• Race preparation\n• Injury prevention\n\nWhat specific area would you like to focus on?"
        }
        
        return ChatMessage(role: .assistant, content: response)
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .foregroundStyle(Color(red: 0.3, green: 0.7, blue: 0.5))
            .frame(width: 80, height: 70)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Additional Tracking Views

struct SleepQualityView: View {
    var body: some View {
        EmptyStateView(
            icon: "moon.zzz.fill",
            title: "Sleep Quality",
            subtitle: "Detailed sleep analysis with REM, deep sleep & interruptions",
            color: Color(red: 0.5, green: 0.4, blue: 0.7)
        )
        .navigationTitle("Sleep Quality")
    }
}

struct ActivityRingsView: View {
    var body: some View {
        EmptyStateView(
            icon: "figure.walk.motion",
            title: "Activity Rings",
            subtitle: "Track your daily move, exercise, and stand goals",
            color: Color(red: 0.9, green: 0.2, blue: 0.4)
        )
        .navigationTitle("Activity Rings")
    }
}

struct SmartInsightsView: View {
    var body: some View {
        EmptyStateView(
            icon: "bolt.badge.automatic",
            title: "Smart Insights",
            subtitle: "AI-powered training recommendations based on your data",
            color: Color(red: 0.2, green: 0.8, blue: 0.9)
        )
        .navigationTitle("Smart Insights")
    }
}

// MARK: - Additional Training Views

struct SwimTrainingView: View {
    var body: some View {
        TrainingFeatureDashboard(
            title: "Swim Training",
            subtitle: "Develop technique, endurance, and open-water confidence",
            icon: "figure.swimming",
            color: .cyan,
            focusItems: ["Complete the technique warm-up", "Swim the main set", "Log distance and splits"]
        )
    }
}

struct CyclingCoachView: View {
    var body: some View {
        TrainingFeatureDashboard(
            title: "Cycling Coach",
            subtitle: "Plan indoor and outdoor rides with purposeful intensity",
            icon: "bicycle.circle.fill",
            color: Theme.secondary,
            focusItems: ["Check bike and equipment", "Complete today's ride", "Log distance and power"]
        )
    }
}

struct FunctionalTrainingView: View {
    var body: some View {
        TrainingFeatureDashboard(
            title: "Functional Training",
            subtitle: "Build strength, mobility, power, and work capacity",
            icon: "figure.martial.arts",
            color: Theme.rose,
            focusItems: ["Complete movement preparation", "Finish the strength circuit", "Log rounds and effort"]
        )
    }
}

// MARK: - Additional Health & Wellness Views

struct WaterIntakeView: View {
    var body: some View {
        EmptyStateView(
            icon: "drop.circle.fill",
            title: "Water Intake",
            subtitle: "Track daily hydration with smart reminders",
            color: Color(red: 0.2, green: 0.7, blue: 1.0)
        )
        .navigationTitle("Water Intake")
    }
}

struct MealPlanningView: View {
    var body: some View {
        EmptyStateView(
            icon: "carrot.fill",
            title: "Meal Planning",
            subtitle: "Weekly meal prep, shopping lists & healthy recipes",
            color: Color(red: 1.0, green: 0.6, blue: 0.0)
        )
        .navigationTitle("Meal Planning")
    }
}

struct MacroTrackerView: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.bar.fill",
            title: "Macro Tracker",
            subtitle: "Track protein, carbs, fats & calories",
            color: Color(red: 0.3, green: 0.7, blue: 0.4)
        )
        .navigationTitle("Macro Tracker")
    }
}

// MARK: - Additional Social Views

struct SocialFeedView: View {
    var body: some View {
        EmptyStateView(
            icon: "camera.circle.fill",
            title: "Social Feed",
            subtitle: "See workouts, achievements & updates from friends",
            color: Color(red: 0.9, green: 0.4, blue: 0.7)
        )
        .navigationTitle("Social Feed")
    }
}

struct TrainingGroupsView: View {
    var body: some View {
        EmptyStateView(
            icon: "person.3.fill",
            title: "Training Groups",
            subtitle: "Join and participate in workout communities",
            color: Color(red: 0.5, green: 0.6, blue: 0.9)
        )
        .navigationTitle("Training Groups")
    }
}

struct ChallengesView: View {
    var body: some View {
        EmptyStateView(
            icon: "medal.fill",
            title: "Challenges",
            subtitle: "Monthly fitness challenges and competitions",
            color: Color(red: 1.0, green: 0.5, blue: 0.0)
        )
        .navigationTitle("Challenges")
    }
}

struct ActivityLikesView: View {
    var body: some View {
        EmptyStateView(
            icon: "heart.circle.fill",
            title: "Activity Likes",
            subtitle: "Workouts and activities you've liked",
            color: Color(red: 1.0, green: 0.2, blue: 0.4)
        )
        .navigationTitle("Activity Likes")
    }
}

// MARK: - Community Views are defined above in the Additional Social Views section

// MARK: - Missing View Stubs (referenced in navigation)

// StepsCounterView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// CalorieTrackerView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// HeartRateMonitorView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// VO2MaxTrackerView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// BodyFatTrackerView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// WeightTrackingView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// MeasurementsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// MeditationView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// MentalHealthView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// ProgressChartsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// PerformanceTrackingView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// PersonalRecordsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// StrengthProgressView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// WorkoutDurationView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// DistanceTrackerView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// ActivityBreakdownView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// WorkoutLoggerView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// TrainingLogView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// TrainingTrackingView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// FriendsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// LeaderboardsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// ShoeTrackerView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// BikeMaintenanceView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)


// DeviceSyncView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// PremiumMembershipView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

// AdvancedAnalyticsView - removed to avoid duplicate definition (defined in MissingViewStubs.swift)

#Preview { ProfileView() }
#endif
