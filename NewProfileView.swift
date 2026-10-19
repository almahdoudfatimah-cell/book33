//
//  NewProfileView.swift
//  RaceTrian
//
//  Replacement for corrupted filename
//

import SwiftUI

struct NewProfileView: View {
    @StateObject private var profileStore = ProfileStore.shared
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue.gradient)
                        
                        VStack(alignment: .leading) {
                            Text(profileStore.userName.isEmpty ? "Set Your Name" : profileStore.userName)
                                .font(.title2.bold())
                            
                            if let email = profileStore.userEmail {
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Profile") {
                    Button {
                        isEditingProfile = true
                    } label: {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                }
                
                Section("Training") {
                    NavigationLink {
                        TrainingLogView()
                    } label: {
                        Label("Training Log", systemImage: "figure.run")
                    }
                    
                    NavigationLink {
                        AssessmentView()
                    } label: {
                        Label("Assessments", systemImage: "chart.line.uptrend.xyaxis")
                    }
                }
                
                Section("Settings") {
                    AppPreferencesSection()
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $isEditingProfile) {
                EditProfileSheet()
            }
        }
    }
}

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var profileStore = ProfileStore.shared
    @State private var name: String = ""
    @State private var email: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        profileStore.userName = name
                        profileStore.userEmail = email
                        dismiss()
                    }
                }
            }
            .onAppear {
                name = profileStore.userName
                email = profileStore.userEmail ?? ""
            }
        }
    }
}

#Preview {
    NewProfileView()
}
