#if !os(watchOS)
import SwiftUI

struct DiaryView: View {
    @StateObject private var store = DiaryStore.shared
    @Environment(\.colorScheme) private var scheme
    @State private var searchText = ""
    @State private var selectedTab: DiaryTab = .all
    @State private var showNewEntry = false
    @State private var selectedEntry: DiaryEntry?

    enum DiaryTab: String, CaseIterable {
        case all = "All"
        case favorites = "Favourites"
        case insights = "Insights"
    }

    private var filtered: [DiaryEntry] {
        let base: [DiaryEntry]
        switch selectedTab {
        case .all:       base = store.entries
        case .favorites: base = store.entries.filter(\.isFavorite)
        case .insights:  return []
        }
        guard !searchText.isEmpty else { return base }
        return base.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.body.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Theme.pageBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    tabBar
                    if selectedTab == .insights {
                        DiaryInsightsView()
                    } else {
                        entryList
                    }
                }

                addButton
            }
            .navigationTitle("My Diary")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search entries…")
            .sheet(isPresented: $showNewEntry) {
                DiaryEntryEditor(entry: nil)
            }
            .sheet(item: $selectedEntry) { entry in
                DiaryEntryEditor(entry: entry)
            }
        }.appPageTheme()
    }

    // MARK: - Tab Bar
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(DiaryTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3)) { selectedTab = tab }
                } label: {
                    Text(tab.rawValue)
                        .font(.system(size: 14, weight: selectedTab == tab ? .bold : .medium, design: .rounded))
                        .foregroundStyle(selectedTab == tab ? .white : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == tab ? Theme.primary : Color.clear)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }

    // MARK: - Entry List
    private var entryList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                if filtered.isEmpty {
                    emptyState
                } else {
                    ForEach(filtered) { entry in
                        DiaryEntryCard(entry: entry)
                            .onTapGesture { selectedEntry = entry }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Text("📖")
                .font(.system(size: 64))
            Text(selectedTab == .favorites ? "No favourites yet" : "Start your first entry")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            Text("Tap + to capture today's thoughts, feelings, and memories.")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 80)
        .padding(.horizontal, 40)
    }

    // MARK: - Add Button
    private var addButton: some View {
        Button {
            showNewEntry = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(Theme.heroGradient)
                .clipShape(Circle())
                .shadow(color: Theme.primary.opacity(0.45), radius: 12, y: 4)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 28)
    }
}
#endif


