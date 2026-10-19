import SwiftUI

struct PlaceholderView: View {
    let title: String
    let subtitle: String
    let icon: String
    
    @State private var note = ""
    @State private var savedNotes: [PlaceholderNote] = []
    
    var body: some View {
        ZStack {
            PaperBackground()
            
            ScrollView {
                VStack(spacing: 18) {
                    PlaceholderHero(title: title, subtitle: subtitle, icon: icon)
                    PlaceholderStarterCard()
                    PlaceholderNotesCard(note: $note, savedNotes: $savedNotes)
                }
                .padding()
                .padding(.bottom, 24)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .appPageTheme()
    }
}

private struct PlaceholderNote: Identifiable {
    let id = UUID()
    let text: String
}

private struct PlaceholderHero: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 76, height: 76)
                .background(Theme.heroGradient, in: RoundedRectangle(cornerRadius: 22))
                .shadow(color: Theme.primary.opacity(0.25), radius: 12, y: 6)
            
            Text(title)
                .font(.title.bold())
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.body)
                .foregroundStyle(.black.opacity(0.68))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(22)
        .glassCard(cornerRadius: 24, tint: Theme.primary)
    }
}

private struct PlaceholderStarterCard: View {
    private let actions = [
        ("Choose a focus", "target"),
        ("Add your first update", "plus.circle.fill"),
        ("Review your progress", "chart.line.uptrend.xyaxis")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Get started")
                .font(.headline)
                .foregroundStyle(.black)
            
            ForEach(actions, id: \.0) { action in
                HStack(spacing: 12) {
                    Image(systemName: action.1)
                        .foregroundStyle(Theme.primary)
                        .frame(width: 28)
                    Text(action.0)
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(.black.opacity(0.35))
                }
                .padding(.vertical, 4)
            }
        }
        .padding(18)
        .glassCard(cornerRadius: 20, tint: Theme.accent)
    }
}

private struct PlaceholderNotesCard: View {
    @Binding var note: String
    @Binding var savedNotes: [PlaceholderNote]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick notes")
                .font(.headline)
                .foregroundStyle(.black)
            
            HStack {
                TextField("Add a note", text: $note)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
                    .submitLabel(.done)
                    .onSubmit(saveNote)
                
                Button(action: saveNote) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Theme.primary)
                }
                .disabled(note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityLabel("Save note")
            }
            
            ForEach(savedNotes) { savedNote in
                Label(savedNote.text, systemImage: "note.text")
                    .foregroundStyle(.black)
                    .padding(.top, 4)
            }
        }
        .padding(18)
        .glassCard(cornerRadius: 20, tint: Theme.secondary)
    }
    
    private func saveNote() {
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNote.isEmpty else { return }
        savedNotes.insert(PlaceholderNote(text: trimmedNote), at: 0)
        note = ""
    }
}

#Preview {
    NavigationStack {
        PlaceholderView(
            title: "Plan",
            subtitle: "Your week, beautifully arranged.",
            icon: "calendar"
        )
    }
}
