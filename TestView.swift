//
//  SimpleTestView.swift
//  RaceTrian
//

import SwiftUI

struct SimpleTestView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Content Area
            ZStack {
                if selectedTab == 0 {
                    Color.red
                } else if selectedTab == 1 {
                    Color.green
                } else if selectedTab == 2 {
                    Color.blue
                } else if selectedTab == 3 {
                    Color.purple
                } else {
                    Color.orange
                }
                
                VStack(spacing: 20) {
                    Text("TAB \(selectedTab)")
                        .font(.system(size: 60, weight: .black))
                        .foregroundColor(.white)
                    
                    Text("Scroll down to see toolbar")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("⬇️⬇️⬇️")
                        .font(.system(size: 50))
                }
            }
            
            // MASSIVE YELLOW TOOLBAR
            VStack(spacing: 12) {
                Text("🟨 TOOLBAR IS HERE 🟨")
                    .font(.system(size: 24, weight: .black))
                    .padding()
                
                HStack(spacing: 0) {
                    ToolbarButton(icon: "house.fill", title: "Home", number: 0, isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    
                    ToolbarButton(icon: "calendar.circle.fill", title: "Today", number: 1, isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    
                    ToolbarButton(icon: "calendar.badge.clock", title: "Plan", number: 2, isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                    
                    ToolbarButton(icon: "chart.line.uptrend.xyaxis", title: "Prog", number: 3, isSelected: selectedTab == 3) {
                        selectedTab = 3
                    }
                    
                    ToolbarButton(icon: "ellipsis.circle.fill", title: "More", number: 4, isSelected: selectedTab == 4) {
                        selectedTab = 4
                    }
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .border(Color.black, width: 8)
        }
    }
}

struct ToolbarButton: View {
    let icon: String
    let title: String
    let number: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(number)")
                    .font(.system(size: 20, weight: .black))
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
            }
            .foregroundColor(isSelected ? .blue : .black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}
