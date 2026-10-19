//
//  CoachView_Watch.swift
//  Appwatch Watch App
//
//  Created for Watch App
//

import SwiftUI

struct CoachView: View {
    @State private var showComingSoon = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "message.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color(red: 0.3, green: 0.7, blue: 0.5))
                    .padding(.top, 20)
                
                Text("AI Coach")
                    .font(.headline)
                
                Text("Get personalized advice and guidance")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    showComingSoon = true
                } label: {
                    Text("Coming Soon")
                        .font(.footnote)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.3, green: 0.7, blue: 0.5))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.bottom, 20)
            }
            .navigationTitle("AI Coach")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Coming Soon", isPresented: $showComingSoon) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The AI Coach feature is coming to Apple Watch soon!")
            }
        }
    }
}

#Preview {
    CoachView()
}
