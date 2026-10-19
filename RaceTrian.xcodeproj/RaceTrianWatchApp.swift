//
//  RaceTrianWatchApp.swift
//  RaceTrian Watch
//
//  Created by Fatimah on 20/08/2026.
//

import SwiftUI

@main
struct RaceTrianWatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchMainView()
        }
    }
}

struct WatchMainView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "figure.run")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
                
                Text("RaceTrian")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Apple Watch")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("RaceTrian")
        }
    }
}

#Preview {
    WatchMainView()
}
